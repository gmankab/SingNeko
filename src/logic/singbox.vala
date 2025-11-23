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

class SingNeko.SingBox : Object {
    public bool singbox_status { get; set; }
    public signal void singbox_message (string message);

    public ListStore outbound_store = new ListStore (typeof (Outbound.Outbound));
    public Gtk.SingleSelection outbound_selection = null;
    public Subprocess? singbox = null;
    bool can_use_singbox = true;

    construct {
        outbound_selection = new Gtk.SingleSelection (outbound_store);
        outbound_selection.notify["selected"].connect (() => set_up.begin ());
        singbox_message.connect ((msg) => message ("%s", msg));
    }
    private void setup_config_dir () {
        var conf_dir = File.new_build_filename (Environment.get_user_config_dir (), "SingNeko");
        try {
            conf_dir.make_directory ();
        } catch (IOError.EXISTS err) {
            // Skip this err
        } catch (Error err) {
            warning ("Error during creating config dir: %s", err.message);
        }
    }

    private string get_base_config () {
        var base_config = File.new_build_filename (Environment.get_user_config_dir (), "SingNeko", "BaseConfig.json");
        if (!base_config.query_exists ()) {
            try {
                message ("Saving base config");
                base_config.replace_contents (resources_lookup_data ("/link/nekocwd/singneko/base.json", ResourceLookupFlags.NONE).get_data (), null, false, FileCreateFlags.NONE, null);
            } catch (Error err) {
                warning ("Error during saving base config: %s", err.message);
            }
        }
        return base_config.get_path ();
    }

    private string get_outbound_config () {
        Utils.create_config_dir ();
        var outbound_config = File.new_build_filename (Environment.get_user_config_dir (), "SingNeko", "Outbound.json");
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
        return outbound_config.get_path ();
    }

    private async void wait_for_singbox () {
        while (!can_use_singbox) {
            SourceFunc callback = wait_for_singbox.callback;
            Idle.add ((owned) callback);
            yield;
        }
    }

    public async void set_up () {
        if (singbox != null) {
            singbox.force_exit ();
            yield wait_for_singbox ();
        }
        if (outbound_selection.selected_item == null) {
            singbox_message ("[SingNeko] No outbound available");
            return;
        }
        singbox_message ("[SingNeko] Starting outbound: %s".printf (((Outbound.Outbound) outbound_selection.selected_item).name));
        setup_config_dir ();
        var base_cfg = get_base_config ();
        var outbound_cfg = get_outbound_config ();

        try {
            singbox = new Subprocess.newv ({ "sing-box", "--disable-color", "-c", base_cfg, "-c", outbound_cfg, "run" }, SubprocessFlags.STDERR_PIPE);
        } catch (Error err) {
            singbox_message ("[SingNeko] Failed to launch singbox: %s".printf (err.message));
        }
        meow_with_stream.begin (new DataInputStream (singbox.get_stderr_pipe ()));
        Settings.get ().set_string (Settings.KEY_ACTIVE_OUTBOUND,
                                    ((Outbound.Outbound) outbound_selection.selected_item).hash);
    }

    async void meow_with_stream (DataInputStream input) {
        singbox_status = true;
        can_use_singbox = false;
        string line = "";
        do {
            try {
                line = yield input.read_line_async ();
            } catch (Error err) {
                warning ("Error during read_line: %s", err.message);
            }
            if (line != null)
                singbox_message (line);
        } while (line != null);
        singbox_message ("[SingNeko]: Singbox log closed");
        try {
            yield singbox.wait_async ();

            singbox_status = false;
        } catch (Error err) {
            warning ("Failed to wait for singbox %s", err.message);
        }
        singbox_message ("[SingNeko]: Singbox exited with code %d\n".printf (singbox.get_status ()));
        can_use_singbox = true;
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
