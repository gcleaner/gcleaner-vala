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
    public const string CONFIG_AUTOSTART_DIR = "/.config/autostart";
    public const string STORE_CONFIG_DIR = "/.local/share/gcleaner";
    public const string INSTALL_PREFIX = "/usr";
    public const string DATADIR = "/usr/share";
    public const string APP_SOURCE_DIR = "/usr/share/applications";
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
    };
    public const string[] LANGUAGES_SUPPORTED = {
        "english", "spanish"
    };

    public const string PREFERENCES_LANGUAGE_KEY = "language";
    public const string PREFERENCES_AUTOSTART_KEY = "start-with-system";
    public const string PREFERENCES_STANDARD_SIZE_KEY = "standard-iec-size-bytes";
    public const string SETTINGS_VALUE_OPENING_X = "opening-x";
    public const string SETTINGS_VALUE_OPENING_Y = "opening-y";
    public const string SETTINGS_VALUE_WINDOW_WIDTH = "window-width";
    public const string SETTINGS_VALUE_WINDOW_HEIGHT = "window-height";

    public const string[] SUFIX_SIZE_IEC = {"KiB", "MiB", "GiB"};
    public const string[] SUFIX_SIZE_SI = {"kB", "MB", "GB"};

    public const string DESKTOP_PANTHEON = "PANTHEON";
    public const string DESKTOP_GNOME = "GNOME";

    public const string BUTTON_SCAN = "Analyze";
    public const string BUTTON_CLEAN = "Clean";
    public const string FIELD_CONCEPT = "Concept";
    public const string FIELD_SIZE = "Size";
    public const string FIELD_N_FILES = "Number of files";
    /*
     * Constants that contain information about the options of each program
     */ 
    public const string DESCRIPTION_BACKUP_LABEL = "Backup files.\n";
    public const string DESCRIPTION_CACHE_NET_LABEL = "Temporary files downloaded for later use and reduce the bandwidth.\n";
    public const string DESCRIPTION_CACHE_PROG_LABEL = "Files temporarily created for later use.\n";
    public const string DESCRIPTION_CHAT_LOGS_LABEL = "A chat log is an archive of transcripts from online chat and instant messaging conversations.\n";
    public const string DESCRIPTION_COOKIES_LABEL = "Text file, which contain information such as web site preferences, authentication, and tracking identification.\n";
    public const string DESCRIPTION_CRASH_LABEL = "File with reports of unexpected closures.\n";
    public const string DESCRIPTION_DOCS_LABEL = "A list of recent documents.\n";
    public const string DESCRIPTION_DOM_LABEL = "The DOM storage is designed to store persistent data similar to cookies but with greatly enhanced capacity.\n";
    public const string DESCRIPTION_DOWNLOAD_LABEL = "Contains a list of files downloaded\n";
    public const string DESCRIPTION_HISTORY_NET_LABEL = "List of visited web pages\n";
    public const string DESCRIPTION_HISTORY_PROG_LABEL = "History of modifications\n";
    public const string DESCRIPTION_LOGS_LABEL = "File that records either events that occur in an operating system or other software runs\n";
    public const string DESCRIPTION_PASS_LABEL = "A database of usernames and passwords as well as a list of sites that should not store passwords.\n";
    public const string DESCRIPTION_PLACES_LABEL = "A database of URLs including bookmarks, favicons, and a history of visited web sites.\n";
    public const string DESCRIPTION_PREFS_LABEL = "Settings for individual sites\n";
    public const string DESCRIPTION_SAVED_FORMHISTORY_LABEL = "A history of forms entered in web sites and in the Search bar\n";
    public const string DESCRIPTION_SESSION_LABEL = "Delete the current session\n";
    public const string DESCRIPTION_TMP_LABEL = "File generated in order to contain information transiently.\n";
    public const string DESCRIPTION_USED_LABEL = "List of files most recent used.\n";
    // Special
    public const string DESCRIPTION_CACHE_PKG_LABEL = "List of temporary update and package files.\n";
    public const string DESCRIPTION_CONF_PKG_LABEL = "List of packages that have been deleted, but whose configuration files still remain.\n";
    public const string DESCRIPTION_OLDKERNELS_LABEL = "Purge old kernels. Please, be careful.\n";
    public const string DESCRIPTION_TERMINAL_LABEL = "Clean the Bash history.\n";
    public const string DESCRIPTION_THUMBNAILS_LABEL = "Clean the generated cache by the images.\n";
    public const string DESCRIPTION_TRASH_LABEL = "Files housed in the Trash bin.\n";
    public const string DESCRIPTION_UNKNOWN_LABEL = "Unknown information.\n";
    
    public const string DESCRIPTION_WARNING_LOW_LABEL = "<b>Warning level: </b> Low";
    public const string DESCRIPTION_WARNING_HIGH_LABEL = "<b>Warning level: </b> High";

    public const string DESCRIPTION_BACKUP_ID = "backup";
    public const string DESCRIPTION_CACHE_NET_ID = "internet-cache";
    public const string DESCRIPTION_CACHE_PROG_ID = "cache";
    public const string DESCRIPTION_CHAT_LOGS_ID = "chat-logs";
    public const string DESCRIPTION_COOKIES_ID = "cookies";
    public const string DESCRIPTION_CRASH_ID = "crash";
    public const string DESCRIPTION_DOCS_ID = "docs";
    public const string DESCRIPTION_DOM_ID = "dom";
    public const string DESCRIPTION_DOWNLOAD_ID = "download";
    public const string DESCRIPTION_HISTORY_NET_ID = "internet-history";
    public const string DESCRIPTION_HISTORY_PROG_ID = "history";
    public const string DESCRIPTION_LOGS_ID = "logs";
    public const string DESCRIPTION_PASS_ID = "pass";
    public const string DESCRIPTION_PLACES_ID = "places";
    public const string DESCRIPTION_PREFS_ID = "prefs";
    public const string DESCRIPTION_RECENT_DOCS_ID = "recent-docs";
    public const string DESCRIPTION_SAVED_FORMHISTORY_ID = "form-history";
    public const string DESCRIPTION_SESSION_ID = "session";
    public const string DESCRIPTION_TMP_ID = "tmp";
    public const string DESCRIPTION_USED_ID = "used";
    public const string DESCRIPTION_CACHE_PKG_ID = "cache-pkg";
    public const string DESCRIPTION_CONF_PKG_ID = "configuration-pkg";
    public const string DESCRIPTION_OLDKERNELS_ID = "old-kernels";
    public const string DESCRIPTION_TERMINAL_ID = "terminal-history";
    public const string DESCRIPTION_THUMBNAILS_ID = "thumbnails";
    public const string DESCRIPTION_TRASH_ID = "trash";

    public const string QUESTION_PHRASE_CLEAN = "Are you sure you want to continue?";
    public const string QUESTION_PHRASE_CACHE_PKG = "Are you sure you want to delete cache and obsolete Package System files?";
    public const string QUESTION_PHRASE_CONF_PKG = "Are you sure you want to delete orphan Package System files?";
    public const string QUESTION_PHRASE_OLDKERNELS = "Are you sure you want to delete the old kernels?";
    public const string QUESTION_PHRASE_PASS = "Are you sure you want to remove %s passwords?";
    public const string QUESTION_PHRASE_UNKNOWN = DESCRIPTION_UNKNOWN_LABEL;

    public const string CATEGORY_APPLICATIONS = "applications";
    public const string CATEGORY_SYSTEM = "system";
    public const string[] CATEGORIES = {CATEGORY_APPLICATIONS, 
                                        CATEGORY_SYSTEM};
    public const string[] ADVANCED_OPTIONS = {DESCRIPTION_CACHE_PKG_ID, 
                                              DESCRIPTION_CONF_PKG_ID, 
                                              DESCRIPTION_OLDKERNELS_ID};
    public const string[] SYSTEM_APPS = {"APT", "System"};

    public unowned string get_description_info (string id_option_type) {
        switch (id_option_type) {
            case DESCRIPTION_BACKUP_ID:
                return DESCRIPTION_BACKUP_LABEL;
            case DESCRIPTION_CACHE_NET_ID:
                return DESCRIPTION_CACHE_NET_LABEL;
            case DESCRIPTION_CACHE_PROG_ID:
                return DESCRIPTION_CACHE_PROG_LABEL;
            case DESCRIPTION_CHAT_LOGS_ID:
                return DESCRIPTION_CHAT_LOGS_LABEL;
            case DESCRIPTION_COOKIES_ID:
                return DESCRIPTION_COOKIES_LABEL;
            case DESCRIPTION_CRASH_ID:
                return DESCRIPTION_CRASH_LABEL;
            case DESCRIPTION_DOCS_ID:
                return DESCRIPTION_DOCS_LABEL;
            case DESCRIPTION_DOM_ID:
                return DESCRIPTION_DOM_LABEL;
            case DESCRIPTION_DOWNLOAD_ID:
                return DESCRIPTION_DOWNLOAD_LABEL;
            case DESCRIPTION_HISTORY_NET_ID:
                return DESCRIPTION_HISTORY_NET_LABEL;
            case DESCRIPTION_HISTORY_PROG_ID:
                return DESCRIPTION_HISTORY_PROG_LABEL;
            case DESCRIPTION_LOGS_ID:
                return DESCRIPTION_LOGS_LABEL;
            case DESCRIPTION_PASS_ID:
                return DESCRIPTION_PASS_LABEL;
            case DESCRIPTION_PLACES_ID:
                return DESCRIPTION_PLACES_LABEL;
            case DESCRIPTION_PREFS_ID:
                return DESCRIPTION_PREFS_LABEL;
            case DESCRIPTION_RECENT_DOCS_ID:
                return DESCRIPTION_DOCS_LABEL;
            case DESCRIPTION_SAVED_FORMHISTORY_ID:
                return DESCRIPTION_SAVED_FORMHISTORY_LABEL;
            case DESCRIPTION_SESSION_ID:
                return DESCRIPTION_SESSION_LABEL;
            case DESCRIPTION_TMP_ID:
                return DESCRIPTION_TMP_LABEL;
            case DESCRIPTION_USED_ID:
                return DESCRIPTION_USED_LABEL;
            case DESCRIPTION_CACHE_PKG_ID:
                return DESCRIPTION_CACHE_PKG_LABEL;
            case DESCRIPTION_CONF_PKG_ID:
                return DESCRIPTION_CONF_PKG_LABEL;
            case DESCRIPTION_OLDKERNELS_ID:
                return DESCRIPTION_OLDKERNELS_LABEL;
            case DESCRIPTION_TERMINAL_ID:
                return DESCRIPTION_TERMINAL_LABEL;
            case DESCRIPTION_THUMBNAILS_ID:
                return DESCRIPTION_THUMBNAILS_LABEL;
            case DESCRIPTION_TRASH_ID:
                return DESCRIPTION_TRASH_LABEL;
            default:
                return DESCRIPTION_UNKNOWN_LABEL;
        }
    }

    public string get_question_phrase (string option_id_type, string app_name) {
        switch (option_id_type) {
            case DESCRIPTION_CACHE_PKG_ID:
                return QUESTION_PHRASE_CACHE_PKG;
            case DESCRIPTION_CONF_PKG_ID:
                return QUESTION_PHRASE_CONF_PKG;
            case DESCRIPTION_OLDKERNELS_ID:
                return QUESTION_PHRASE_OLDKERNELS;
            case DESCRIPTION_PASS_ID:
                return QUESTION_PHRASE_PASS.printf (app_name);
            default:
                return QUESTION_PHRASE_UNKNOWN;
        }
    }

    public const string ICON_APPLICATIONS_SYSTEM = "applications-system";
    public const string ICON_DIALOG_INFORMATION = "dialog-information";
    public const string ICON_DIALOG_WARNING = "dialog-warning";
    public const string ICON_OPEN_MENU = "open-menu";
    public const string ICON_PACKAGE_GENERIC = "package-x-generic";

    public GLib.Settings get_setting_schema () {
        return new GLib.Settings ("org.gcleaner");
    }

    public const string SHORT_VERSION_LICENSE = """
        This program is released under the terms of the GPL (General Public License) 
        as published by the Free Software Foundation, is an application that 
        will be useful, but WITHOUT ANY WARRANTY; for details, visit: 
        http://www.gnu.org/licenses/gpl.html
    """;
    public const string LICENSE = """
        GCleaner is free software; you can redistribute it and/or modify it under the 
        terms of the GNU Lesser General Public License as published by the Free 
        Software Foundation; either version 2.1 of the License, or (at your option) 
        any later version.

        GCleaner is distributed in the hope that it will be useful, but WITHOUT 
        ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
        FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for 
        more details.

        You should have received a copy of the GNU Lesser General Public License 
        along with GCleaner; if not, write to the Free Software Foundation, Inc., 
        51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
    """;
}
