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

using GLib;
using Json;

namespace GCleaner.Tools {
    public class JsonLoader {
        private Parser parser;
        private string[] categories = { "applications", "system" };

        public JsonLoader () {
            load_json ();
        }

        private void load_json () {
            parser = new Json.Parser ();
            try {
                parser.load_from_file (Constants.PKGDATADIR + "/resources-gcleaner.json");
            } catch (Error e) {
                stderr.printf ("Unable to parse: %s\n", e.message);
            }
        }
        
        public Json.Node get_node_per_category (string category) {
            Json.Object root_object = parser.get_root ().get_object ();
            Json.Node node = root_object.get_member (category);
            return node;
        }
        
        // Returns the type, icon name or application name.
        public string? get_item_from_app (string app_id, string item) {
            string result = null;

            foreach (string category in categories) {
                Json.Object obj_category = get_node_per_category (category).get_object ();
                foreach (unowned string current_app_id in obj_category.get_members ()) {
                    if (app_id == current_app_id) {
                        var obj_app = obj_category.get_member (current_app_id).get_object ();
                        result = obj_app.get_string_member (item);
                        return result;
                    }
                }
            }

            return result;
        }

        public int64 get_n_options_from (string app_id) {
            int64 number = 0;
            foreach (string category in categories) {
                Json.Object obj_category = get_node_per_category (category).get_object ();
                foreach (unowned string current_app_id in obj_category.get_members ()) {
                    if (app_id == current_app_id) {
                        var obj_app = obj_category.get_member (current_app_id).get_object ();
                        number = obj_app.get_int_member ("number-options");
                        return number;
                    }
                }
            }
            return number;
        }
        
        public Json.Node get_all_options_of (string app_id) {
            Json.Node all_options = null;
            foreach (string category in categories) {
                Json.Object obj_category = get_node_per_category (category).get_object ();
                foreach (unowned string current_app_id in obj_category.get_members ()) {
                    if (app_id == current_app_id) {
                        var obj_app = obj_category.get_member (current_app_id).get_object ();
                        all_options = obj_app.get_member ("all-options");
                        
                        return all_options;
                    }
                }
            }
            return all_options;
        }
        
        public Json.Node get_all_commands_of (string app_id, string option_id) {
            Json.Node commands = null;
            Json.Array all_options = get_all_options_of (app_id).get_array ();
            foreach (Json.Node option in all_options.get_elements ()) {
                Json.Object object_option = option.get_object ();
                if (option_id == object_option.get_string_member ("option-id")) {
                    // This is because it contains only one object
                    commands = object_option.get_array_member ("commands").get_element (0);
                    
                    return commands;
                }
            }
            return commands;
        }
    }
}
