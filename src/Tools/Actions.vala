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

namespace GCleaner.Tools {
    public class Actions {
        private static Actions Instance = null;

        private static void CreateInstance () {
            if (Instance == null) {
                Instance = new Actions ();
            }
        }

        public static Actions Get_Instance () {
           if (Instance == null) CreateInstance ();
           return Instance;
        }

        public void run_operation (GCleaner.App app, bool really_delete = false) {
            Cleaner[] list_cleaners = app.sidebar.get_list_cleaners ();
            var info_clean = new InfoClean ();
            info_clean.reset_values ();
            analyze_all_process.begin (app, list_cleaners, info_clean, app.results_area, really_delete, (obj, res) => {
                try {
                    int result = analyze_all_process.end(res);
                    app.set_progress_fraction_value (1.0);
                    if (really_delete) app.disable_clean_button ();
                } catch (ThreadError e) {
                    stderr.printf("Analysis error: %s\n", e.message);
                }
            });

            print_results.begin (info_clean, app.sidebar.get_number_installed_apps (), (obj, res) => {
                try {
                    int result = print_results.end(res);
                    var jload = new GCleaner.Tools.JsonUtils ();
                    Gdk.Pixbuf pix;
                    app.sidebar.apps_box.set_sensitive (true);
                    app.sidebar.system_box.set_sensitive (true);
                    app.results_area.move_pix_cell_to_right ();
                    app.results_area.clear_results ();
                    if (info_clean.get_total_counter () > 0) {
                        string total_file_size = FileUtilities.to_readable_format_size (info_clean.get_total_accumulator ());
                        string total_file_number = info_clean.get_total_counter ().to_string ();
                        string text_result;
                        string text_detail;
                        pix = load_pixbuf (Constants.PKGDATADIR + "/media/info-system/dialog-ok.png");

                        if (really_delete) {
                            text_result = "Cleaning complete\n" + total_file_size + " (" + total_file_number + " files) were removed. (Aproximate size)\n";
                            text_detail = "Details of files deleted\n";
                        } else {
                            text_result = "Analysis complete\n" + total_file_size + " (" + total_file_number + " files) will be removed. (Aproximate size)\n";
                            text_detail = "Details of files to be deleted (Note: No file have been deleted yet)\n";
                        }
                        app.results_area.append_data_to_list_store (pix, text_result);
                        app.results_area.append_data_to_list_store (null, text_detail);
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
                        pix = load_pixbuf (Constants.PKGDATADIR + "/media/info-system/dialog-ok.png", 16);
                        app.results_area.append_data_to_list_store (pix, "Congratulations! The System is clean!");
                        app.disable_clean_button ();
                    }
                    
                    app.enable_scan_button ();
                } catch (ThreadError e) {
                    stderr.printf("Print-Thread error: %s\n", e.message);
                }
            });
        }

        public void run_scan_operation (GCleaner.App app) {
            bool really_delete = false;
            run_operation (app, really_delete);
        }

        public void run_clean_operation (GCleaner.App app) {
            bool really_delete = true;
            run_operation (app, really_delete);
        }
    }
}
