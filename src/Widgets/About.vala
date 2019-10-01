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

using Gtk;
using GLib;

namespace GCleaner.Widgets {
    public class About : Gtk.AboutDialog {
        public About () {
            /*
             * PROPERTIES
             */
            //this.authors   = Resources.AUTHORS;
            //this.artists   = Resources.ARTISTS;
            //this.documenters = Resources.DOCUMENTERS;
            //this.translator_credits = "Juan Pablo Lozano <lozanotux@gmail.com>";
            
            this.license  = Resources.SHORT_VERSION_LICENSE;
            this.wrap_license = true;
            string path_icon = Path.build_path (Path.DIR_SEPARATOR_S, Resources.DATADIR, "icons", "hicolor", "128x128", "apps", "gcleaner.svg");
            try {
                var logo = load_pixbuf (path_icon, 128);
                this.logo = logo;
            } catch (GLib.Error e) {
                stderr.printf (">>> Logo image is not available.\nCheck path: " + path_icon + "\n");
            }
            
            this.program_name = Resources.PROGRAM_NAME;
            this.version = Resources.VERSION;
            this.comments = Resources.ABOUT_COMMENTS;
            this.copyright = "Copyright © 2015-" + new DateTime.now_local ().get_year ().to_string () + " " +
                Resources.AUTHORS[0].split ("<")[0].strip ();
            this.website = "https://gcleaner.github.io/";
            
            this.response.connect((response) => {
                this.destroy ();
            });
            
            /*
             * Application icon
             */
            try {
                this.icon = load_pixbuf (path_icon);
            } catch (Error e) {
                stderr.printf ("Error loading icon: [%s]\n", e.message);
            }
        }
    }
}
