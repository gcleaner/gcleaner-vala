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

        public void run_scan_operation (GCleaner.App app, GCleaner.Widgets.Sidebar sidebar, Cleaner[] list_cleaners, 
                                        InfoClean info_clean, GCleaner.Widgets.ResultsArea results_area, int n_installed_apps) {
            analyze_all_process.begin (app, list_cleaners, info_clean, results_area, (obj, res) => {
                try {
                    int result = analyze_all_process.end(res);
                    app.set_progress_fraction_value (1.0);
                } catch (ThreadError e) {
                    stderr.printf("Analysis error: %s\n", e.message);
                }
            });

            print_results.begin (info_clean, n_installed_apps, (obj, res) => {
                try {
                    int result = print_results.end(res);
                    var jload = new GCleaner.Tools.JsonLoader ();
                    
                    Gdk.Pixbuf pix;
                    sidebar.apps_box.set_sensitive (true);
                    sidebar.system_box.set_sensitive (true);
                    results_area.sort_fields_before_print ();
                    results_area.clear_results ();

                    if (info_clean.get_total_counter () > 0) {
                        string[] system_apps = {"apt", "system"};
                        pix = load_pixbuf (Constants.PKGDATADIR + "/media/info-system/dialog-ok.png");
                        results_area.append_data_to_list_store (pix, "Analysis Complete\n" + FileUtilities.to_readable_format_size (info_clean.get_total_accumulator ()) + " will be removed. (Aproximate size)\n");
                        results_area.append_data_to_list_store (null, "Details of files to be deleted (Note: No file have been deleted yet)\n");

                        foreach (var cleaner in list_cleaners) {
                            if (cleaner.is_active ()) {
                                string app_id = cleaner.app_id;
                                string app_name = cleaner.get_app_name ();
                                string category = (app_id in system_apps) ? "system" : "applications";
                                string type_icon = (category == "applications") ? "apps" : "info-system";
                                int count = 0;
                                
                                Json.Node all_options = jload.get_all_options_of (app_id);
                                foreach (var option in all_options.get_array ().get_elements ()) {
                                    var object_option = option.get_object ();
                                    
                                    string option_id = object_option.get_string_member ("option-id");
                                    string option_name = object_option.get_string_member ("option-name");
                                    
                                    if (cleaner.get_option_label (count) == option_name && cleaner.is_option_active (count)) {
                                        string[] advanced_options = {"cache-pkg", "configuration-pkg", "old-kernels"};
                                        
                                        int64 n_files_option = info_clean.get_file_number_of (app_id, option_id);
                                        if (n_files_option != 0) {
                                            pix = load_pixbuf (Constants.PKGDATADIR + "/media/" + type_icon + "/" + app_id + ".png");
                                            string size_formated = null;
                                            if (option_id == "configuration-pkg" || option_id == "old-kernels") {
                                                size_formated = "Unknown size";
                                            } else {
                                                int64 size_option = info_clean.get_file_size_of (app_id, option_id);
                                                size_formated = FileUtilities.to_readable_format_size (size_option);
                                            }
                                            
                                            results_area.append_data_to_list_store (pix, "• " + app_name + " - " + option_name, size_formated, n_files_option.to_string () + " files");
                                            //result_list.append (out iter);
                                            //result_list.set (iter, 2, pix, 3, "• " + app_name + " - " + option_name, 4, size_formated, 5, n_files_option.to_string () + " files");
                                        }
                                    }
                                    count++;
                                }
                            }
                        }

                        app.clean_button.set_sensitive (true);// Enable Clean Button
                        app.clean_button.get_style_context ().add_class ("destructive-action");
                    } else {
                        pix = load_pixbuf (Constants.PKGDATADIR + "/media/info-system/dialog-ok.png", 16);
                        results_area.append_data_to_list_store (pix, "Congratulations! The System is clean!");
                        
                        app.clean_button.set_sensitive (false);// Disable Clean Button
                        app.clean_button.get_style_context ().remove_class ("destructive-action");//remove the red color of button
                    }
                    
                    app.scan_button.set_sensitive (true);// Enable the scan button
                    app.scan_button.get_style_context ().add_class ("suggested-action");//Paint the button of blue
                } catch (ThreadError e) {
                    stderr.printf("Print-Thread error: %s\n", e.message);
                }
            });
        }

        public void run_clean_operation (GCleaner.App app, Cleaner[] list_cleaners, InfoClean info_clean, GCleaner.Widgets.ResultsArea results_area) {
            clean_process.begin (app, list_cleaners, info_clean, (obj, res) => {
                try {
                    bool no_errors = clean_process.end(res);
                    Pixbuf pix;
                    app.clean_button.get_style_context ().remove_class ("destructive-action");
                    app.clean_button.set_sensitive (false);
                    app.set_progress_fraction_value (1.0);
                    results_area.clear_results (); // Clean the results grid
                    
                    if (no_errors) {
                        pix = load_pixbuf (Constants.PKGDATADIR + "/media/info-system/dialog-ok.png");
                        results_area.append_data_to_list_store (pix, "✔ Successful cleaning. Was freed " + FileUtilities.to_readable_format_size (info_clean.get_total_accumulator ()) + " in " + info_clean.get_total_counter ().to_string () + " files");
                    } else {
                        pix = load_pixbuf (Constants.PKGDATADIR + "/media/info-system/dialog-close.png");
                        results_area.append_data_to_list_store (pix, "✕ Incomplete cleaning. Was freed " + FileUtilities.to_readable_format_size (info_clean.get_total_accumulator ()) + " were missing " + info_clean.get_total_counter ().to_string () + " files");
                    }
                } catch (ThreadError e) {
                    stderr.printf("Clean process error: %s\n", e.message);
                }
            });
            
            /*Set to 0 once cleaned*/
            info_clean.set_total_counter (0);
            info_clean.set_total_accumulator (0);
        }
    }
}
