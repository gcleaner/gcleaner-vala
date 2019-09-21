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
    public static string to_readable_format_size (int64 bytes) {
        float size;
        var settings = Resources.get_setting_schema ();
        bool use_standard_iec = settings.get_boolean (Resources.PREFERENCES_STANDARD_SIZE_KEY);
        // It determines if IEC(1KiB = 1024 bytes) standard or SI(1kB = 1000 bytes) is used
        int base_size = (use_standard_iec) ? 1024 : 1000;
        string[] sufix = (use_standard_iec) ? Resources.SUFIX_SIZE_IEC : Resources.SUFIX_SIZE_SI;
        string format = "";
        
        size = bytes / base_size;
        for (int i = 0; i < sufix.length; i++) {
            if (size <= base_size) {
                size = Math.roundf (size * base_size) / base_size;
                format = "%.2f %s".printf (size, sufix[i]);
                break;
            } else {
                size = size / base_size;
            }
        }
        return format;
    }
    /*
     * For performance reasons the previous version used a method that used the "File" class, 
     * which performed exaggerated disk readings. Exceeding, even, more than 200MB
     * This is a new version that does not affect the performance of the System.
     */
    public static int64[] list_content (string src_path) {
        int64[] values = new int64[2];
        int64 file_counter = 0;
        int64 file_size = 0;
        string path = src_path.replace (" ", "\\ "); // Process.spawn_command_lyne_sync does not interpret blank spaces
        try {
            string size_stdout, counter_stdout;
            string redirect_error = "2>/dev/null";
            string[] options = {"-sb", "-f1", "-l", "-type f"};
            Process.spawn_command_line_sync ("bash -c \"du %s %s %s | cut %s\"".printf(options[0], path, redirect_error, options[1]), out size_stdout, null, null);
            Process.spawn_command_line_sync ("bash -c \"find %s %s %s | wc %s\"".printf(path, options[3], redirect_error, options[2]), out counter_stdout, null, null);
            file_size = (size_stdout.length != 0) ? int64.parse (size_stdout) : 0;
            file_counter = int64.parse (counter_stdout);
        } catch (SpawnError e) {
            stderr.printf ("Error: %s\n", e.message);
        }
        values[0] = file_counter;
        values[1] = file_size;
        return values;
    }

    public static int64[] generate_info_paths (string app_id, string option_id, string[] paths) {
        int64[] information = new int64[2];
        int64[] tmp_data = new int64[2];

        if (paths[0] == "null") {
            stderr.printf ("COM.GCLEANER.FILEUTLITIES [INVALID DIRECTORY: %s]\n", paths[0]);
        } else {
            foreach (string dir in paths) {
                File file = File.new_for_path (dir);
                try {
                    tmp_data = list_content (dir);
                } catch (Error e) {
                    stdout.printf ("COM.GCLEANER.FILEUTLITIES [Error: %s]\n", e.message);
                    stdout.printf (">>> Comprobe path: %s", dir);
                }
                information[0] += tmp_data[0];
                information[1] += tmp_data[1];
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
    
    public static bool copy_file (string from_path, string to_path) {
        MainLoop loop = new MainLoop ();
        bool status = true;
        File src_file = File.new_for_path (from_path);
        File dst_file = File.new_for_path (to_path);
        src_file.copy_async.begin (dst_file, 0, Priority.DEFAULT, null, (current_num_bytes, total_num_bytes) => {}, 
        (obj, res) => {
            try {
                status = src_file.copy_async.end (res);
                print ("Result: %s\n", status.to_string ());
            } catch (Error e) {
                print ("Error: %s\n", e.message);
                status = false;
            }
            loop.quit ();
        });
        loop.run ();
        return status;
    }

    // It will return the amount and weight of the deleted files.
    public static int64[] delete_files (string[] paths) {
        int64[] information = new int64[2];
        string str_path = "";
        int64 n_deleted_files = 0;    //Save the number of deleted files
        int64 size_deleted_files = 0; //Save the weight of deleted files

        foreach (string current_path in paths) {
            try {
                File file = File.new_for_path (current_path);
                if (file.query_exists ()) {
                    int64[] values = list_content (file.get_path ());
                    n_deleted_files += values[0];
                    size_deleted_files += values[1];
                    // We finally eliminated it
                    // If the this is a directory, it will only be deleted if it is empty.
                    if (FileUtils.test (file.get_path (), FileTest.IS_REGULAR)) {
                        file.delete ();
                    } else { // We remove it with other function if it is a directory non empty
                        delete_directory_recursively (file);
                        // With this we make sure to delete the empty folders
                        string stout = run_basic_command ("rm -fr " + file.get_path ());
                    }
                }
            } catch (Error e) {
                stderr.printf ("COM.GCLEANER.FILEUTLITIES: [WARNING: Unable to delete the file '%s': %s]\n", str_path, e.message);
            }
        }
        
        information[0] = n_deleted_files;
        information[1] = size_deleted_files;
        return information;
    }

    private static void delete_directory_recursively (File file, Cancellable? cancellable = null) {
        FileEnumerator enumerator;
        try {
            enumerator = file.enumerate_children ("standard::*", FileQueryInfoFlags.NOFOLLOW_SYMLINKS, cancellable);
        } catch (IOError e) {
            stderr.printf ("COM.GCLEANER.FILEUTLITIES: [WARNING: Unable to access the path '%s': %s\n", file.get_path (), e.message);
            return;
        }
        
        FileInfo info = null;
        while (cancellable.is_cancelled () == false && ((info = enumerator.next_file (cancellable)) != null)) {
            if (info.get_file_type () == FileType.DIRECTORY) {
                File sub_dir = file.resolve_relative_path (info.get_name ());
                delete_directory_recursively (sub_dir, cancellable);
            } else {
                File new_file = file.resolve_relative_path (info.get_name ());
                new_file.delete ();
            }
        }
        if (cancellable.is_cancelled ())
            throw new IOError.CANCELLED ("Operation was cancelled");
    }

    public static string[] reinterpret_paths (string[] paths) {
        string[] list_paths = {};
        string[] special_chars = {"~", "$USER", "?", "*"};
        string[] options = {"-q", "-e"};
        foreach (string current_path in paths) {
            current_path = current_path.replace (" ", "\\ ");
            if (item_array_in_string (special_chars, current_path) == false) {
                list_paths += current_path;
            } else {
                string paths_stdout;
                try {
                    Process.spawn_command_line_sync ("bash -c \"realpath %s %s %s\"".printf(options[0], options[1], current_path), out paths_stdout, null, null);
                    string[] parts = paths_stdout.split ("\n");
                    foreach (string dir in parts) {
                        if (dir.length > 0) list_paths += dir;
                    }
                } catch (SpawnError e) {
                    stderr.printf ("Error: %s\n", e.message);
                }
            }
        }
        return list_paths;
    }
}
