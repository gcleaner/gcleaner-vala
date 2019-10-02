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

using Gtk;
using GLib;
using Json;

namespace GCleaner.Tools {
    public class InfoClean {
        //Variables by search criteria *************************************************************
        private Inventory inventory;
        private int64 _total_counter; // Total number of scanned files.
        private int64 _total_accumulator; // Total weight of scanned files.
        // This variable is updated every time 
        // a application/system option is counted.
        private int _n_scanned_items;

        public void InfoClean () {
            reset_values ();
        }
        
        // Set the values to zero when the buttons are pressed
        public void reset_values () {
            total_counter = 0;
            total_accumulator = 0;
            n_scanned_items = 0;
            inventory = Inventory.get_instance ();
            inventory.empty_data ();
        }
        
        public int64 total_counter {
            get { return _total_counter; }
            set { _total_counter = value; }
        }
        public int64 total_accumulator {
            get { return _total_accumulator; }
            set { _total_accumulator = value; }
        }
        public int n_scanned_items {
            get { return _n_scanned_items; }
            set { _n_scanned_items = value; }
        }

        // SIMPLE SCAN OPTION ************************************************************************
        // Scan any option, either a system option or an application option
        public void simple_scan (string app_id, string option_id, string[] paths) {
            int64[] information = new int64[2]; //[0] -> Number of files / [1] -> Folder weight in Bytes
            information = FileUtilities.generate_info_paths (app_id, option_id, paths);
            
            // We update the main values
            total_counter = total_counter + information[0];
            total_accumulator = total_accumulator + information[1];
            insert_info_data (app_id, option_id, information);
        }

        // ADVANCED SCAN OPTION ************************************************************************
        // This scans options such as package caches, old kernels, etc. 
        // These are options that need other types of management and privileges.
        public void advanced_scan (string app_id, string option_id, string cmd_quantity, string? cmd_size = null) {
            int64[] information = new int64[2]; //[0] -> Number of files / [1] -> Folder weight in Bytes
            string str_number = run_basic_command (cmd_quantity);
            string str_size = (cmd_size != null) ? run_basic_command (cmd_size) : "0";
            int file_number = (str_number != null) ? int.parse (str_number) : 0;
            int file_size = (str_size != null) ? int.parse (str_size) : 0;

            information[0] = file_number;
            information[1] = file_size;
            total_counter += information[0];
            total_accumulator += information[1];
            insert_info_data (app_id, option_id, information);
        }

        public bool clean_operation (string app_id, string option_id, string[]? paths = null, string? cmd_clean = null, string? cmd_quantity = null, string? cmd_size = null) {
            bool status;
            if (cmd_clean == null)
                status = simple_clean (app_id, option_id, paths);
            else
                status = advanced_clean (app_id, option_id, cmd_clean, cmd_quantity, cmd_size);
            return status;
        }

        public bool simple_clean (string app_id, string option_id, string[] paths) {
            bool status = true;
            int64[] information = new int64[2]; //[0] -> Number of files / [1] -> Folder weight in Bytes
            information = FileUtilities.delete_files (paths);

            // Increase the values
            total_counter += information[0];
            total_accumulator += information[1];
            insert_info_data (app_id, option_id, information);
            return status;
        }

        public bool advanced_clean (string app_id, string option_id, string cmd_clean, string cmd_quantity, string? cmd_size = null) {
            bool status = false;
            int64[] information = {0, 0}; //[0] -> Number of files / [1] -> Folder weight in Bytes
            string error;
            try {
                Process.spawn_command_line_sync ("bash -c \"" + cmd_clean + "\"", null, out error, null);
                string str_number = run_basic_command (cmd_quantity);
                string str_size = (cmd_size != null) ? run_basic_command (cmd_size) : "0";
                information[0] = (str_number != null) ? int.parse (str_number) : 0;
                information[1] = (str_size != null) ? int.parse (str_size) : 0;
                total_counter += information[0];
                total_accumulator += information[1];
                status = true;
            } catch (GLib.SpawnError e) {
                stdout.printf ("Error: %s\n", error);
                status = false;
            }
            insert_info_data (app_id, option_id, information);
            return status;
        }

        public void insert_info_data (string app_id, string option_id, int64[] information) {
            inventory.update_data (app_id, option_id, information);
        }

        public int64 get_file_size_of (string app_id, string option_id) {
            int64 file_size = inventory.get_file_size_of (app_id, option_id);
            return file_size;
        }

        public int64 get_file_number_of (string app_id, string option_id) {
            int64 file_number = inventory.get_file_number_of (app_id, option_id);
            return file_number;
        }
    }
}
