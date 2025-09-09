/* main.vala
 *
 * Copyright 2025 Vasiliy Doylov (NekoCWD) <nekocwd@mainlining.org>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace SingNeko {
    int main (string[] args) {
        Intl.bindtextdomain (Config.GETTEXT_PACKAGE, Config.LOCALEDIR);
        Intl.bind_textdomain_codeset (Config.GETTEXT_PACKAGE, "UTF-8");
        Intl.textdomain (Config.GETTEXT_PACKAGE);
        uint8[] content = null;
        try {
            var sub_path = Environment.get_variable ("SUB_FILE");
            File file = null;
            if (sub_path != null) {
                file = File.new_for_path (sub_path);
            } else {
                file = File.new_build_filename (Environment.get_user_config_dir (), "SingNeko", "subscription");
            }
            file.load_contents (null, out content, null);
        } catch (Error err) {
            error ("Failed to parse subscription %s", err.message);
        }
        var lines = ((string) content).split ("\n", -1);
        foreach (var line in lines) {
            if (line[0] == '#' && line != "")
                continue;
            try {
                SingBox.instance.outbound_store.append (Outbound.Outbound.parse_uri (line));
            } catch (Error err) {
                warning ("Error during subscription parse: %s", err.message);
            }
        }
        var app = new SingNeko.Application ();
        return app.run (args);
    }
}