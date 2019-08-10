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
        private Gtk.CellRendererSpinner spinner_cell;
        private Gtk.TreeViewColumn column_spinner;
        private CellRendererPixbuf pixbuf_cell;
        private Gtk.TreeViewColumn column_pix;
        private CellRenderer concept_cell;
        private Gtk.TreeViewColumn column_concept;
        private CellRenderer size_cell;
        private Gtk.TreeViewColumn column_size;
        private CellRenderer number_cell;
        private Gtk.TreeViewColumn column_number;
        
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

        public void create_results_area () {
            // Columns -------------------------------------------------------------------
            spinner_cell = new Gtk.CellRendererSpinner ();
            column_spinner = new Gtk.TreeViewColumn ();
            column_spinner.pack_start (spinner_cell, false);
            column_spinner.add_attribute (spinner_cell, "active", Columns.STATUS_SPIN);
            column_spinner.add_attribute (spinner_cell, "pulse", Columns.VALUE_SPIN);
            tree_view.append_column (column_spinner);
            
            pixbuf_cell = new CellRendererPixbuf ();
            column_pix = new Gtk.TreeViewColumn ();
            column_pix.pack_start (pixbuf_cell, false);
            column_pix.add_attribute (pixbuf_cell, "pixbuf", Columns.PIXBUF);
            tree_view.append_column (column_pix);
            
            concept_cell = new CellRendererText ();
            column_concept = new Gtk.TreeViewColumn ();
            column_concept.set_title ("Concept");
            column_concept.pack_start (concept_cell, false);
            column_concept.add_attribute (concept_cell, "text", Columns.CONCEPT);
            tree_view.append_column (column_concept);
            
            size_cell = new CellRendererText ();
            column_size = new Gtk.TreeViewColumn ();
            column_size.set_title ("Size");
            column_size.pack_start (size_cell, false);
            column_size.add_attribute (size_cell, "text", Columns.SIZE);
            tree_view.append_column (column_size);
            
            number_cell = new CellRendererText ();
            column_number = new Gtk.TreeViewColumn ();
            column_number.set_title ("Number of files");
            column_number.pack_start (number_cell, false);
            column_number.add_attribute (number_cell, "text", Columns.N_FILES);
            tree_view.append_column (column_number);
        }
        
        public void clear_results () {
            list_store.clear ();
        }

        public void append_data_to_list_store (Gdk.Pixbuf? pix = null, string row_concept, string? row_file_size = null, string? row_file_number = null, bool? update_progress = false) {
            TreeIter iter;
            list_store.append (out iter);
            if (pix != null) {
                if (row_file_size == null) {
                    list_store.set (iter, Columns.PIXBUF, pix, Columns.CONCEPT, row_concept);
                } else if (update_progress) {
                    list_store.set (iter, Columns.STATUS_SPIN, true, Columns.VALUE_SPIN, 1, Columns.CONCEPT, row_concept);
                } else {
                    list_store.set (iter, Columns.PIXBUF, pix, Columns.CONCEPT, row_concept, Columns.SIZE, row_file_size, Columns.N_FILES, row_file_number);
                }
            } else {
                list_store.set (iter, Columns.CONCEPT, row_concept);
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
