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
    public class Cleaner {
        private GCleaner.App app;
        private string _app_id;
        private GCleaner.Widgets.CleanerButtons list_buttons;

        public Cleaner (GCleaner.App app, string app_id) {
            this.app = app;
            this._app_id = app_id;
            set_check_buttons ();
        }
        
        public string app_id {
            get { return _app_id; }
            set { _app_id = value; }
        }

        private void set_check_buttons () {
            list_buttons = new GCleaner.Widgets.CleanerButtons (app, _app_id);
        }

        public Gtk.CheckButton get_check_root () {
            Gtk.CheckButton check = list_buttons.get_check_root ();
            return check;
        }

        public Gtk.CheckButton get_check_option_by_index (int index) {
            Gtk.CheckButton check = list_buttons.get_check_option_by_index (index);
            return check;
        }

        public string get_app_name () {
            string app_name = get_check_root ().get_name ();
            return app_name;
        }

        public string get_option_label (int index) {
            string label = get_check_option_by_index (index).label;
            return label;
        }

        public bool is_active () {
            bool status = false;
            status = get_check_root ().get_active ();
            return status;
        }

        public bool is_option_active (int index) {
            bool status = false;
            status = get_check_option_by_index (index).get_active ();
            return status;
        }
    }
}
