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

using Gdk;
using Gtk;
using GLib;
using Json;
using GCleaner.Widgets;
using GCleaner.Tools;

namespace GCleaner {
    public class App : Gtk.Application {
        public int n_installed_apps;
        public Gtk.ApplicationWindow main_window; // Main window
        public Gtk.Label lbl_progress;
        public Gtk.ProgressBar progress_bar;
        public Gtk.ListStore result_list;
        public Gtk.Button scan_button;
        public Gtk.Button clean_button;
        public GLib.Settings settings;
        public Sidebar sidebar;
        public ResultsArea results_area;

        public App () {
            GLib.Object(application_id: "org.gcleaner",
                        flags: ApplicationFlags.FLAGS_NONE);
        }
        
        protected override void activate () {
            /*
            * Settings for save the GCleaner state
            */
            settings = Resources.get_setting_schema ();

            //MAIN WINDOW PROPERTIES
            this.main_window = new Gtk.ApplicationWindow (this);
            this.main_window.move (settings.get_int ("opening-x"), settings.get_int ("opening-y"));
            this.main_window.set_default_size (settings.get_int ("window-width"), settings.get_int ("window-height"));
            this.main_window.set_title (Resources.PROGRAM_NAME);
            this.main_window.set_application (this);
            this.main_window.icon_name = Resources.EXEC_NAME; // Application icon
            
            // BOXES
            Box main_window_box = new Box (Orientation.VERTICAL, 0);    // Box that will contain the rest of the boxes (this is adjusted to the window)
            Box content_box     = new Box (Orientation.HORIZONTAL, 0);  // Box containing the Sidebar, the separator and the remaining box infoAction_box
            Box progress_box    = new Box (Orientation.HORIZONTAL, 0);  // Box containing the spinner, the progress bar and the % of the advance
            Box result_box      = new Box (Orientation.HORIZONTAL, 0);  // Box containing the ScrolledWindow of Results
            Box buttons_box     = new Box (Orientation.HORIZONTAL, 0);  // Box that will hold the buttons to scan and clean
            Box infoAction_box  = new Box (Orientation.VERTICAL, 0);    // Box containing progress bar, actions and results
            
            //BUTTONS
            scan_button  = new Button.with_label (" Scan ");
            clean_button = new Button.with_label (" Clean up ");
            /*
             * Initial state of the buttons 
             * (Scan painted blue and clear disabled)
             */
            scan_button.get_style_context ().add_class ("suggested-action"); // Paint the button of blue
            clean_button.set_sensitive (false); // Disable clean button
            
            // LABELS
            lbl_progress = new Label ("");
            lbl_progress.set_markup ("<b>0%</b>");
            
            // SEPARATORS
            Separator separatorVertContenido = new Separator (Gtk.Orientation.VERTICAL);
            Separator separatorResultLeft    = new Separator (Gtk.Orientation.VERTICAL);
            Separator separatorResultRight   = new Separator (Gtk.Orientation.VERTICAL);
            Separator separatorResultTop     = new Separator (Gtk.Orientation.HORIZONTAL);
            Separator separatorResultBottom  = new Separator (Gtk.Orientation.HORIZONTAL);
            
            // OTHERS WIDGETS
            progress_bar = new ProgressBar ();
            
            // OWN WIDGETS
            sidebar = new Sidebar (this);
            sidebar.get_style_context ().add_class("Sidebar");
            results_area = new ResultsArea ();
            
            /*
             * This EventBox is created to color the
             * background of the Box (Sidebar) in GTK+ <= 3.10
             */
            var eventSidebar = new EventBox ();
            eventSidebar.add (sidebar);
            eventSidebar.get_style_context ().add_class("SidebarEv");
            var colour = Gdk.RGBA ();//the color is created in RGBA
            colour.red = 103.0;
            colour.green = 103.0;
            colour.blue = 103.0;
            colour.alpha = 1.0;//transparency
            eventSidebar.override_background_color(Gtk.StateFlags.NORMAL, colour);
            
            var actions = Actions.get_instance (this);
            n_installed_apps = sidebar.get_number_installed_apps (); // Number of programs to be cleaned

            // PACKAGING
            /*
             * TOOLBAR and HEADERBAR
             * 
             * Here the magic of the dynamic
             * -- Checking Desktop Environment to use Header Bars
             */
            
            // Create string variable to store the desktop environment
            string desktop_environment = "";
            desktop_environment = GLib.Environment.get_variable ("XDG_CURRENT_DESKTOP"); // We keep the value of the CURRENT_DESKTOP variable
            desktop_environment = desktop_environment.up(); // We pass from "Example" To -> "EXAMPLE" (uppercase) to easily check the value
            stdout.printf ("COM.GCLEANER.APP: [DESKTOP: %s]\n", desktop_environment); // Print on screen for easy reading
            
            /*
             * Boolean value that determines if use 
             * or not use HeaderBar according to the desktop environment.
             * If it is Pantheon Desktop (elementary OS) or 
             * GNOME Desktop, use HeaderBar.
             */

            bool use_headerbar;
            if ((desktop_environment == "PANTHEON") || (desktop_environment == "GNOME")) {
                use_headerbar = true;
            } else { // Any other Desktop like Unity, XFCE, Mate, etc... use ToolBar
                use_headerbar = false;
            }
            
            /*
             * Use HeaderBar or ToolBar?
             */
            if (use_headerbar) {
                /*
                * HeaderBar
                * Create an instance of the HeaderBar (customized)
                */
                var header_bar = new Header (this);
                header_bar.get_style_context ().add_class("csd");
                this.main_window.set_titlebar (header_bar);
                header_bar.set_name ("header_bar");
            } else {
                /*
                * ToolBar
                * Creates an instance of the Toolbar (customized)
                */
                var toolbar = new ToolBar (this);
                toolbar.get_style_context ().add_class("Toolbar");
                toolbar.set_name ("Toolbar");

                // Add the Toolbar to the main window box
                main_window_box.pack_start (toolbar, false, true, 0);
            }
            
            /* PROGRESS */
            progress_box.pack_start (progress_bar, true, true, 8);
            progress_box.pack_start (lbl_progress, false, true, 8);
            
            /* Scrolled window area */
            TreeView results_view = results_area.get_tree_view ();
            ScrolledWindow results_scroll_area = new ScrolledWindow (null, null);
            results_scroll_area.add (results_view);
            
            result_box.pack_start (separatorResultLeft, false, true, 0);
            result_box.pack_start (results_scroll_area, true, true, 0);
            result_box.pack_start (separatorResultRight, false, true, 0);
            
            /* Buttons */
            buttons_box.pack_start (scan_button, false, false, 0);
            buttons_box.pack_end (clean_button, false, false, 0);
            
            /*Information, Results and Actions*/
            infoAction_box.pack_start (progress_box, false, true, 8);
            infoAction_box.pack_start (separatorResultTop, false, true, 0);
            infoAction_box.pack_start (results_area.box_top_results, false, false, 0);
            infoAction_box.pack_start (result_box, true, true, 0);
            infoAction_box.pack_start (separatorResultBottom, false, true, 0); // Separator between buttons and results
            infoAction_box.pack_start (buttons_box, false, true, 8);
            
            /*Content Box*/
            content_box.pack_start (eventSidebar, false, true, 0); // Pack the sidebar to the content container of the APP
            content_box.pack_start (separatorVertContenido, false, true, 0); // Visible separator between Sidebar and Results
            content_box.pack_start (infoAction_box, true, true, 8);     // Pack the box with the content of information, result and actions
            
            /*Final assembly*/
            main_window_box.pack_start (content_box, true, true, 0);
            
            /************* TEMPORARY, then erase *******************/
            string home_user = GLib.Environment.get_variable ("HOME");
            stdout.printf ("COM.GCLEANER.APP: [USER: %s]\n", home_user);
            
            /*
             * Scan button actions and Logic
             * *************************************************************
             */
            scan_button.has_tooltip = true;
            scan_button.query_tooltip.connect ((x, y, keyboard_tooltip, tooltip) => {
                tooltip.set_icon_from_icon_name ("dialog-information", Gtk.IconSize.LARGE_TOOLBAR); 
                tooltip.set_markup ("This option will scan <b>all selected options.</b>");
                return true;
            });
            scan_button.clicked.connect(()=> {
                progress_bar.set_fraction (0);
                actions.run_scan_operation ();
            });
            
            /*
             * Clean button actions and Logic
             * *************************************************************
             */
            clean_button.has_tooltip = true;
            clean_button.query_tooltip.connect ((x, y, keyboard_tooltip, tooltip) => {
                tooltip.set_icon_from_icon_name ("dialog-information", Gtk.IconSize.LARGE_TOOLBAR); 
                tooltip.set_markup ("This option will remove the files from <b>all the selected options.</b>");
                return true;
            });
            clean_button.clicked.connect(()=> {
                Gtk.MessageDialog msg = new Gtk.MessageDialog (this.main_window, Gtk.DialogFlags.MODAL, Gtk.MessageType.WARNING, Gtk.ButtonsType.OK_CANCEL, "Are you sure you want to continue?");
                msg.response.connect ((response_id) => {
                    if (response_id == Gtk.ResponseType.OK) {
                        actions.run_clean_operation ();
                    }
                    msg.destroy ();
                });
                msg.show ();
            });

            this.main_window.delete_event.connect (() => {
                int x, y, w, h;
                
                this.main_window.get_position (out x, out y);
                this.main_window.get_size (out w, out h);
                this.main_window.hide ();
                
                //Save values into GSCHEMA
                settings.set_int ("opening-x", x);
                settings.set_int ("opening-y", y);
                settings.set_int ("window-width", w);
                settings.set_int ("window-height", h);
                
                Gtk.main_quit ();
                return false;
            });
            
            this.main_window.add (main_window_box);
            this.main_window.show_all ();
        }

        public void update_progress (string? current_app = "", string? current_option = "", int n_scanned_apps) {
            double percent_value_per_app = 100 / n_installed_apps;
            double fraction_progress = (percent_value_per_app * n_scanned_apps) / 100; // value assigned to the progress bar depending on the apps already scanned.
            set_progress_fraction_value (fraction_progress);
            // Cleaning the results area and update the info
            //rsesults_area.clear_results ();
            //results_area.append_data_to_list_store (null, current_app + "\n" + current_option, null, null, true);
        }
        
        public void set_progress_fraction_value (double fraction) {
            progress_bar.set_fraction (fraction);
            lbl_progress.set_markup ("<b>" + Math.round (fraction * 100).to_string() + "%</b>");
        }

        public void enable_scan_button () {
            this.scan_button.set_sensitive (true);
            this.scan_button.get_style_context ().add_class ("suggested-action"); // Paint the button of blue
        }

        public void disable_scan_button () {
            this.scan_button.set_sensitive (false);
            this.scan_button.get_style_context ().remove_class ("suggested-action"); // Remove the blue color of button
        }

        public void enable_clean_button () {
            this.clean_button.set_sensitive (true);
            this.clean_button.get_style_context ().add_class ("destructive-action"); // Paint the button of red
        }

        public void disable_clean_button () {
            this.clean_button.set_sensitive (false);
            this.clean_button.get_style_context ().remove_class ("destructive-action"); // Remove the red color of button
        }

        public static int main (string[] args) {
            Gtk.init (ref args); // Starts GTK+
            string css_file = "/usr/share/gcleaner/gtk-widgets-gcleaner.css"; // Path where takes the CSS file
            var css_provider = new Gtk.CssProvider (); // Create a new CSS provider
            
            try {
                css_provider.load_from_path (css_file); // Loads the CSS of the previous path (string)
                Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default(), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);
            } catch (Error e) { // Handling the Error
                stderr.printf ("COM.GCLEANER.APP: [ERROR WHEN LOADING CSS STYLE [%s]]\n", e.message);
                stderr.printf (">>> Check path: /usr/share/gcleaner/gtk-widgets-gcleaner.css\n");
            }
            
            var app = new GCleaner.App ();
            
            if ((args[1] == "--version") || (args[1] == "-version")) {
                var about = new About ();
                about.run ();
                about.destroy.connect (Gtk.main_quit);
            }
            
            return app.run (args);
            var loop = new MainLoop();
            loop.run();
        }
    }
}
