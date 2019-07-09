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
        
        public ResultsArea () {
            //LIST STORE - SCAN/CLEANING INFORMATION
            list_store = new Gtk.ListStore (6, typeof (bool), typeof(int), typeof(Gdk.Pixbuf), typeof(string), typeof(string), typeof(string));
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
            column_spinner.add_attribute (spinner_cell, "active", 0);
            column_spinner.add_attribute (spinner_cell, "pulse", 1);
            tree_view.append_column (column_spinner);
            
            pixbuf_cell = new CellRendererPixbuf ();
            column_pix = new Gtk.TreeViewColumn ();
            column_pix.pack_start (pixbuf_cell, false);
            column_pix.add_attribute (pixbuf_cell, "pixbuf", 2);
            tree_view.append_column (column_pix);
            
            concept_cell = new CellRendererText ();
            column_concept = new Gtk.TreeViewColumn ();
            column_concept.set_title ("Concept");
            column_concept.pack_start (concept_cell, false);
            column_concept.add_attribute (concept_cell, "text", 3);
            tree_view.append_column (column_concept);
            
            size_cell = new CellRendererText ();
            column_size = new Gtk.TreeViewColumn ();
            column_size.set_title ("Size");
            column_size.pack_start (size_cell, false);
            column_size.add_attribute (size_cell, "text", 4);
            tree_view.append_column (column_size);
            
            number_cell = new CellRendererText ();
            column_number = new Gtk.TreeViewColumn ();
            column_number.set_title ("Number of files");
            column_number.pack_start (number_cell, false);
            column_number.add_attribute (number_cell, "text", 5);
            tree_view.append_column (column_number);
        }
        
        public void clear_results () {
            list_store.clear ();
        }

        public void append_data_to_list_store (Gdk.Pixbuf? pix = null, string row_concept, string? row_file_size = null, string? row_file_number = null) {
            TreeIter iter;
            list_store.append (out iter);
            if (pix != null) {
                if (row_file_size == null) {
                    list_store.set (iter, 2, pix, 3, row_concept);
                } else {
                    list_store.set (iter, 2, pix, 3, row_concept, 4, row_file_size, 5, row_file_number);
                }
            } else {
                list_store.set (iter, 3, row_concept);
            }
        }

        public void sort_fields_before_print () {
            tree_view.move_column_after (column_spinner, column_pix);
            tree_view.move_column_after (column_pix, column_number);
        }

        public void sort_fields_after_print () {
            tree_view.move_column_after (column_pix, column_spinner);
            tree_view.move_column_after (column_spinner, column_number);
        }
    }
}
