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

namespace GCleaner.Tools {
    public async int print_results (InfoClean info_clean, int n_installed_apps) throws ThreadError {
        SourceFunc print_callback = print_results.callback;
        
        ThreadFunc<void*> run = () => {
            
            while (info_clean.get_n_scanned_apps () < n_installed_apps) {}
            
            Idle.add((owned) print_callback);
            Thread.exit (1.to_pointer ());
            return null;
        };
        Thread<void*> print_thread = new Thread<void*> ("print_thread", run);
        yield;
        return 1;
    }

    public async int analyze_all_process (GCleaner.App app, Cleaner[] list_cleaners, InfoClean info_clean, GCleaner.Widgets.ResultsArea results_area) throws ThreadError {
        SourceFunc analyze_callback = analyze_all_process.callback;
        ThreadFunc<void*> run = () => {
            Timeout.add (50, () => {
                var list_store = results_area.get_list_store ();
                list_store.foreach ((model, path, iter) => {
                    Value val;
                    list_store.get_value (iter, 1, out val);
                    val.set_int (val.get_int () + 1);
                    list_store.set_value (iter, 1, val);
                    return false;
                });
                return true;
            });
            
            var jload = new GCleaner.Tools.JsonLoader ();
            foreach (var cleaner in list_cleaners) {
                if (cleaner.is_active ()) {
                    string app_id = cleaner.app_id;
                    string app_name = cleaner.get_app_name ();
                    int count = 0;
                    
                    Json.Node all_options = jload.get_all_options_of (app_id);
                    foreach (var option in all_options.get_array ().get_elements ()) {
                        var object_option = option.get_object ();
                        
                        string option_id = object_option.get_string_member ("option-id");
                        string option_name = object_option.get_string_member ("option-name");
                        
                        if (cleaner.get_option_label (count) == option_name && cleaner.is_option_active (count)) {
                            string[] advanced_options = {"cache-pkg", "configuration-pkg", "old-kernels"};
                            /* Update the progress bar
                             * ++++++-----------------------------
                             */
                            app.update_progress (app_name, option_name);
                            
                            if (option_id in advanced_options) { // The option contains commands
                                Json.Node node_cmd = jload.get_all_commands_of (app_id, option_id);
                                var object_cmd = node_cmd.get_object ();

                                string cmd_size = (object_cmd.has_member ("get-size")) ? object_cmd.get_string_member ("get-size") : null;
                                string cmd_quantity = object_cmd.get_string_member ("get-quantity");

                                info_clean.advanced_scan (app_id, option_id, cmd_quantity, cmd_size);
                            } else { // Option only contains paths
                                string[] paths_to_scan = {}; // It will contain the reinterpreted paths
                                string[] current_option_paths = {};
                                // Get all the paths to scan of the option
                                foreach (var dir in object_option.get_array_member ("paths").get_elements ()) {
                                    current_option_paths += dir.get_string ();
                                }
                                // We save in an array the paths that have been reinterpreted.
                                paths_to_scan = FileUtilities.reinterpret_paths (current_option_paths);
                                if (paths_to_scan[0] != "null")
                                    info_clean.simple_scan (app_id, option_id, paths_to_scan);
                            }
                        }
                        count++;
                    }
                }
            }
            Idle.add((owned) analyze_callback);
            Thread.exit (1.to_pointer ());
            return null;
        };
        Thread<void*> analyze_all_thread = new Thread<void*> ("analyze_all_thread", run);
        yield;
        return 1;
    }

    public async bool clean_process (GCleaner.App app, Cleaner[] list_cleaners, InfoClean info_clean) throws ThreadError {
        SourceFunc clean_callback = clean_process.callback;
        // Used to manage the way final results are displayed
        bool no_errors = true;
        ThreadFunc<void*> run = () => {
            var jload = new GCleaner.Tools.JsonLoader ();
            
            foreach (var cleaner in list_cleaners) {
                if (cleaner.is_active ()) {
                    string app_id = cleaner.app_id;
                    string app_name = cleaner.get_app_name ();
                    string[] system_apps = {"apt", "system"};
                    string category = (app_id in system_apps) ? "system" : "applications";
                    int count = 0;
                    
                    Json.Node all_options = jload.get_all_options_of (app_id);
                    foreach (var option in all_options.get_array ().get_elements ()) {
                        var object_option = option.get_object ();
                        
                        string option_id = object_option.get_string_member ("option-id");
                        string option_name = object_option.get_string_member ("option-name");
                        
                        if (cleaner.get_option_label (count) == option_name && cleaner.is_option_active (count)) {
                            string[] advanced_options = {"cache-pkg", "configuration-pkg", "old-kernels"};
                            /* Update the progress bar
                             * ++++++-----------------------------
                             */
                            app.update_progress (app_name, option_name);
                            string cmd_clean = null;

                            if (option_id in advanced_options) { // The option contains commands
                                Json.Node node_cmd = jload.get_all_commands_of (app_id, option_id);
                                var object_cmd = node_cmd.get_object ();
                                cmd_clean = object_cmd.get_string_member ("clean");
                            }

                            no_errors = info_clean.clean_operation (app_id, option_id, cmd_clean);
                        }
                        count++;
                    }
                }
            }

            // We update the values
            //info_clean.set_total_counter (clean_files);
            //info_clean.set_total_accumulator (clean_size);
            
            Idle.add((owned) clean_callback);
            Thread.exit (1.to_pointer ());
            return null;
        };
        Thread<void*> clean_thread = new Thread<void*> ("clean_thread", run);
        yield;
        return no_errors;
    }
}
