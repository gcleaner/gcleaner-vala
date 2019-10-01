/* Copyright 2018 Juan Pablo Lozano
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

using Json;
using Gtk;
using GLib;
using GCleaner.Tools;

namespace GCleaner.Widgets {
    public class Sidebar : Box {
        public GCleaner.App app;
        private Cleaner[] list_cleaners = {};
        public Box apps_box;
        public Box system_box;
        public int count_apps = 0;
        
        public Sidebar (GCleaner.App app) {
            this.app = app;
            
            // BOXES:
            Box sidebar_box = new Box (Orientation.VERTICAL, 0); // Box containing the CheckBox of the different areas to be cleaned
            sidebar_box.border_width = 12; // Value established in the HIG (Human Interface Guidelines) of ElementaryOS
            this.add (sidebar_box);
            
            apps_box = new Box (Orientation.VERTICAL, 0);
            system_box = new Box (Orientation.VERTICAL, 0);
            
            // ALIGNAMENT AND SCROLLEDWINDOW:
            Gtk.Alignment alignament = new Gtk.Alignment (0.0f, 0.5f, 0f, 1f);
            Gtk.ScrolledWindow scrolled = new Gtk.ScrolledWindow (null , null);
            scrolled.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
            scrolled.set_size_request (225, 400);
            alignament.add (scrolled);
            scrolled.add_with_viewport (apps_box);
            
            // STACK:
            Gtk.Stack stack = new Gtk.Stack ();
            stack.set_transition_type (Gtk.StackTransitionType.SLIDE_LEFT_RIGHT);
            stack.set_transition_duration (500);
            stack.add_titled (system_box, "system_tab", capitalize (Resources.CATEGORY_SYSTEM));
            stack.add_titled (alignament, "apps_tab", capitalize (Resources.CATEGORY_APPLICATIONS));
            
            Gtk.StackSwitcher stack_switcher = new Gtk.StackSwitcher ();
            stack_switcher.set_stack (stack);
            sidebar_box.pack_start (stack_switcher, false, false, 0);
            sidebar_box.pack_start (stack, true, true, 0);
            
            // ALL CHECKBOXS - CHECK IF EXIST THEN ADD IT
            // **********************************************************************************
            var parser = new JsonUtils ();

            foreach (string category in Resources.CATEGORIES) {
                Json.Object obj_category = parser.get_node_per_category (category).get_object ();
                
                string type_icon = (category == Resources.CATEGORY_APPLICATIONS) ? Resources.TYPE_ICON_APPS : Resources.TYPE_ICON_SYSTEM;

                foreach (unowned string app_id in obj_category.get_members ()) {
                    var obj_app = obj_category.get_member (app_id).get_object ();
                    
                    if (comprobe_if_exists_app (app_id)) {
                        string rsc_icon = "";
                        int64 n_options = obj_app.get_int_member (Resources.PROPERTY_N_OPTIONS);
                        Image program_icon;

                        if (obj_app.has_member (Resources.PROPERTY_APP_ICON)) {
                            rsc_icon = obj_app.get_string_member (Resources.PROPERTY_APP_ICON);
                            program_icon = new Image.from_icon_name (rsc_icon, Gtk.IconSize.SMALL_TOOLBAR);
                        } else {
                            rsc_icon = GLib.Path.build_path (GLib.Path.DIR_SEPARATOR_S, Resources.PKGDATADIR, "media", type_icon, app_id + ".png");
                            program_icon = load_image_from_path (rsc_icon);
                        }

                        Box main_box = new Box(Orientation.HORIZONTAL, 0);  // This is to show the title of the program
                        Box options_box = new Box(Orientation.VERTICAL, 0); // This is to out all the program options
                        Box container_box = new Box(Orientation.HORIZONTAL, 0);
                        
                        // We create the group of check buttons
                        // ************************************
                        list_cleaners += new Cleaner (this.app, app_id);
                        
                        // We package in the corresponding BOX
                        main_box.pack_start (program_icon, false, false, 2);
                        main_box.pack_start (list_cleaners[count_apps].get_check_root (), false, false, 0);
                        
                        // We add the main button with its respective category.
                        if (category == Resources.CATEGORY_APPLICATIONS)
                            apps_box.pack_start (main_box, false, false, 0);
                        else
                            system_box.pack_start (main_box, false, false, 0);

                        // We add the rest of the options.
                        for (int i = 0; i < n_options; i++) {
                            options_box.pack_start(list_cleaners[count_apps].get_check_option_by_index(i), false, false, 0);
                        }
                        // We packed it in another one.
                        container_box.pack_start(options_box, false, false, 20);
                        
                        // We add it back to the box that corresponds to it.
                        if (category == Resources.CATEGORY_APPLICATIONS)
                            apps_box.pack_start (container_box, false, false, 4);
                        else
                            system_box.pack_start (container_box, false, false, 4);

                        // Count the number of programs
                        count_apps++;
                    }
                }
            }
            
            sidebar_box.show_all();
        }

        public Cleaner[] get_list_cleaners () {
            return list_cleaners;
        }

        public Cleaner get_cleaner_by_id (string app_id) {
            Cleaner cleaner = null;
            int i = 0;
            while (cleaner == null && i < list_cleaners.length) {
                if (list_cleaners[i].app_id == app_id) {
                    cleaner = list_cleaners[i];
                }
                i++;
            }
            return cleaner;
        }

        public int get_number_installed_apps () {
            return list_cleaners.length;
        }
    }
}
