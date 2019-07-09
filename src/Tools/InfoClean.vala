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

namespace GCleaner.Tools {
    public class InfoClean {
        //Variables by search criteria *************************************************************
        //total_counter and total_accumulator
        private int64 total_counter;
        private int64 total_accumulator;
        private SqliteUtils sql_util;
        
        
        //This variable is updated every time 
        //a application/system option is counted.
        private int n_scanned_items;

        public void InfoClean () {
            setting_values ();
            sql_util = new SqliteUtils ();
        }
        
        //To set the values to zero when we press the Scan button
        public void setting_values () {
            total_counter = 0;
            total_accumulator = 0;
            n_scanned_items = 0;
        }
        
        public int64 get_total_counter ()               { return total_counter; }
        public void set_total_counter (int64 val)       { total_counter = val; }
        public int64 get_total_accumulator ()           { return total_accumulator; }
        public void set_total_accumulator (int64 val)   { total_accumulator = val; }
        public int get_n_scanned_apps ()               { return n_scanned_items; }
        public void set_n_scanned_apps (int val = 1)   { n_scanned_items += val; }
        
        // SIMPLE SCAN OPTION ************************************************************************
        // Scan any option, either a system option or an application option
        public void simple_scan (string app_id, string option_id, string[] paths) {
            int64[] information = new int64[2]; //[0] -> Number of files / [1] -> Folder weight in Bytes
            
            // Method for obtaining size and number of files
            information = FileUtilities.generate_info_paths (app_id, option_id, paths);
                        
            // We update the main values
            total_counter = total_counter + information[0];
            total_accumulator = total_accumulator + information[1];
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
        }

        public bool clean_operation (string app_id, string option_id, string? cmd_clean = null) {
            bool status;
            if (cmd_clean != null)
                status = simple_clean (app_id, option_id);
            else
                status = advanced_clean (app_id, option_id, cmd_clean);
            return status;
        }

        public bool simple_clean (string app_id, string option_id) {
            bool status = true;
            int64[] information = new int64[2]; //[0] -> Number of files / [1] -> Folder weight in Bytes
            string[] paths = null;
            
            paths = sql_util.get_all_paths_of (app_id, option_id);
            information = FileUtilities.delete_files (paths);

            // We decrement the values
            total_counter += information[0];
            total_accumulator += information[1];
            return status;
        }

        public bool advanced_clean (string app_id, string option_id, string cmd_clean) {
            bool status = false;
            string error;

            try {
                Process.spawn_command_line_sync ("bash -c \"" + cmd_clean + "\"", null, out error, null);
                int64 file_number = get_file_number_of (app_id, option_id);
                int64 file_size = get_file_size_of (app_id, option_id);
                total_counter += file_number;
                total_accumulator += file_size;
                return true;
            } catch (GLib.SpawnError e) {
                stdout.printf ("COM.GCLEANER: %s", e.message);
                stdout.printf ("[ERROR: %s]\n", error);
                return status;
            }
        }

        public int64 get_file_size_of (string app_id, string option_id) {
            int64 file_size = sql_util.get_file_size_of (app_id, option_id);
            return file_size;
        }

        public int64 get_file_number_of (string app_id, string option_id) {
            int64 file_number = sql_util.get_file_number_of (app_id, option_id);
            return file_number;
        }

        private string run_basic_command (string cmd) {
            string result = null;
            string error;
            int status;
            try {
                Process.spawn_command_line_sync ("bash -c \"" + cmd + "\"", out result, out error, out status);
                return result;
            } catch (GLib.SpawnError e) {
                stdout.printf ("COM.GCLEANER: %s", e.message);
                return result;
            }
        }
    }
}
