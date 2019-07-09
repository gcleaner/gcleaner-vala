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
using Sqlite3;

namespace GCleaner.Tools {
    public class SqliteUtils {
        private Sqlite3.Database db;
        private string path_db;
        
        public SqliteUtils () {
            string home = GLib.Environment.get_variable ("HOME");
            path_db = home + Constants.STORE_CONFIG_DIR + "/data_info.db";
            
            
            if (FileUtilities.exists_file (path_db) == false)
                create_database ();
            else
                prepare_database ();
        }

        ~SqliteUtils() {
            Sqlite.Database.close (db);
        }

        public void close_database() {
            Sqlite.Database.close (db);
        }

        public bool prepare_database () {
            string errmsg;
            bool status;
            if (FileUtilities.exists_file (path_db) == false) {
                status = create_database ();
            } else {
                // Empty table if exists
                int ec = Sqlite.Database.open (path_db, out db);
                if (ec != Sqlite.OK) {
                    stderr.printf ("Can't open database: %d: %s\n", db.errcode (), db.errmsg ());
                    status = false;
                } else {
                    string query = "DELETE FROM Data;";
                    ec = db.exec (query, null, out errmsg);
                    if (ec != Sqlite.OK) {
                        stderr.printf ("Error: %s\n", errmsg);
                        status = false;
                    }
                    status = true;
                }
            }
            return status;
        }

        public bool create_database () {
            string errmsg;
            int ec = Sqlite.Database.open (path_db, out db);
            if (ec != Sqlite.OK) {
                stderr.printf ("Can't open database: %d: %s\n", db.errcode (), db.errmsg ());
                return false;
            } else {
                string query = """
                CREATE TABLE Data (
                    app_name TEXT NOT NULL,
                    app_option TEXT NOT NULL,
                    path TEXT,
                    file_number INTEGER NOT NULL,
                    size INTEGER,
                );
                """;

                ec = db.exec (query, null, out errmsg);
                if (ec != Sqlite.OK) {
                    stderr.printf ("Error: %s\n", errmsg);
                    return false;
                }
                
                return true;
            }
        }
        
        public void insert_info_data (string app_id, string option_id, string path, int64 file_number, int64 file_size) {
            string errmsg;
            int ec = Sqlite.Database.open (path_db, out db);
            if (ec != Sqlite.OK) {
                stderr.printf ("Can't open database: %d: %s\n", db.errcode (), db.errmsg ());
            } else {
                string query = """
                INSERT INTO Data (app_name, app_option, path, file_number, size) VALUES (%s, %s, %s, %l, %l);""".printf (app_id, option_id, path, file_number, file_size);
                ec = db.exec (query, null, out errmsg);
                if (ec != Sqlite.OK)
                    stderr.printf ("Error: %s\n", errmsg);
            }
        }

        public void insert_advanced_info (string app_id, string option_id, int64 file_number, int64 file_size) {
            string errmsg;
            int ec = Sqlite.Database.open (path_db, out db);
            if (ec != Sqlite.OK) {
                stderr.printf ("Can't open database: %d: %s\n", db.errcode (), db.errmsg ());
            } else {
                string query = """
                INSERT INTO Data (app_name, app_option, file_number, size) VALUES (%s, %s, %l, %l);""".printf (app_id, option_id, file_number, file_size);
                ec = db.exec (query, null, out errmsg);
                if (ec != Sqlite.OK)
                    stderr.printf ("Error: %s\n", errmsg);
            }
        }

        public string[]? get_all_paths_of (string app_id, string option_id) {
            string[] paths = {};

            Sqlite.Statement stmt;
            string query = "SELECT path FROM Data WHERE app_name = %s and option_id = %s;".printf (app_id, option_id);
            int ec = db.prepare_v2 (query, query.length, out stmt);
            if (ec != Sqlite.OK) {
                stderr.printf ("Error: %d: %s\n", db.errcode (), db.errmsg ());
                return null;
            }
            
            int cols = stmt.column_count ();
            while (stmt.step () == Sqlite.ROW) {
                for (int i = 0; i < cols; i++) {
                    string val = stmt.column_text (i) ?? "<none>";
                    if (val != "<none>") {
                        paths += val;
                    }
                }
            }

            return paths;
        }

        private int64 get_sum_int_field_of (string app_id, string option_id, string field) {
            int64 total = 0;

            Sqlite.Statement stmt;
            string query = "SELECT SUM(%s) FROM Data WHERE app_name = %s and option_id = %s;".printf (field, app_id, option_id);
            int ec = db.prepare_v2 (query, query.length, out stmt);
            if (ec != Sqlite.OK) {
                stderr.printf ("Error: %d: %s\n", db.errcode (), db.errmsg ());
                return 0;
            }
            
            int cols = stmt.column_count ();
            while (stmt.step () == Sqlite.ROW) {
                for (int i = 0; i < cols; i++) {
                    string val = stmt.column_text (i) ?? "<none>";

                    total = (val != "<none>") ? int64.parse (val) : 0;
                }
            }

            return total;
        }

        public int64 get_file_size_of (string app_id, string option_id) {
            int64 total_size = 0;
            string field = "size";
            total_size = get_sum_int_field_of (app_id, option_id, field);
            return total_size;
        }

        public int64 get_file_number_of (string app_id, string option_id) {
            int64 total_files = 0;
            string field = "file_number";
            total_files = get_sum_int_field_of (app_id, option_id, field);
            return total_files;
        }
    }
}
