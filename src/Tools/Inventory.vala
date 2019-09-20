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
using GLib;
using Json;

namespace GCleaner.Tools {
    public class Inventory {
        private static Inventory instance = null;
        private Json.Node info_data;
        private string[] fields = {"file-number", "size"};
        private int _length;

        private Inventory () {
            _length = 0;
            info_data = JsonUtils.get_empty_node ();
        }
        
        public static Inventory get_instance () {
            if (instance == null) {
                instance = new Inventory ();
            }
            return instance;
        }
        
        public void empty_data () {
            _length = 0;
            info_data = JsonUtils.get_empty_node ();
        }

        public int length {
            get { 
                var object = info_data.get_object ();
                _length = (int) object.get_size ();
                return _length; 
            }
            protected set {}
        }

        public void update_data (string app_id, string option_id, int64[] information) {
            var main_object = info_data.get_object ();
            var object = new Json.Object ();
            for (int i = 0; i < fields.length; i++) {
                object.set_int_member (fields[i], information[i]);
            }
            Json.Node node_array = JsonUtils.insert_object_in_array (object);
            string key = app_id + "-" + option_id;
            main_object.set_array_member (key, node_array.get_array ());
            info_data.take_object (main_object); // Update info_data json
        }

        protected int64 get_info_given_fields (string app_id, string option_id, string field) {
            string query = "$.%s-%s[*].%s".printf (app_id, option_id, field);
            int64 result = JsonUtils.get_info_size_by_path_query (query, this.info_data);
            return result;
        }

        public int64 get_file_size_of (string app_id, string option_id) {
            string field = "size";
            int64 file_size = get_info_given_fields (app_id, option_id, field);
            return file_size;
        }

        public int64 get_file_number_of (string app_id, string option_id) {
            string field = "file-number";
            int64 file_number = get_info_given_fields (app_id, option_id, field);
            return file_number;
        }
    }
}

