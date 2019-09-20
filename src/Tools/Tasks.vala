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
    public async int print_results (InfoClean info_clean, int max_to_scan) throws ThreadError {
        SourceFunc print_callback = print_results.callback;
        
        ThreadFunc<void*> run = () => {
            
            while (info_clean.get_n_scanned_apps () < max_to_scan) {}
            
            Idle.add((owned) print_callback);
            Thread.exit (1.to_pointer ());
            return null;
        };
        Thread<void*> print_thread = new Thread<void*> ("print_thread", run);
        yield;
        return 1;
    }

    // This function does both the analysis and the cleaning
    // ********************************************************
    public async int analyze_all_process (GCleaner.App app, Cleaner[] list_cleaners, InfoClean info_clean, bool really_delete, string? item_option_id = null) throws ThreadError {
        SourceFunc analyze_callback = analyze_all_process.callback;
        ThreadFunc<void*> run = () => {
            bool status = false;
            Timeout.add (50, () => {
                var list_store = app.results_area.get_list_store ();
                list_store.foreach ((model, path, iter) => {
                    Value val;
                    list_store.get_value (iter, 1, out val);
                    val.set_int (val.get_int () + 1);
                    list_store.set_value (iter, 1, val);
                    return false;
                });
                return true;
            });
            
            var jload = new JsonUtils ();
            foreach (var cleaner in list_cleaners) {
                if (cleaner.is_active () || item_option_id != null) {
                    string app_id = cleaner.app_id;
                    string app_name = cleaner.get_app_name ();
                    int count = 0; // It is used for the indexes of the options
                    // This can be all options or, in the case of a selected item, only one option.
                    Json.Node node_options = null;
                    if (item_option_id != null) {
                        node_options = jload.get_single_option_of (app_id, item_option_id);
                    } else {
                        node_options = jload.get_all_options_of (app_id);
                    }
                    foreach (var option in node_options.get_array ().get_elements ()) {
                        var object_option = option.get_object ();
                        string option_id = object_option.get_string_member ("option-id");
                        string option_name = object_option.get_string_member ("option-name");
                        /* Update the progress bar
                         * ++++++-----------------------------
                         */
                        app.update_progress (app_name, option_name, info_clean.get_n_scanned_apps ());
                        bool option_is_active = cleaner.get_option_label (count) == option_name && cleaner.is_option_active (count);
                        if (option_is_active || item_option_id != null) {
                            string[] advanced_options = {"cache-pkg", "configuration-pkg", "old-kernels"};
                            if (option_id in advanced_options) { // The option contains commands
                                Json.Node node_cmd = jload.get_all_commands_of (app_id, option_id);
                                var object_cmd = node_cmd.get_object ();
                                string cmd_size = (object_cmd.has_member ("get-size")) ? object_cmd.get_string_member ("get-size") : null;
                                string cmd_quantity = object_cmd.get_string_member ("get-quantity");
                                string cmd_clean = object_cmd.get_string_member ("clean");

                                if (really_delete) {
                                    status = info_clean.clean_operation (app_id, option_id, null, cmd_clean, cmd_quantity, cmd_size);
                                } else {
                                    info_clean.advanced_scan (app_id, option_id, cmd_quantity, cmd_size);
                                }
                            } else { // Option only contains paths
                                string[] paths_to_scan = {}; // It will contain the reinterpreted paths
                                string[] current_option_paths = {};
                                // Get all the paths to scan of the option
                                foreach (var dir in object_option.get_array_member ("paths").get_elements ()) {
                                    current_option_paths += dir.get_string ();
                                }
                                // We save in an array the paths that were reinterpreted.
                                paths_to_scan = FileUtilities.reinterpret_paths (current_option_paths);
                                if (paths_to_scan.length > 0) {
                                    if (really_delete) {
                                        status = info_clean.clean_operation (app_id, option_id, paths_to_scan, null);
                                    } else {
                                        info_clean.simple_scan (app_id, option_id, paths_to_scan);
                                    }
                                }
                            }
                        }
                        count++;
                    }
                }
                info_clean.count_scanned_apps (1);
            }

            Idle.add((owned) analyze_callback);
            Thread.exit (1.to_pointer ());
            return null;
        };
        Thread<void*> analyze_all_thread = new Thread<void*> ("analyze_all_thread", run);
        yield;
        return 1;
    }
}
