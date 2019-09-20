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
using Gdk;
using GLib;
using GCleaner.Tools;

namespace GCleaner.Tools {
    public class Actions {
        private static Actions instance = null;
        private GCleaner.App app;

        private Actions (GCleaner.App app) {
            this.app = app;
        }
        
        // Public constructor
        public static Actions get_instance (GCleaner.App? app = null) {
            if (instance == null) {
                instance = new Actions (app);
            }
            return instance;
        }

        public void run_operation (bool really_delete = false, string? item_app_id = null, string? item_option_id = null) {
            Cleaner[] list_cleaners = null;
            var info_clean = new InfoClean ();
            info_clean.reset_values ();
            int max_to_scan = 1;
            // We're asking if it's to scan a particular app or all the applications.
            if (item_app_id != null) {
                list_cleaners += app.sidebar.get_cleaner_by_id (item_app_id);
            } else {
                list_cleaners = app.sidebar.get_list_cleaners ();
                max_to_scan = app.sidebar.get_number_installed_apps ();
            }
            app.sidebar.apps_box.set_sensitive (false);
            app.sidebar.system_box.set_sensitive (false);
            app.disable_scan_button ();
            app.disable_clean_button ();
            app.results_area.clear_results (); // Clean the results grid
            app.results_area.prepare_to_list_content ();
            
            analyze_all_process.begin (app, list_cleaners, info_clean, really_delete, item_option_id, (obj, res) => {
                try {
                    int result = analyze_all_process.end(res);
                    app.set_progress_fraction_value (1.0);
                    if (really_delete) app.disable_clean_button ();
                } catch (ThreadError e) {
                    stderr.printf("Analysis error: %s\n", e.message);
                }
            });

            print_results.begin (info_clean, max_to_scan, (obj, res) => {
                try {
                    int result = print_results.end(res);
                    var jload = new JsonUtils ();
                    Gdk.Pixbuf pix;
                    app.sidebar.apps_box.set_sensitive (true);
                    app.sidebar.system_box.set_sensitive (true);
                    app.results_area.clear_results (); // Clean the results grid
                    app.results_area.prepare_to_empty_results ();
                    if (info_clean.total_counter > 0) {
                        app.results_area.set_headers_visible (true);
                        string total_file_size = FileUtilities.to_readable_format_size (info_clean.total_accumulator);
                        string total_file_number = info_clean.total_counter.to_string ();
                        string text_result;
                        string text_detail;

                        if (really_delete) {
                            text_result = "<b>Cleaning complete</b>\n" + total_file_size + " (" + total_file_number + " files) were removed. (Aproximate size)";
                            text_detail = "<b>Details of files deleted</b>";
                        } else {
                            text_result = "<b>Analysis complete</b>\n" + total_file_size + " (" + total_file_number + " files) will be removed. (Aproximate size)";
                            text_detail = "<b>Details of files to be deleted (Note: No file have been deleted yet)</b>";
                        }
                        app.results_area.set_labels_text (text_result, text_detail);
                        foreach (var cleaner in list_cleaners) {
                            if (cleaner.is_active () || item_option_id != null) {
                                string app_id = cleaner.app_id;
                                string app_name = cleaner.get_app_name ();
                                int count = 0;
                                
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
                                    bool option_is_active = cleaner.get_option_label (count) == option_name && cleaner.is_option_active (count);
                                    if (option_is_active || item_option_id != null) {
                                        int64 n_files_option = info_clean.get_file_number_of (app_id, option_id);
                                        if (n_files_option != 0) {
                                            pix = load_pixbuf_from_name (app_id, option_id);
                                            string size_formated = null;
                                            if (option_id == "configuration-pkg" || option_id == "old-kernels") {
                                                size_formated = "Unknown size";
                                            } else {
                                                int64 size_option = info_clean.get_file_size_of (app_id, option_id);
                                                size_formated = FileUtilities.to_readable_format_size (size_option);
                                            }
                                            app.results_area.append_data_to_list_store (pix, "• " + app_name + " - " + option_name, size_formated, n_files_option.to_string () + " files");
                                        }
                                    }
                                    count++;
                                }
                            }
                        }
                        
                        app.enable_clean_button ();
                    } else {
                        app.results_area.set_headers_visible (false);
                        app.results_area.set_labels_text ("<b>Congratulations! The System is clean!</b>");
                        app.disable_clean_button ();
                    }
                    app.sidebar.apps_box.set_sensitive (true);
                    app.sidebar.system_box.set_sensitive (true);
                    app.enable_scan_button ();
                    app.enable_scan_button ();
                } catch (ThreadError e) {
                    stderr.printf("Print-Thread error: %s\n", e.message);
                }
            });
        }

        public void run_selected_option (string app_id, string? option_id = null, bool really_delete = false) {
            run_operation (really_delete, app_id, option_id);
        }

        public void run_scan_operation () {
            bool really_delete = false;
            run_operation (really_delete);
        }

        public void run_clean_operation () {
            bool really_delete = true;
            run_operation (really_delete);
        }
    }
}
