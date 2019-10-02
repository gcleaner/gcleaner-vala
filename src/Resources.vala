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
    public const string PROGRAM_NAME = "GCleaner";
    public const string RELEASE_NAME = "Bosch Aerotwin";
    public const string VERSION = "0.01.134";
    public const string VERSION_INFO = "Initial release of GCleaner.";
    public const string EXEC_NAME = "gcleaner";
    public const string APP_LAUNCHER = "gcleaner.desktop";
    public const string CONFIG_AUTOSTART_DIR = "/.config/autostart";
    public const string STORE_CONFIG_DIR = "/.local/share/gcleaner";
    public const string INSTALL_PREFIX = "/usr";
    public const string DATADIR = "/usr/share";
    public const string APP_SOURCE_DIR = "/usr/share/applications";
    public const string PKGDATADIR = "/usr/share/gcleaner";
    
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

    /*
     * Constants that contain the names of the properties of the Json's objects.
     */ 
    public const string PROPERTY_APP_NAME = "name";
    public const string PROPERTY_APP_TYPE = "type";
    public const string PROPERTY_APP_ICON = "icon";
    public const string PROPERTY_KEY = "key-xml";
    public const string PROPERTY_ALL_OPTIONS = "all-options";
    public const string PROPERTY_N_OPTIONS = "number-options";
    public const string PROPERTY_OPTION_ID = "option-id";
    public const string PROPERTY_OPTION_ICON = "option-icon";
    public const string PROPERTY_OPTION_COMMANDS = "commands";
    public const string PROPERTY_PATHS = "paths";
    public const string PROPERTY_WARNING = "warning";
    public const string PROPERTY_CMD_SIZE = "get-size";
    public const string PROPERTY_CMD_QUANTITY = "get-quantity";
    public const string PROPERTY_CMD_CLEAN = "clean";

    public const string[] SUFIX_SIZE_IEC = {"KiB", "MiB", "GiB"};
    public const string[] SUFIX_SIZE_SI = {"kB", "MB", "GB"};

    public const string DESKTOP_PANTHEON = "PANTHEON";
    public const string DESKTOP_GNOME = "GNOME";

    public const string BUTTON_SCAN = _("Analyze");
    public const string BUTTON_CLEAN = _("Clean");
    public const string BUTTON_CLOSE = _("Close");
    public const string FIELD_CONCEPT = _("Concept");
    public const string FIELD_SIZE = _("Size");
    public const string FIELD_N_FILES = _("Number of files");
    public const string ABOUT_COMMENTS = _("Clean your System GNU/Linux");
    public const string ABOUT_FIELD = _("About...");
    public const string GENERAL_FIELD = _("General");
    public const string PREFERENCES_FIELD = _("Preferences");
    /*
     * Constants containing information about the options and type of each program
     */
    public const string BACKUP_LABEL = _("Backup files");
    public const string CACHE_NET_LABEL = _("Internet cache");
    public const string CACHE_PROG_LABEL = _("Cache");
    public const string CHAT_LOGS_LABEL = _("Chat logs");
    public const string COOKIES_LABEL = _("Cookies");
    public const string CRASH_LABEL = _("Bug reports");
    public const string DOCS_LABEL = _("Recent documents");
    public const string DOM_LABEL = _("DOM storage");
    public const string DOWNLOAD_LABEL = _("Download history");
    public const string DOWNLOAD_PODCASTS_LABEL = _("Podcasts downloaded");
    public const string HISTORY_NET_LABEL = _("Internet history");
    public const string HISTORY_PROG_LABEL = _("History");
    public const string LOGS_LABEL = _("Logs files");
    public const string PASS_LABEL = _("Passwords");
    public const string PLACES_LABEL = _("Places");
    public const string PREFS_LABEL = _("Site preferences");
    public const string SAVED_FORMHISTORY_LABEL = _("Saved form history");
    public const string SESSION_LABEL = _("Session restoration");
    public const string TMP_LABEL = _("Temporary files");
    public const string USED_LABEL = _("Most recently used files");
    public const string CACHE_PKG_LABEL = _("Cache");
    public const string CONF_PKG_LABEL = _("Orphan packages");
    public const string OLDKERNELS_LABEL = _("Old kernels");
    public const string TERMINAL_LABEL = _("Terminal history");
    public const string THUMBNAILS_LABEL = _("Thumbnails");
    public const string TRASH_LABEL = _("Trash");
    public const string UNKNOWN_LABEL = _("Unknown information.\n");

    public const string DESCRIPTION_BACKUP_LABEL = _("Backup files.\n");
    public const string DESCRIPTION_CACHE_NET_LABEL = _("Temporary files downloaded for later use and reduce the bandwidth.\n");
    public const string DESCRIPTION_CACHE_PROG_LABEL = _("Files temporarily created for later use.\n");
    public const string DESCRIPTION_CHAT_LOGS_LABEL = _("A chat log is an archive of transcripts from online chat and instant messaging conversations.\n");
    public const string DESCRIPTION_COOKIES_LABEL = _("Text file, which contain information such as web site preferences, authentication, and tracking identification.\n");
    public const string DESCRIPTION_CRASH_LABEL = _("File with reports of unexpected closures.\n");
    public const string DESCRIPTION_DOCS_LABEL = _("A list of recent documents.\n");
    public const string DESCRIPTION_DOM_LABEL = _("The DOM storage is designed to store persistent data similar to cookies but with greatly enhanced capacity.\n");
    public const string DESCRIPTION_DOWNLOAD_LABEL = _("Contains a list of files downloaded\n");
    public const string DESCRIPTION_HISTORY_NET_LABEL = _("List of visited web pages\n");
    public const string DESCRIPTION_HISTORY_PROG_LABEL = _("History of modifications\n");
    public const string DESCRIPTION_LOGS_LABEL = _("File that records either events that occur in an operating system or other software runs\n");
    public const string DESCRIPTION_PASS_LABEL = _("A database of usernames and passwords as well as a list of sites that should not store passwords.\n");
    public const string DESCRIPTION_PLACES_LABEL = _("A database of URLs including bookmarks, favicons, and a history of visited web sites.\n");
    public const string DESCRIPTION_PREFS_LABEL = _("Settings for individual sites\n");
    public const string DESCRIPTION_SAVED_FORMHISTORY_LABEL = _("A history of forms entered in web sites and in the Search bar\n");
    public const string DESCRIPTION_SESSION_LABEL = _("Delete the current session\n");
    public const string DESCRIPTION_TMP_LABEL = _("File generated in order to contain information transiently.\n");
    public const string DESCRIPTION_USED_LABEL = _("List of files most recent used.\n");
    // Special
    public const string DESCRIPTION_CACHE_PKG_LABEL = _("List of temporary update and package files.\n");
    public const string DESCRIPTION_CONF_PKG_LABEL = _("List of packages that have been deleted, but whose configuration files still remain.\n");
    public const string DESCRIPTION_OLDKERNELS_LABEL = _("Purge old kernels. Please, be careful.\n");
    public const string DESCRIPTION_TERMINAL_LABEL = _("Clean the Bash history.\n");
    public const string DESCRIPTION_THUMBNAILS_LABEL = _("Clean the generated cache by the images.\n");
    public const string DESCRIPTION_TRASH_LABEL = _("Files housed in the Trash bin.\n");
    public const string DESCRIPTION_UNKNOWN_LABEL = _("Unknown information.\n");
    
    public const string DESCRIPTION_WARNING_LOW_LABEL = _("<b>Warning level: </b> Low");
    public const string DESCRIPTION_WARNING_HIGH_LABEL = _("<b>Warning level: </b> High");

    public const string DESCRIPTION_SCAN_BUTTON = _("This option will scan <b>all selected options.</b>");
    public const string DESCRIPTION_CLEAN_BUTTON = _("This option will remove the files from <b>all the selected options.</b>");
    public const string DESCRIPTION_AUTOSTART = _("Start %s with the System.");
    public const string DESCRIPTION_STANDARD_SIZE = _("Use IEC sizes(1KiB = 1024 bytes) instead of SI(1kB = 1000 bytes)");
    public const string DESCRIPTION_COMPLETE_CLEANING = _("<b>Complete cleaning</b>\n%s (%s files) were removed. (Aproximate size)");
    public const string DESCRIPTION_COMPLETE_CLEANING_DETAIL = _("<b>Details of files deleted</b>");
    public const string DESCRIPTION_COMPLETE_ANALYSIS = _("<b>Complete analysis</b>\n%s (%s files) will be removed. (Aproximate size)");
    public const string DESCRIPTION_COMPLETE_ANALYSIS_DETAIL = _("<b>Details of files to be deleted (Note: No file have been deleted yet)</b>");
    public const string DESCRIPTION_CLEAN_DONE = _("<b>Congratulations! The System is clean!</b>");

    public const string DESCRIPTION_BACKUP_ID = "backup";
    public const string DESCRIPTION_CACHE_NET_ID = "internet-cache";
    public const string DESCRIPTION_CACHE_PROG_ID = "cache";
    public const string DESCRIPTION_CHAT_LOGS_ID = "chat-logs";
    public const string DESCRIPTION_COOKIES_ID = "cookies";
    public const string DESCRIPTION_CRASH_ID = "crash";
    public const string DESCRIPTION_DOCS_ID = "docs";
    public const string DESCRIPTION_DOM_ID = "dom";
    public const string DESCRIPTION_DOWNLOAD_ID = "download";
    public const string DESCRIPTION_DOWNLOAD_PODCASTS_ID = "download-podcasts";
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

    public const string TYPE_APP_AUDIO_PLAYER_LABEL = _("Audio player");
    public const string TYPE_APP_BROWSER_LABEL = _("Web browser");
    public const string TYPE_APP_BROWSER_CHAT_LABEL = _("Web browser and chat client");
    public const string TYPE_APP_CHAT_CLIENT_LABEL = _("Chat client");
    public const string TYPE_APP_DESKTOP_LABEL = _("Desktop environment");
    public const string TYPE_APP_EMAIL_CLIENT_LABEL = _("Email client");
    public const string TYPE_APP_FEED_READER_LABEL = _("Feeds reader");
    public const string TYPE_APP_FILE_TRANSFER_LABEL = _("File transfer client");
    public const string TYPE_APP_GAME_LABEL = _("Game");
    public const string TYPE_APP_GRAPHIC_EDITOR_LABEL = _("Graphics editor");
    public const string TYPE_APP_LAYER_SOFTWARE_LABEL = _("Compatibility layer for Windows software");
    public const string TYPE_APP_MULTIMEDIA_VIEWER_LABEL = _("Multimedia viewer");
    public const string TYPE_APP_OFFICE_SUITE_LABEL = _("Office suite");
    public const string TYPE_APP_PACKAGE_MANAGER_LABEL = _("Package manager");
    public const string TYPE_APP_PODCAST_MANAGER_LABEL = _("Podcast manager");
    public const string TYPE_APP_RENDERING_MAP_LABEL = _("3D map rendering program");
    public const string TYPE_APP_SYSTEM_LABEL = _("The system in general");
    public const string TYPE_APP_VIRTUAL_MACHINE_LABEL = _("Residual files from Java");
    public const string TYPE_APP_UNKNOWN_LABEL = _("Unknown type of application");

    public const string TYPE_APP_AUDIO_PLAYER_ID = "audio-player";
    public const string TYPE_APP_BROWSER_ID = "web-browser";
    public const string TYPE_APP_BROWSER_CHAT_ID = "web-browser-chat";
    public const string TYPE_APP_CHAT_CLIENT_ID = "chat-client";
    public const string TYPE_APP_DESKTOP_ID = "desktop-environment";
    public const string TYPE_APP_EMAIL_CLIENT_ID = "email-client";
    public const string TYPE_APP_FEED_READER_ID = "feed-reader";
    public const string TYPE_APP_FILE_TRANSFER_ID = "file-transfer-client";
    public const string TYPE_APP_GAME_ID = "game";
    public const string TYPE_APP_GRAPHIC_EDITOR_ID = "graphic-editor";
    public const string TYPE_APP_LAYER_SOFTWARE_ID = "layer-software";
    public const string TYPE_APP_MULTIMEDIA_VIEWER_ID = "multimedia-viewer";
    public const string TYPE_APP_OFFICE_SUITE_ID = "office-suite";
    public const string TYPE_APP_PACKAGE_MANAGER_ID = "package-manager";
    public const string TYPE_APP_PODCAST_MANAGER_ID = "podcast-manager";
    public const string TYPE_APP_RENDERING_MAP_ID = "rendering-map";
    public const string TYPE_APP_SYSTEM_ID = "system";
    public const string TYPE_APP_VIRTUAL_MACHINE_ID = "virtual-java";

    public const string QUESTION_PHRASE_CLEAN = _("Are you sure you want to continue?");
    public const string QUESTION_PHRASE_CACHE_PKG = _("Are you sure you want to delete cache and obsolete Package System files?");
    public const string QUESTION_PHRASE_CONF_PKG = _("Are you sure you want to delete orphan Package System files?");
    public const string QUESTION_PHRASE_OLDKERNELS = _("Are you sure you want to delete the old kernels?");
    public const string QUESTION_PHRASE_PASS = _("Are you sure you want to remove %s passwords?");
    public const string QUESTION_PHRASE_UNKNOWN = DESCRIPTION_UNKNOWN_LABEL;

    public const string CATEGORY_APPLICATIONS = "applications";
    public const string CATEGORY_SYSTEM = "system";
    public const string CATEGORY_APPLICATIONS_LABEL = _("Applications");
    public const string CATEGORY_SYSTEM_LABEL = _("System");
    public const string[] CATEGORIES = {CATEGORY_APPLICATIONS, 
                                        CATEGORY_SYSTEM};
    public const string[] ADVANCED_OPTIONS = {DESCRIPTION_CACHE_PKG_ID, 
                                              DESCRIPTION_CONF_PKG_ID, 
                                              DESCRIPTION_OLDKERNELS_ID};
    public const string[] SYSTEM_APPS = {"apt", "system"};
    public const string TYPE_ICON_APPS = "apps";
    public const string TYPE_ICON_SYSTEM = "info-system";

    public unowned string get_type_app (string id_app_type) {
        switch (id_app_type) {
            case TYPE_APP_AUDIO_PLAYER_ID:
                return TYPE_APP_AUDIO_PLAYER_LABEL;
            case TYPE_APP_BROWSER_ID:
                return TYPE_APP_BROWSER_LABEL;
            case TYPE_APP_BROWSER_CHAT_ID:
                return TYPE_APP_BROWSER_CHAT_LABEL;
            case TYPE_APP_CHAT_CLIENT_ID:
                return TYPE_APP_CHAT_CLIENT_LABEL;
            case TYPE_APP_DESKTOP_ID:
                return TYPE_APP_DESKTOP_LABEL;
            case TYPE_APP_EMAIL_CLIENT_ID:
                return TYPE_APP_EMAIL_CLIENT_LABEL;
            case TYPE_APP_FEED_READER_ID:
                return TYPE_APP_FEED_READER_LABEL;
            case TYPE_APP_FILE_TRANSFER_ID:
                return TYPE_APP_FILE_TRANSFER_LABEL;
            case TYPE_APP_GAME_ID:
                return TYPE_APP_GAME_LABEL;
            case TYPE_APP_GRAPHIC_EDITOR_ID:
                return TYPE_APP_GRAPHIC_EDITOR_LABEL;
            case TYPE_APP_LAYER_SOFTWARE_ID:
                return TYPE_APP_LAYER_SOFTWARE_LABEL;
            case TYPE_APP_MULTIMEDIA_VIEWER_ID:
                return TYPE_APP_MULTIMEDIA_VIEWER_LABEL;
            case TYPE_APP_OFFICE_SUITE_ID:
                return TYPE_APP_OFFICE_SUITE_LABEL;
            case TYPE_APP_PACKAGE_MANAGER_ID:
                return TYPE_APP_PACKAGE_MANAGER_LABEL;
            case TYPE_APP_PODCAST_MANAGER_ID:
                return TYPE_APP_PODCAST_MANAGER_LABEL;
            case TYPE_APP_RENDERING_MAP_ID:
                return TYPE_APP_RENDERING_MAP_LABEL;
            case TYPE_APP_VIRTUAL_MACHINE_ID:
                return TYPE_APP_VIRTUAL_MACHINE_LABEL;
            case TYPE_APP_SYSTEM_ID:
                return TYPE_APP_SYSTEM_LABEL;
            default:
                return TYPE_APP_UNKNOWN_LABEL;
        }
    }

    public unowned string get_option_label (string id_option_type) {
        switch (id_option_type) {
            case DESCRIPTION_BACKUP_ID:
                return BACKUP_LABEL;
            case DESCRIPTION_CACHE_NET_ID:
                return CACHE_NET_LABEL;
            case DESCRIPTION_CACHE_PROG_ID:
                return CACHE_PROG_LABEL;
            case DESCRIPTION_CHAT_LOGS_ID:
                return CHAT_LOGS_LABEL;
            case DESCRIPTION_COOKIES_ID:
                return COOKIES_LABEL;
            case DESCRIPTION_CRASH_ID:
                return CRASH_LABEL;
            case DESCRIPTION_DOCS_ID:
            case DESCRIPTION_RECENT_DOCS_ID:
                return DOCS_LABEL;
            case DESCRIPTION_DOM_ID:
                return DOM_LABEL;
            case DESCRIPTION_DOWNLOAD_PODCASTS_ID:
            case DESCRIPTION_DOWNLOAD_ID:
                return DOWNLOAD_LABEL;
            case DESCRIPTION_HISTORY_NET_ID:
                return HISTORY_NET_LABEL;
            case DESCRIPTION_HISTORY_PROG_ID:
                return HISTORY_PROG_LABEL;
            case DESCRIPTION_LOGS_ID:
                return LOGS_LABEL;
            case DESCRIPTION_PASS_ID:
                return PASS_LABEL;
            case DESCRIPTION_PLACES_ID:
                return PLACES_LABEL;
            case DESCRIPTION_PREFS_ID:
                return PREFS_LABEL;
            case DESCRIPTION_SAVED_FORMHISTORY_ID:
                return SAVED_FORMHISTORY_LABEL;
            case DESCRIPTION_SESSION_ID:
                return SESSION_LABEL;
            case DESCRIPTION_TMP_ID:
                return TMP_LABEL;
            case DESCRIPTION_USED_ID:
                return USED_LABEL;
            case DESCRIPTION_CACHE_PKG_ID:
                return CACHE_PKG_LABEL;
            case DESCRIPTION_CONF_PKG_ID:
                return CONF_PKG_LABEL;
            case DESCRIPTION_OLDKERNELS_ID:
                return OLDKERNELS_LABEL;
            case DESCRIPTION_TERMINAL_ID:
                return TERMINAL_LABEL;
            case DESCRIPTION_THUMBNAILS_ID:
                return THUMBNAILS_LABEL;
            case DESCRIPTION_TRASH_ID:
                return TRASH_LABEL;
            default:
                return UNKNOWN_LABEL;
        }
    }

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
            case DESCRIPTION_RECENT_DOCS_ID:
                return DESCRIPTION_DOCS_LABEL;
            case DESCRIPTION_DOM_ID:
                return DESCRIPTION_DOM_LABEL;
            case DESCRIPTION_DOWNLOAD_PODCASTS_ID:
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

    public const string STYLE_CLASS_ABOUT_BTN = "about_btn";
    public const string STYLE_CLASS_CSD = "csd";
    public const string STYLE_CLASS_TOOLBAR = "Toolbar";
    public const string STYLE_CLASS_SIDEBAR = "Sidebar";
    public const string STYLE_CLASS_SIDEBAR_EV = "SidebarEv";
    public const string STYLE_CLASS_SUGGESTED_ACTION = "suggested-action";
    public const string STYLE_CLASS_DESTRUCTIVE_ACTION = "destructive-action";

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
