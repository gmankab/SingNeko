/* singbox.vala
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

class Singularity.SingBox : Object {
    public ListStore outbound_store = new ListStore (typeof (Outbound.Outbound));
    public Gtk.SingleSelection outbound_selection = null;
    public Subprocess? singbox = null;


    construct {
        outbound_selection = new Gtk.SingleSelection (outbound_store);
        outbound_selection.notify["selected"].connect (() => {
            message ("Selected %s", ((Outbound.Outbound) outbound_selection.selected_item).name);
            set_up ();
        });
    }

    private void set_up () {
        if (singbox != null) {
            message ("killing singbox");
            singbox.force_exit ();
        }
        var conf_dir = File.new_build_filename (Environment.get_user_config_dir (), "Singularity");
        try {
            conf_dir.make_directory ();
        } catch (IOError.EXISTS err) {
            // Skip this err
        } catch (Error err) {
            warning ("Error during creating config dir: %s", err.message);
        }
        var base_config = conf_dir.get_child ("BaseConfig.json");
        if (!base_config.query_exists ()) {
            try {
                message ("Saving base config");
                base_config.replace_contents (resources_lookup_data ("/io/gitlab/nekocwd/singularity/base.json", ResourceLookupFlags.NONE).get_data (), null, false, FileCreateFlags.NONE, null);
            } catch (Error err) {
                warning ("Error during saving base config: %s", err.message);
            }
        }
        var outbound_config = conf_dir.get_child ("Outbound.json");
        try {
            message ("Saving outbound config");
            var generator = new Json.Generator ();
            var config = new SingConfig ();
            config.outbounds.append ((Outbound.Outbound) outbound_selection.selected_item);
            generator.root = Json.gobject_serialize (config);
            generator.set_pretty (true);
            outbound_config.replace_contents (generator.to_data (null).data, null, false, FileCreateFlags.NONE, null);
        } catch (Error err) {
            warning ("Error during saving outbound config: %s", err.message);
        }
        singbox = new Subprocess.newv ({ "sing-box", "--disable-color", "-c", base_config.get_path (), "-c", outbound_config.get_path (), "run" }, GLib.SubprocessFlags.STDERR_PIPE);
        meow_with_stream.begin (new DataInputStream (singbox.get_stderr_pipe ()));
    }

    async void meow_with_stream (DataInputStream input) {
        for (string line = ""; line != null; line = yield input.read_line_async ())
            message ("SingBox: %s", line);
        message ("SingBox stream closed");
    }

    private SingBox () {}
    private static SingBox _instance = null;
    public static SingBox instance {
        get {
            if (_instance == null)
                _instance = new SingBox ();
            return _instance;
        }
    }
}
