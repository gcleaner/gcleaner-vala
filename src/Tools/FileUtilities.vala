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

public class FileUtilities {
    public int64 fileCounter = 0;
    public int64 fileSize = 0;

    public static string to_readable_format_size (int64 bytes) {
        float size;
        string format = "";
        int base_size = 1024;
        
        size = bytes / base_size;
        if (size < base_size) {
            size = Math.roundf (size * 100) / 100;
            format = size.to_string () + " KB";
        } else {
            size = size / base_size;
            if (size < base_size) {
                size = Math.roundf (size * 100) / 100;
                format = size.to_string () + " MB";
            } else {
                size = size / base_size;
                if (size < base_size) {
                    size = Math.roundf (size * 100) / 100;
                    format = size.to_string () + " GB";
                }
            }
        }
        
        return format;
    }
    
    /*
     * Function to search for files and folder size
     */
    public static int64[] list_content (File file, Cancellable? cancellable = null) throws Error {
        int64[] values = new int64[2];
        int64 fileCounter = 0;
        int64 fileSize = 0;

        FileEnumerator enumerator;
        
        //First we ask if the current 'file' is a file, not a folder or directory
        if (FileUtils.test (file.get_path (), FileTest.IS_REGULAR)) {
            int64 file_size = 0;
            try {
                file_size = file.query_info ("*", FileQueryInfoFlags.NONE).get_size ();
            } catch (Error e) {
                stdout.printf("Error: %s", e.message);
            }
            
            if (file_size != 0) {
                fileCounter = fileCounter + 1;
                fileSize = fileSize + file_size;
            } else {
                fileCounter = fileCounter + 0;
                fileSize = fileSize + 0;
            }
            
            values[0] = fileCounter;
            values[1] = fileSize;
        } else { //'file' is a directory
            try {
                enumerator = file.enumerate_children ("standard::*", FileQueryInfoFlags.NOFOLLOW_SYMLINKS, cancellable);
            } catch (IOError e) {
                stderr.printf ("COM.GCLEANER.FILEUTLITIES: [WARNING: Unable to access the path '%s': %s\n", file.get_path (), e.message);
                values[0] = 0;
                values[1] = 0;
                return values;
            }
            
            FileInfo info = null;
            while (cancellable.is_cancelled () == false && ((info = enumerator.next_file (cancellable)) != null)) {
                if (info.get_file_type () == FileType.DIRECTORY) {
                    File sub_dir = file.resolve_relative_path (info.get_name ());
                    values = list_content (sub_dir, cancellable);
                    fileCounter = fileCounter + values[0];
                    fileSize = fileSize + values[1];
                } else {
                    fileCounter = fileCounter + 1;
                    fileSize = fileSize + info.get_size ();
                }
            }
            if (cancellable.is_cancelled ())
                throw new IOError.CANCELLED ("Operation was cancelled");
            
            values[0] = fileCounter;
            values[1] = fileSize;
        }
        
        return values;
    }
    
    public static int64[] generate_info_paths (string app_id, string option_id, string[] paths) {
        int64[] information = new int64[2];
        int64[] tmp_data = new int64[2];
        var sql_utils = new GCleaner.Tools.SqliteUtils ();

        if (paths[0] == "null") {
            stderr.printf ("COM.GCLEANER.FILEUTLITIES [INVALID DIRECTORY: %s]\n", paths[0]);
        } else {
            foreach (string dir in paths) {
                File file = File.new_for_path (dir);
                
                try {
                    tmp_data = list_content (file, new Cancellable ());
                } catch (Error e) {
                    stdout.printf ("COM.GCLEANER.FILEUTLITIES [Error: %s]\n", e.message);
                    stdout.printf (">>> Comprobe path: %s", dir);
                }

                information[0] += tmp_data[0];
                information[1] += tmp_data[1];

                // We update the database
                sql_utils.insert_info_data (app_id, option_id, file.get_path (), tmp_data[0], tmp_data[1]);
            }
        }

        return information;
    }
    
    public static bool exists_file (string path) {
        bool status = false;
        File file = File.new_for_path (path);
        status = (file.query_exists ()) ? true: false;
        
        return status;
    }

    // It will return the amount and weight of the deleted files.
    public static int64[] delete_files (string[] paths) {
        int64[] information = new int64[2];

        string str_path = "";
        int64 n_deleted_files = 0;    //Save the number of deleted files
        int64 size_deleted_files = 0; //Save the weight of deleted files
        int file_size;

        foreach (string current_path in paths) {
            try {
                File file = File.new_for_path (current_path);
                if (file.query_exists ()) {
                    int64[] values = list_content (file, new Cancellable ());
                    n_deleted_files += values[0];
                    size_deleted_files += values[1];
                    // We finally eliminated it
                    file.delete ();
                }
            } catch (Error e) {
                stderr.printf ("COM.GCLEANER.FILEUTLITIES: [WARNING: Unable to delete the file '%s': %s]\n", str_path, e.message);
            }
        }
        
        information[0] = n_deleted_files;
        information[1] = size_deleted_files;
        return information;
    }

    // Method for interpreting paths using regular expressions
    // and environment variables
    public static string[] reinterpret_paths (string[] paths) {
        string[] complete_paths = {};
        string[] aux_temp_parents = {};
        string[] new_updated_parents = {};
        
        string str_home = GLib.Environment.get_variable ("HOME");
        string str_user = GLib.Environment.get_variable ("USER");
        
        // This is to determine the character(s) 
        // depending on the wildcard characters 
        string asterisk = "[.]{0,1}[a-zA-Z0-9 ]{0,}";
        string question_mark = "[a-zA-Z0-9.-_]";
        
        foreach (string current_path in paths) {
            if (current_path.contains ("~") || current_path.contains ("$USER")) {
                if (current_path.contains ("~")) {
                    current_path = current_path.replace ("~", str_home);
                } else {
                    current_path = current_path.replace ("$USER", str_user);
                }
            }
            
            bool build_base = true;
            int count = 0;  // When its value is 1 it stores the current parent directory in an array.
            string base_path = "";
            string[] dirs_parts = current_path.split ("/");
            
            // We search directory by directory until we come 
            // across a special character.
            for (int i = 0; i < dirs_parts.length; i++) {
                string current_dir = dirs_parts[i];
                
                if (current_dir == "") {
                    continue;
                }
                
                // This is for building the Base path that does not contain special characters
                if ((current_dir.contains ("*") || current_dir.contains ("?")) == false && build_base == true) {
                    if (current_dir != "") {
                        File file_taste = File.new_for_path (base_path + "/" + current_dir);
                        if (file_taste.query_exists ()) {
                            base_path = base_path + "/" + current_dir;
                        } else {
                            // If it doesn't exist. We got out of this 
                            // loop and analyzed another path.
                            break;
                        }
                        
                        // If the string is the last component of the path
                        if (i == (dirs_parts.length - 1)) {
                            complete_paths += base_path;
                        }
                    }
                } else {
                    count++;
                    // When its value is 1 it stores the current parent directory in an array.
                    // It's good to have something in that array. 
                    // Otherwise this will be an empty arrangement or we could have duplicates.
                    if (count == 1) {
                        aux_temp_parents += base_path;
                        build_base = false;
                    }
                    
                    foreach (string tmp_parent in aux_temp_parents) {
                        if (tmp_parent == "")
                            continue;
                        
                        File file = File.new_for_path (tmp_parent);
                        FileEnumerator enumerator;
                        try {
                            enumerator = file.enumerate_children (FILE_ATTRIBUTE_STANDARD_DISPLAY_NAME, 0, null);
                            FileInfo fileinfo = enumerator.next_file (null);
                            
                            // We compare file by file with the string to match
                            while (fileinfo != null) {
                                string subpath_to_find = tmp_parent + "/" + fileinfo.get_name ();
                                
                                if (current_dir.contains ("*") || current_dir.contains ("?")) {
                                    if (current_dir.char_count () == 1) {
                                        if (i == (dirs_parts.length - 1)) {
                                            // If it is the last lap, we add directly regardless of whether it is file or folder
                                            new_updated_parents += subpath_to_find;
                                        } else if (fileinfo.get_file_type () == FileType.DIRECTORY) {
                                            // This is just for adding directories. Files wouldn't go because it scans directories 
                                            new_updated_parents += subpath_to_find;
                                        }
                                    } else {
                                        // We replace with the corresponding character to find matches.
                                        string str_to_match = "";
                                        string str_tmp = current_dir;
                                        if (current_dir.contains ("*")) {
                                            str_tmp = str_tmp.replace ("*", asterisk);
                                        }
                                        if (current_dir.contains ("?")) {
                                            str_tmp = str_tmp.replace ("?", question_mark);
                                        }
                                        str_to_match = str_tmp;
                                        try {
                                            Regex regex = new Regex (str_to_match);
                                            // If the string matches the filename
                                            if (regex.match (fileinfo.get_name ())) {
                                                if (i == (dirs_parts.length - 1)) {
                                                    // If it is the last lap, we add directly regardless of whether it is file or folder
                                                    new_updated_parents += subpath_to_find;
                                                } else if (fileinfo.get_file_type () == FileType.DIRECTORY) {
                                                    // This is just for adding directories. Files wouldn't go because it scans directories 
                                                    new_updated_parents += subpath_to_find;
                                                }
                                            }
                                        } catch (RegexError e) {
                                            stdout.printf ("Error %s\n", e.message);
                                        }
                                    }
                                } else {
                                    if (current_dir == fileinfo.get_name ()) {
                                        if (i == (dirs_parts.length - 1)) {
                                            // If it is the last lap, we add directly regardless of whether it is file or folder
                                            new_updated_parents += subpath_to_find;
                                        } else if (fileinfo.get_file_type () == FileType.DIRECTORY) {
                                            // This is just for adding directories. Files wouldn't go because it scans directories 
                                            new_updated_parents += subpath_to_find;
                                        }
                                    }
                                }
                                // Next file/folder
                                fileinfo = enumerator.next_file (null);
                            }
                        } catch (IOError e) {
                            stderr.printf ("WARNING: Unable to access the path '%s': %s\n", file.get_path (), e.message);
                        }
                    }
                    // We update the main directories.
                    // This is to have stored in an array the directories that 
                    // match the criteria to be able to keep advancing to the subdirectories.
                    aux_temp_parents.resize (1);
                    aux_temp_parents[0] = "";
                    aux_temp_parents = new_updated_parents;
                    new_updated_parents[0] = "";
                    new_updated_parents.resize (1);
                }
            }// For loop end
            
            // For each turn of the cycle we update the data of the main array.
            if (aux_temp_parents.length >= 1) {
                foreach (string val in aux_temp_parents) {
                    if (val != "" && val != "null" && val != null) {
                        complete_paths += val;
                    }
                }
            }
            
            aux_temp_parents.resize (1);
            aux_temp_parents[0] = "";
        }
        if (complete_paths.length == 0) {
            complete_paths += "null";
        }
        
        return complete_paths;
    }
}
