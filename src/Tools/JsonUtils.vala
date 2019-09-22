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
    public class JsonUtils {
        private Parser parser;

        public JsonUtils () {
            string path = Resources.PKGDATADIR + "/resources-gcleaner.json";
            load_parser (path);
        }
        
        private void load_parser (string path) {
            parser = new Json.Parser ();
            try {
                parser.load_from_file (path);
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
            foreach (string category in Resources.CATEGORIES) {
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

        // Returns the icon name for a system app
        public string? get_icon_name_from_system_app (string app_id, string option_id) {
            string icon_name = null;
            var all_options = get_all_options_of (app_id);
            foreach (var option in all_options.get_array ().get_elements ()) {
                var object_option = option.get_object ();
                string current_option_id = object_option.get_string_member ("option-id");
                if (current_option_id == option_id) {
                    icon_name = option.get_object ().get_string_member ("option-icon");
                    return icon_name;
                }
            }
            return icon_name;
        }

        public int64 get_n_options_from (string app_id) {
            int64 number = 0;
            foreach (string category in Resources.CATEGORIES) {
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
            foreach (string category in Resources.CATEGORIES) {
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
        
        public Json.Node get_single_option_of (string app_id, string option_id) {
            Json.Node node_option = new Json.Node (Json.NodeType.ARRAY);
            Json.Array array_option = new Json.Array ();
            var all_options = get_all_options_of (app_id);
            foreach (var option in all_options.get_array ().get_elements ()) {
                if (option.get_object ().get_string_member ("option-id") == option_id) {
                    array_option.add_object_element (option.get_object ());
                    node_option.take_array (array_option);
                    return node_option;
                }
            }
            return node_option;
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
        
        public static Json.Node get_empty_node () {
            var tmp_parser = new Json.Parser ();
            tmp_parser.load_from_data ("{}");
            Json.Node node = tmp_parser.get_root ();
            return node;
        }
        
        // This returns app id and option id from app name and option name
        public string[] get_app_and_option_id_from_info (string app_name, string option_name) {
            string[] info_app = new string[2]; // [0]-> app_id   [1]-> option_id
            string category = (app_name in Resources.SYSTEM_APPS)? Resources.CATEGORY_SYSTEM : Resources.CATEGORY_APPLICATIONS;
            Json.Object obj_category = get_node_per_category (category).get_object ();
            foreach (unowned string current_app_id in obj_category.get_members ()) {
                var obj_app = obj_category.get_member (current_app_id).get_object ();
                if (obj_app.get_string_member ("name") == app_name) {
                    info_app[0] = current_app_id;
                    Json.Array all_options = get_all_options_of (current_app_id).get_array ();
                    foreach (var option in all_options.get_elements ()) {
                        string tmp_opt_name = option.get_object ().get_string_member ("option-name");
                        if (tmp_opt_name == option_name) {
                            info_app[1] = option.get_object ().get_string_member ("option-id");
                            return info_app;
                        }
                    }
                }
            }
            return info_app;
        }

        public static int64 get_info_size_by_path_query (string query, Json.Node node) {
            int64 total = 0;
            Json.Node result = Json.Path.query (query, node);
            foreach (Json.Node item in result.get_array ().get_elements ()) { // It's supposed to be a single element
                total = int64.parse(Json.to_string (item, true));
            }
            return total;
        }

        public static Json.Node insert_object_in_array (Json.Object object) {
            Json.Array array = new Json.Array ();
            Json.Node node = new Json.Node (Json.NodeType.ARRAY);
            array.add_object_element (object);
            node.take_array (array);
            return node;
        }
    }
}
