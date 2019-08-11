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

namespace GCleaner.Widgets {
    public class ResultsArea {
        private Gtk.ListStore list_store;
        private Gtk.TreeView tree_view;
        private Gtk.TreeViewColumn column_spinner;
        private Gtk.TreeViewColumn column_pix;
        private Gtk.TreeViewColumn column_concept;
        private Gtk.TreeViewColumn column_size;
        private Gtk.TreeViewColumn column_number;
        private Gtk.Box _box_top_results;
        private Gtk.Label label_info;
        private Gtk.Label label_advice;

        enum Columns {
            STATUS_SPIN,
            VALUE_SPIN,
            PIXBUF,
            CONCEPT,
            SIZE,
            N_FILES,
            N_COLUMNS
        }

        public ResultsArea () {
            //LIST STORE - SCAN/CLEANING INFORMATION
            _box_top_results = new Box (Orientation.VERTICAL, 4);
            _box_top_results.border_width = 12;
            list_store = new Gtk.ListStore (Columns.N_COLUMNS, typeof (bool), typeof (int), typeof (Gdk.Pixbuf), typeof (string), typeof (string), typeof (string));
            tree_view = new TreeView.with_model (list_store);
            create_results_area ();
        }
        
        public Gtk.TreeView get_tree_view () {
            return tree_view;
        }

        public Gtk.ListStore get_list_store () {
            return list_store;
        }

        public Gtk.Box box_top_results {
            get { return _box_top_results; }
            private set {}
        }

        public void create_results_area () {
            label_info = new Label (null);
            label_advice = new Label (null);
            label_info.set_halign (Align.START);
            label_advice.set_halign (Align.START);
            set_labels_text ("", "");
            
            // Columns -------------------------------------------------------------------
            var renderer_spinner = new Gtk.CellRendererSpinner ();
            column_spinner = new Gtk.TreeViewColumn ();
            column_spinner.pack_start (renderer_spinner, false);
            column_spinner.add_attribute (renderer_spinner, "active", Columns.STATUS_SPIN);
            column_spinner.add_attribute (renderer_spinner, "pulse", Columns.VALUE_SPIN);
            tree_view.append_column (column_spinner);
            
            var renderer_pixbuf = new CellRendererPixbuf ();
            column_pix = new Gtk.TreeViewColumn ();
            column_pix.pack_start (renderer_pixbuf, false);
            column_pix.add_attribute (renderer_pixbuf, "pixbuf", Columns.PIXBUF);
            tree_view.append_column (column_pix);
            
            var renderer_text = new CellRendererText ();
            column_concept = new Gtk.TreeViewColumn.with_attributes ("Concept", renderer_text, 
                                                                     "text", Columns.CONCEPT, null);
            tree_view.append_column (column_concept);
            column_size = new Gtk.TreeViewColumn.with_attributes ("Size", renderer_text, 
                                                                  "text", Columns.SIZE, null);
            tree_view.append_column (column_size);
            column_number = new Gtk.TreeViewColumn.with_attributes ("Number of files", renderer_text, 
                                                                    "text", Columns.N_FILES, null);
            tree_view.append_column (column_number);
            this.set_headers_visible (false);
            // Monitor list double-clicks.
            this.tree_view.row_activated.connect ((treeview , path, column) => {
                Gtk.TreeIter iter;
                if (tree_view.model.get_iter (out iter, path)) {
                    string str = "";
                    tree_view.model.get (iter, Columns.CONCEPT, out str);
                    // Work in progress
                }
            });
            // Monitor list selection changes.
            this.tree_view.get_selection().changed.connect ((selection) => {
                Gtk.TreeModel model;
                Gtk.TreeIter iter;
                if (selection.get_selected (out model, out iter)) {
                    string str = "";
                    model.get (iter, Columns.CONCEPT, out str);
                    // Work in progress
                }
            });
        }

        public void set_headers_visible (bool value) {
            tree_view.set_headers_visible (value);
        }

        public void clear_results () {
            box_top_results.foreach ((label) => _box_top_results.remove (label));
            list_store.clear ();
        }

        public void set_labels_text (string text_info, string? text_advice = null) {
            label_info.set_markup (text_info);
            _box_top_results.pack_start (label_info, false, false, 1);
            if (text_advice != null) {
                label_advice.set_markup (text_advice);
                _box_top_results.pack_start (label_advice, false, false, 1);
            }
        }

        public void append_data_to_list_store (Gdk.Pixbuf? pix = null, string concept_field, string? file_size_field = null, string? file_number_field = null, bool? update_progress = false) {
            TreeIter iter;
            list_store.append (out iter);
            if (pix != null) {
                if (file_size_field == null) {
                    list_store.set (iter, Columns.PIXBUF, pix, Columns.CONCEPT, concept_field);
                } else {
                    list_store.set (iter, Columns.PIXBUF, pix, Columns.CONCEPT, concept_field, Columns.SIZE, file_size_field, Columns.N_FILES, file_number_field);
                }
            } else if (update_progress) {
                list_store.set (iter, Columns.STATUS_SPIN, true, Columns.VALUE_SPIN, 1, Columns.CONCEPT, concept_field);
            } else {
                list_store.set (iter, Columns.CONCEPT, concept_field);
            }
        }

        // This arranges the fields so that the icons are located first.
        public void prepare_to_list_content () {
            tree_view.move_column_after (column_spinner, column_pix);
            tree_view.move_column_after (column_pix, column_number);
        }

        // This arranges the fields to show a description of the completed task.
        public void prepare_to_empty_results () {
            tree_view.move_column_after (column_pix, column_spinner);
            tree_view.move_column_after (column_spinner, column_number);
        }
    }
}
