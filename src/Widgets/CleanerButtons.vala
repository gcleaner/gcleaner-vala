/* Copyright 2019 Andrés Segovia
*
* This file is part of GCleaner.
*
* GCleaner is free software: you can redistribute it
* and/or modify it under the terms of the GNU General Public License as
* published by the Free Software Foundation, either version 3 of the
* License, or (at your option) any later version.
*
* GCleaner is distributed in the hope that it will be
* useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
* Public License for more details.
*
* You should have received a copy of the GNU General Public License along
* with GCleaner. If not, see http://www.gnu.org/licenses/.
*/

using Gtk;
using Gdk;
using GLib;
using GCleaner.Tools;

namespace GCleaner.Widgets {
    public class CleanerButtons {
        public GCleaner.App app;
        private bool _check_root_is_clicked;
        private string app_id;
        private string app_name;
        private int64 n_options;
        private GLib.Settings settings;
        
        
        private Gtk.CheckButton check_root;
        private Gtk.CheckButton[] check_options = {};
        
        public CleanerButtons (GCleaner.App app, string app_id) {
            this.app = app;
            this.app_id = app_id;
            check_root_is_clicked = false;
            settings = new GLib.Settings ("org.gcleaner");
            this.load_init ();
        }
        
        private void load_init () {
            var jload = new JsonUtils ();
            app_name = jload.get_item_from_app (app_id, "name");
            n_options = jload.get_n_options_from (app_id);
            string key_xml = app_id + "-main";
            // Setting the main check
            check_root = new Gtk.CheckButton.with_label (app_name);
            configure_check_root (key_xml);
            check_root.set_active (settings.get_boolean (key_xml));
            // Setting option checks
            configure_checks_options ();
        }

        public string get_name ()       { return app_name; }
        public string get_id ()         { return app_id; }
        public bool check_root_is_clicked {
            get { return _check_root_is_clicked; }
            set { _check_root_is_clicked = value; }
        }
        
        public Gtk.CheckButton get_check_root () {
            return this.check_root;
        }

        public Gtk.CheckButton get_check_option_by_index (int index) {
            return this.check_options[index];
        }
        private void configure_check_root (string str_xml) {
            check_root.released.connect (() => {
                check_root_is_clicked = true;
                if (check_root.active == true) {
                    for (int i = 0; i < n_options; i++) {
                        check_options[i].set_active (true);
                    }
                } else {
                    for (int i = 0; i < n_options; i++) {
                        check_options[i].set_active (false);
                    }
                }
                
                check_root_is_clicked = false;
                settings.set_boolean (str_xml, check_root.active);
            });
            
            // This is to save its status
            check_root.toggled.connect (() => {
                settings.set_boolean (str_xml, check_root.get_active ());
            });
            
            // We establish a tooltip
            set_tooltip_root ();
            set_context_menu (check_root, app_id);
        }
        
        private void configure_checks_options () {
            var jload = new JsonUtils ();
            
            int count = 0;
            Json.Node all_options = jload.get_all_options_of (app_id);
            foreach (var option in all_options.get_array ().get_elements ()) {
                var object_option = option.get_object ();
                
                string option_id = object_option.get_string_member ("option-id");
                string option_label = object_option.get_string_member ("option-name");
                string key_xml = object_option.get_string_member ("key-xml");
                bool warning_value = object_option.get_boolean_member ("warning-msgdlg");

                string option_info = determine_tooltip_text (option_id, warning_value);
                string icon_warning_name = determine_warning_icon (warning_value);
                check_options += new Gtk.CheckButton.with_label (option_label);
                check_options[count].set_active (settings.get_boolean (key_xml));
                assign_check_pressed (check_options[count], key_xml);
                set_tooltip_options (check_options[count], icon_warning_name, option_info);
                set_context_menu (check_options[count], app_id, option_id);

                //We're checking to see if there's any option to display a warning message
                if (warning_value == true) {
                    string question = build_question_for_msgdlg (option_id);
                    set_msgdlg_warning (check_options[count], key_xml, question);
                }

                count++;
            }
        }

        private void assign_check_pressed (Gtk.CheckButton check, string key_xml) {
            check.toggled.connect (() => {
                bool is_any_btn_active = false;
                if (check_root_is_clicked == false) {
                    for (int i = 0; i < n_options; i++) {
                        //If any button is pressed the main button is activated
                        if (check_options[i].active == true) {
                            is_any_btn_active = true;
                        }
                    }
                    
                    if (is_any_btn_active) {
                        check_root.set_active (true);
                    } else {
                        check_root.set_active (false);
                    }
                }
                settings.set_boolean (key_xml, check.get_active ());
            });
        }
        
        private string build_question_for_msgdlg (string option_id) {
            string question = "";
            if (option_id == "pass") {
                question = "Are you sure you want to delete the saved passwords from " + app_name + "?";
            } else if (option_id == "cache-pkg") {
                question = "Are you sure you want to delete the cache and obsolete files from Package System?";
            } else if (option_id == "configuration-pkg") {
                question = "Are you sure you want to delete the orphan packages from Package System?";
            } else if (option_id == "old-kernels") {
                question = "Are you sure you want to delete the old kernels?";
            }
            
            return question;
        }

        public void set_msgdlg_warning (CheckButton check, string key_xml, string question) {
            check.toggled.connect (() => {
                if (check.active == true) {
                    Gtk.MessageDialog msg_dialog = new Gtk.MessageDialog (this.app.main_window, Gtk.DialogFlags.MODAL, Gtk.MessageType.WARNING, Gtk.ButtonsType.OK_CANCEL, question);
                    msg_dialog.response.connect ((response_id) => {
                        if (response_id == Gtk.ResponseType.OK) {
                            check.set_active (true);
                        } else {
                            check.set_active (false);
                        }
                        msg_dialog.destroy ();
                    });
                    msg_dialog.show ();
                }
                settings.set_boolean (key_xml, check.get_active ());
            });
        }

        private void set_tooltip_root () {
            var jload = new JsonUtils ();
            string text_icon = determine_app_icon ();
            string program_type = jload.get_item_from_app (app_id, "type");
            
            check_root.has_tooltip = true;
            check_root.query_tooltip.connect ((x, y, keyboard_tooltip, tooltip) => {
                if (text_icon.contains ("package") || text_icon.contains ("system")) {
                    tooltip.set_icon_from_icon_name (text_icon, Gtk.IconSize.DIALOG); 
                } else {
                    Pixbuf icon = load_pixbuf (text_icon, 48);
                    tooltip.set_icon (icon); 
                }
                
                tooltip.set_markup ("<b>" + this.app_name + "</b>\n\n<i>" + program_type + "</i>");
                return true;
            });
        }

        private string determine_app_icon () {
            var jload = new JsonUtils ();
            string text_icon = "";
            
            if (app_id == "apt" || app_id == "system") {
                text_icon = jload.get_item_from_app (app_id, "icon");
            } else {
                text_icon = Constants.PKGDATADIR + "/media/apps/" + app_id + ".png";
            }

            return text_icon;
        }

        private void set_context_menu (Gtk.CheckButton check, string app_id, string? option_id = null) {
            check.button_press_event.connect ((event) => {
                if (event.type == EventType.BUTTON_PRESS && event.button == 3) {
                    string[] items = {"Analyze", "Clean"};
                    string text_name = (option_id == null)? app_name : check.label.down ();
                    Gtk.Menu menu = new Gtk.Menu ();
                    menu.attach_to_widget (check, null);
                    var actions = Actions.get_instance ();
                    foreach (string item in items) {
                        Gtk.MenuItem menu_item = new Gtk.MenuItem.with_label ("%s %s".printf(item, text_name));
                        menu.add (menu_item);
                        menu_item.activate.connect ((event) => {
                            bool really_delete = (item == "Clean")? true : false;
                            if (really_delete) {
                                Gtk.MessageDialog msg = new Gtk.MessageDialog (this.app.main_window, Gtk.DialogFlags.MODAL, Gtk.MessageType.WARNING, Gtk.ButtonsType.OK_CANCEL, "Are you sure you want to continue?");
                                msg.response.connect ((response_id) => {
                                    if (response_id == Gtk.ResponseType.OK) {
                                        actions.run_selected_option (app_id, option_id, really_delete);
                                    }
                                    msg.destroy ();
                                });
                                msg.show ();
                            } else {
                                actions.run_selected_option (app_id, option_id, false);
                            }
                        });
                    }
                    menu.show_all ();
                    menu.popup (null, null, null, event.button, event.time);
                }
                return false;
            });
        }

        private void set_tooltip_options (Gtk.CheckButton check, string icon, string info) {
            check.has_tooltip = true;
            check.query_tooltip.connect ((x, y, keyboard_tooltip, tooltip) => {
                tooltip.set_icon_from_icon_name (icon, Gtk.IconSize.LARGE_TOOLBAR); 
                tooltip.set_markup (info);
                return true;
            });
        }

        private string determine_warning_icon (bool warning_value) {
            if (warning_value == true) {
                return "dialog-warning";
            } else {
                return "dialog-information";
            }
        }
        
        private string determine_tooltip_text (string id_option, bool warning_value) {
            string warning_text = "";
            string tooltip_text = "";
            
            if (id_option == "backup") {
                tooltip_text = Constants.BACKUP_INFO;
            } else if (id_option == "cache") {
                tooltip_text = Constants.CACHE_PROG_INFO;
            } else if (id_option == "cache-pkg") {
                tooltip_text = Constants.CACHE_PKG_INFO;
            } else if (id_option == "chat-logs") {
                tooltip_text = Constants.CHAT_LOGS_INFO;
            } else if (id_option == "configuration-pkg") {
                tooltip_text = Constants.CONF_PKG_INFO;
            } else if (id_option == "cookies") {
                tooltip_text = Constants.COOKIES_INFO;
            } else if (id_option == "crash") {
                tooltip_text = Constants.CRASH_INFO;
            } else if (id_option == "docs" || id_option == "recent-docs") {
                tooltip_text = Constants.DOCS_INFO;
            } else if (id_option == "dom") {
                tooltip_text = Constants.DOM_INFO;
            } else if (id_option == "download") {
                tooltip_text = Constants.DOWNLOAD_INFO;
            } else if (id_option == "form-history") {
                tooltip_text = Constants.SAVED_FORMHISTORY_INFO;
            } else if (id_option == "history") {
                tooltip_text = Constants.HISTORY_PROG_INFO;
            } else if (id_option == "internet-history") {
                tooltip_text = Constants.HISTORY_NET_INFO;
            } else if (id_option == "internet-cache") {
                tooltip_text = Constants.CACHE_NET_INFO;
            } else if (id_option == "logs") {
                tooltip_text = Constants.LOGS_INFO;
            } else if (id_option == "old-kernels") {
                tooltip_text = Constants.OLDKERNELS_INFO;
            } else if (id_option == "pass") {
                tooltip_text = Constants.PASS_INFO;
            } else if (id_option == "places") {
                tooltip_text = Constants.PLACES_INFO;
            } else if (id_option == "prefs") {
                tooltip_text = Constants.PREFS_INFO;
            } else if (id_option == "session") {
                tooltip_text = Constants.SESSION_INFO;
            } else if (id_option == "terminal-history") {
                tooltip_text = Constants.TERMINAL_INFO;
            } else if (id_option == "tmp") {
                tooltip_text = Constants.TMP_INFO;
            } else if (id_option == "thumbnails") {
                tooltip_text = Constants.THUMBNAILS_INFO;
            } else if (id_option == "trash") {
                tooltip_text = Constants.TRASH_INFO;
            } else if (id_option == "used") {
                tooltip_text = Constants.USED_INFO;
            }
            
            if (warning_value == true) {
                warning_text = Constants.WARNING_HIGH_INFO;
            } else {
                warning_text = Constants.WARNING_LOW_INFO;
            }
            
            return tooltip_text + warning_text;
        }
    }
}
