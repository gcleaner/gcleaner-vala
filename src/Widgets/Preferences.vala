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

namespace GCleaner.Widgets {
    public class Preferences : Gtk.Dialog {
        GLib.Settings settings;
        private Notebook notebook;

        public Preferences(Gtk.Window owner) {
            set_title (Resources.PREFERENCES_FIELD);
            set_type_hint (Gdk.WindowTypeHint.DIALOG);
            set_transient_for (owner);
            set_resizable (false);
            Gtk.Widget ok_button = add_button (Resources.BUTTON_CLOSE, Gtk.ResponseType.CLOSE);
            set_default_response (Gtk.ResponseType.CLOSE);
            settings = Resources.get_setting_schema ();
            
            Gtk.Box content = new Gtk.Box (Gtk.Orientation.VERTICAL, 8);
            content.halign = Gtk.Align.FILL;
            content.valign = Gtk.Align.FILL;
            content.hexpand = false;
            content.vexpand = false;
            content.margin_top = 0;
            content.margin_bottom = 40;
            content.margin_start = 5;
            content.margin_end = 5;

            notebook = new Notebook();
            var text = "%s".printf(Resources.GENERAL_FIELD);
            var label = new Label(text);
            
            var general_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
            string desc_autorun = Resources.DESCRIPTION_AUTOSTART.printf (Resources.PROGRAM_NAME);
            var autorun_btn = new Gtk.CheckButton.with_label (desc_autorun);
            var norm_size_btn = new Gtk.CheckButton.with_label (Resources.DESCRIPTION_STANDARD_SIZE);
            autorun_btn.set_active (settings.get_boolean (Resources.PREFERENCES_AUTOSTART_KEY));
            norm_size_btn.set_active (settings.get_boolean (Resources.PREFERENCES_STANDARD_SIZE_KEY));
            this.assign_check_pressed (autorun_btn, Resources.PREFERENCES_AUTOSTART_KEY);
            this.assign_check_pressed (norm_size_btn, Resources.PREFERENCES_STANDARD_SIZE_KEY);
            general_box.pack_start (autorun_btn, false, false, 3);
            general_box.pack_start (norm_size_btn, false, false, 5);
            
            notebook.append_page (general_box, label);
            content.pack_start (notebook, false, false, 0);

            ((Gtk.Box) get_content_area()).add (content);
            ok_button.grab_focus();
            content.show_all ();

            this.response.connect((response) => {
                this.destroy ();
            });
        }

        private void assign_check_pressed (Gtk.CheckButton check, string key_xml) {
            check.toggled.connect (() => {
                if (key_xml == Resources.PREFERENCES_AUTOSTART_KEY) {
                    string home_user = GLib.Environment.get_variable ("HOME");
                    string src_file = Path.build_path (Path.DIR_SEPARATOR_S, Resources.APP_SOURCE_DIR, Resources.APP_LAUNCHER);
                    string dst_file = Path.build_path (Path.DIR_SEPARATOR_S, home_user, 
                        Resources.CONFIG_AUTOSTART_DIR, Resources.APP_LAUNCHER);
                    if (check.get_active ()) {
                        FileUtilities.copy_file (src_file, dst_file);
                    } else {
                        string[] file_to_remove = {dst_file}; // This delete the autostart desktop file.
                        FileUtilities.delete_files (file_to_remove);
                    }
                }
                settings.set_boolean (key_xml, check.get_active ());
            });
        }
    }
}
