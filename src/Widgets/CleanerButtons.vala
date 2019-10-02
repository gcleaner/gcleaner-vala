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
            settings = Resources.get_setting_schema ();
            this.load_init ();
        }
        
        private void load_init () {
            var jload = new JsonUtils ();
            app_name = jload.get_item_from_app (app_id, Resources.PROPERTY_APP_NAME);
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
                
                string option_id = object_option.get_string_member (Resources.PROPERTY_OPTION_ID);
                string option_label = Resources.get_option_label (option_id);
                string key_xml = object_option.get_string_member (Resources.PROPERTY_KEY);
                bool warning_value = object_option.get_boolean_member (Resources.PROPERTY_WARNING);

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
        
        private string build_question_for_msgdlg (string option_id_type) {
            return Resources.get_question_phrase (option_id_type, app_name);
        }

        public void set_msgdlg_warning (CheckButton check, string key_xml, string question) {
            check.toggled.connect (() => {
                if (check.active == true) {
                    Gtk.MessageDialog msg_dialog = new Gtk.MessageDialog (this.app.main_window, Gtk.DialogFlags.MODAL, 
                        Gtk.MessageType.WARNING, Gtk.ButtonsType.OK_CANCEL, question);
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
            string id_app_type = jload.get_item_from_app (app_id, Resources.PROPERTY_APP_TYPE);
            string app_type = Resources.get_type_app (id_app_type);
            check_root.has_tooltip = true;
            check_root.query_tooltip.connect ((x, y, keyboard_tooltip, tooltip) => {
                if (text_icon.contains (Resources.ICON_PACKAGE_GENERIC) || 
                    text_icon.contains (Resources.ICON_APPLICATIONS_SYSTEM)) {
                    tooltip.set_icon_from_icon_name (text_icon, Gtk.IconSize.DIALOG); 
                } else {
                    Pixbuf icon = load_pixbuf (text_icon, 48);
                    tooltip.set_icon (icon); 
                }
                
                tooltip.set_markup ("<b>" + this.app_name + "</b>\n\n<i>" + app_type + "</i>");
                return true;
            });
        }

        private string determine_app_icon () {
            string text_icon = null;
            if (app_id in Resources.SYSTEM_APPS) {
                var jload = new JsonUtils ();
                text_icon = jload.get_item_from_app (app_id, Resources.PROPERTY_APP_ICON);
            } else {
                text_icon = Path.build_path (Path.DIR_SEPARATOR_S, Resources.PKGDATADIR, "media", "apps", app_id + ".png");
            }

            return text_icon;
        }

        private void set_context_menu (Gtk.CheckButton check, string app_id, string? option_id = null) {
            check.button_press_event.connect ((event) => {
                if (event.type == EventType.BUTTON_PRESS && event.button == 3) {
                    string[] items = {Resources.BUTTON_SCAN, Resources.BUTTON_CLEAN}; // Labels
                    string text_name = (option_id == null) ? app_name : check.label.down ();
                    Gtk.Menu menu = new Gtk.Menu ();
                    menu.attach_to_widget (check, null);
                    var actions = Actions.get_instance ();
                    foreach (string item in items) {
                        Gtk.MenuItem menu_item = new Gtk.MenuItem.with_label ("%s %s".printf(item, text_name));
                        menu.add (menu_item);
                        menu_item.activate.connect ((event) => {
                            bool really_delete = (item == Resources.BUTTON_CLEAN) ? true : false;
                            if (really_delete) {
                                Gtk.MessageDialog msg = new Gtk.MessageDialog (this.app.main_window, Gtk.DialogFlags.MODAL, 
                                    Gtk.MessageType.WARNING, Gtk.ButtonsType.OK_CANCEL, Resources.QUESTION_PHRASE_CLEAN);
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

        private string determine_warning_icon (bool is_warning) {
            if (is_warning)
                return Resources.ICON_DIALOG_WARNING;
            else
                return Resources.ICON_DIALOG_INFORMATION;
        }
        
        private string determine_tooltip_text (string id_option_type, bool high_warning = false) {
            string description_text = Resources.get_description_info (id_option_type);
            string warning_text = "";
            if (high_warning)
                warning_text = Resources.DESCRIPTION_WARNING_HIGH_LABEL;
            else
                warning_text = Resources.DESCRIPTION_WARNING_LOW_LABEL;
            
            return description_text + warning_text;
        }
    }
}
