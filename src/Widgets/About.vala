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
            
            try {
                var logo = load_pixbuf (Resources.DATADIR + "/icons/hicolor/128x128/apps/gcleaner.svg", 128);
                this.logo = logo;
            } catch (GLib.Error e) {
                stderr.printf ("COM.GCLEANER.APP.ABOUT: [GLIB::ERROR CREATING Pixbuf ICON]\n");
                stderr.printf (">>> Check path: /usr/share/icons/hicolor/128x128/apps/gcleaner.svg\n");
            }
            
            this.program_name = Resources.PROGRAM_NAME;
            this.version = Resources.VERSION;
            this.comments = "Clean your System GNU/Linux";
            this.copyright = "Copyright © 2015-" + new DateTime.now_local ().get_year ().to_string () + " Juan Pablo Lozano";
            this.website = "https://gcleaner.github.io/";
            
            this.response.connect((response) => {
                this.destroy ();
            });
            
            /*
             * Application icon
             */
            try {
                this.icon = load_pixbuf (Resources.DATADIR + "/icons/hicolor/128x128/apps/gcleaner.svg");
            } catch (Error e) {
                stderr.printf ("COM.GCLEANER.APP: [GLIB::ERROR LOADING ICON [%s]]\n", e.message);
            }
        }
    }
}
