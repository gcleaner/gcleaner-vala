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

/*
 * Here are declared constants and others resources
 */
namespace Resources {
    public const string STORE_CONFIG_DIR = "/.local/share/gcleaner";
    public const string INSTALL_PREFIX = "/usr";
    public const string DATADIR = "/usr/share";
    public const string PKGDATADIR = "/usr/share/gcleaner";
    public const string PROGRAM_NAME = "GCleaner";
    public const string RELEASE_NAME = "Bosch Aerotwin";
    public const string VERSION = "0.01.134";
    public const string VERSION_INFO = "Initial release of GCleaner.";
    public const string EXEC_NAME = "gcleaner";
    public const string APP_LAUNCHER = "gcleaner.desktop";

    /*
     * About GCleaner
     */
    public const string[] AUTHORS = {
        "Juan Pablo Lozano <lozanotux@gmail.com>",
        "Andrés Segovia <andy.dev536@gmail.com>"
    };
    public const string[] ARTISTS = {
        "Juan Pablo Lozano <lozanotux@gmail.com>", 
        "Ivan Matias Suarez <ivan.msuar@gmail.com>"
    };
    public const string[] DOCUMENTERS = {
        "Juan Pablo Lozano <lozanotux@gmail.com>",
        "Andrés Segovia <andy.dev536@gmail.com>"
    };

    public const string DEFAULT_LANGUAGE = "en";
    public const string[] LANGUAGE_CODES = {
        "en", "es"
    }
    public const string[] LANGUAGE_NAMES = {
        "english", "spanish"
    }
    
    /*
     * Constants that contain information about the options of each program
     */ 
    public const string BACKUP_INFO = "Backup files.\n";
    public const string CACHE_NET_INFO = "Temporary files downloaded for later use and reduce the bandwidth.\n";
    public const string CACHE_PROG_INFO = "Files temporarily created for later use.\n";
    public const string CHAT_LOGS_INFO = "A chat log is an archive of transcripts from online chat and instant messaging conversations.\n";
    public const string COOKIES_INFO = "Text file, which contain information such as web site preferences, authentication, and tracking identification.\n";
    public const string CRASH_INFO = "File with reports of unexpected closures.\n";
    public const string DOCS_INFO = "A list of recent documents.\n";
    public const string DOM_INFO = "The DOM storage is designed to store persistent data similar to cookies but with greatly enhanced capacity.\n";
    public const string DOWNLOAD_INFO = "Contains a list of files downloaded\n";
    public const string HISTORY_NET_INFO = "List of visited web pages\n";
    public const string HISTORY_PROG_INFO = "History of modifications\n";
    public const string LOGS_INFO = "File that records either events that occur in an operating system or other software runs\n";
    public const string PASS_INFO = "A database of usernames and passwords as well as a list of sites that should not store passwords.\n";
    public const string PLACES_INFO = "A database of URLs including bookmarks, favicons, and a history of visited web sites.\n";
    public const string PREFS_INFO = "Settings for individual sites\n";
    public const string SAVED_FORMHISTORY_INFO = "A history of forms entered in web sites and in the Search bar\n";
    public const string SESSION_INFO = "Delete the current session\n";
    public const string TMP_INFO = "File generated in order to contain information transiently.\n";
    public const string USED_INFO = "List of files most recent used.\n";
    // Special
    public const string CACHE_PKG_INFO = "List of temporary update and package files.\n";
    public const string CONF_PKG_INFO = "List of packages that have been deleted, but whose configuration files still remain.\n";
    public const string OLDKERNELS_INFO = "Purge old kernels. Please, be careful.\n";
    public const string TERMINAL_INFO = "Clean the Bash history.\n";
    public const string THUMBNAILS_INFO = "Clean the generated cache by the images.\n";
    public const string TRASH_INFO = "Files housed in the Trash bin.\n";
    
    public const string WARNING_LOW_INFO = "<b>Warning level: </b>" + "Low";
    public const string WARNING_HIGH_INFO = "<b>Warning level: </b>" + "High";

}
