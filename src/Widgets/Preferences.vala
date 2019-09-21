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

        public Preferences(Gtk.Window owner) {
            settings = Resources.get_setting_schema ();
            set_title ("Preferences");
            set_type_hint (Gdk.WindowTypeHint.DIALOG);
            set_transient_for (owner);
            set_resizable (false);
            Gtk.Widget ok_button = add_button ("Close", Gtk.ResponseType.CLOSE);
            set_default_response (Gtk.ResponseType.CLOSE);

            Gtk.Box content = new Gtk.Box (Gtk.Orientation.VERTICAL, 8);
            content.halign = Gtk.Align.FILL;
            content.valign = Gtk.Align.FILL;
            content.hexpand = false;
            content.vexpand = false;
            content.margin_top = 5;
            content.margin_bottom = 20;
            content.margin_start = 5;
            content.margin_end = 10;

            var general_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);            
            var language_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 10);

            Stack stack = new Gtk.Stack ();
            stack.set_transition_type (Gtk.StackTransitionType.SLIDE_LEFT_RIGHT);
            stack.set_transition_duration (10);
            stack.add_titled (general_box, "gral_tab", "General");
            stack.add_titled (language_box, "lang_tab", "Language");
            var stack_switcher = new Gtk.StackSwitcher ();
            stack_switcher.set_stack (stack);
            content.pack_start (stack_switcher, true, true, 0);
            content.pack_start (stack, true, true, 0);

            var autorun_btn = new Gtk.CheckButton.with_label ("Start " + Resources.PROGRAM_NAME + " with the System.");
            autorun_btn.set_active (settings.get_boolean (Resources.PREFERENCES_AUTOSTART_KEY));
            this.assign_check_pressed (autorun_btn, Resources.PREFERENCES_AUTOSTART_KEY);
            var norm_size_btn = new Gtk.CheckButton.with_label ("Use IEC sizes(1KiB = 1024 bytes) instead of SI(1kB = 1000 bytes)");
            norm_size_btn.set_active (settings.get_boolean (Resources.PREFERENCES_STANDARD_SIZE_KEY));
            this.assign_check_pressed (norm_size_btn, Resources.PREFERENCES_STANDARD_SIZE_KEY);
            general_box.pack_start (autorun_btn, false, false, 3);
            general_box.pack_start (norm_size_btn, false, false, 0);
            
            var language_label = new Gtk.Label ("");
            language_label.set_markup ("<b>Select your language:</b>");
            language_label.set_margin_bottom (10);
            
            Gtk.ListStore liststore = new Gtk.ListStore (1, typeof (string));
            foreach (string lang in Resources.LANGUAGES_SUPPORTED) {
                Gtk.TreeIter iter;
                liststore.append (out iter);
                liststore.set (iter, 0, capitalize (lang));
            }
            Gtk.ComboBox combobox = new Gtk.ComboBox.with_model (liststore);
            Gtk.CellRendererText cell = new Gtk.CellRendererText ();
            combobox.pack_start (cell, false);
            combobox.set_attributes (cell, "text", 0);
            combobox.set_active (0); // Set the first item in the list to be selected (active).
            combobox.margin_bottom = 5;
            
            var combo_container = new Gtk.Box (Gtk.Orientation.VERTICAL, 8);
            combo_container.pack_start (combobox, false, false, 10);
            language_box.pack_start (language_label, false, false, 0);
            language_box.pack_start (combo_container, false, false, 5);
            
            ((Gtk.Box) get_content_area()).add (content);
            ok_button.grab_focus();
            content.show_all ();

            this.response.connect((response) => {
                this.destroy ();
            });

            combobox.changed.connect ((combo) => {
                print ("You chose " + Resources.LANGUAGES_SUPPORTED [combo.get_active ()] +"\n");
            });
        }

        private void assign_check_pressed (Gtk.CheckButton check, string key_xml) {
            check.toggled.connect (() => {
                if (key_xml == Resources.PREFERENCES_AUTOSTART_KEY) {
                    string home_user = GLib.Environment.get_variable ("HOME");
                    string src_file = Resources.APP_SOURCE_DIR + "/" + Resources.APP_LAUNCHER;
                    string dst_file = home_user + Resources.CONFIG_AUTOSTART_DIR +
                        "/" + Resources.APP_LAUNCHER;
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
