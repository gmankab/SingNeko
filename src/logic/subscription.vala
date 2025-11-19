/* subscription.vala
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

namespace SingNeko.Subscription {
    public void load () {
        SingBox.instance.outbound_store.remove_all ();
        var lines = get_content ().split ("\n", -1);
        // Base64 encoded
        var old_active = Settings.get ().get_string (Settings.KEY_ACTIVE_OUTBOUND);
        old_active = (string) Base64.decode (old_active);
        uint16 i = 0, active = 0;
        foreach (var line in lines) {
            if (line[0] == '#' && line != "")
                continue;
            try {
                SingBox.instance.outbound_store.append (Outbound.Outbound.parse_uri (line));
                i += 1;
                if (line == old_active)
                    active = i;
            } catch (Error err) {
                warning ("Error during subscription parse: %s", err.message);
            }
        }
        if (active != 0)
            SingBox.instance.outbound_selection.set_selected (active - 1);
        else
            warning ("Failed to find old active");
    }

    public async void init () {
        if (!Settings.get ().get_boolean (Settings.KEY_SUBSCRIPTION_PULL_ON_STARTUP)) {
            load ();
            return;
        }
        var new_content = yield download_subscription (Settings.get ().get_string (Settings.KEY_SUBSCRIPTION_URL),
            Settings.get ().get_boolean (Settings.KEY_SUBSCRIPTION_IS_BASE64));

        message ("Subscription pulled");
        replace_content (new_content);
        load ();
    }

    public string get_content () {
        uint8[] content = null;
        try {
            var sub_path = Environment.get_variable ("SUB_FILE");
            File file = null;
            if (sub_path != null) {
                file = File.new_for_path (sub_path);
            } else {
                Utils.create_config_dir ();
                file = File.new_build_filename (Environment.get_user_config_dir (), "SingNeko", "subscription");
            }
            file.load_contents (null, out content, null);
        } catch (Error err) {
            warning ("Failed to load subscription from file %s", err.message);
        }
        return (string) content;
    }

    public void replace_content (string content) {
        try {
            var sub_path = Environment.get_variable ("SUB_FILE");
            File file = null;
            if (sub_path != null) {
                file = File.new_for_path (sub_path);
            } else {
                Utils.create_config_dir ();
                file = File.new_build_filename (Environment.get_user_config_dir (), "SingNeko", "subscription");
            }
            file.replace_contents (content.data, null, false, FileCreateFlags.NONE, null);
        } catch (Error err) {
            warning ("Failed replace subscription content %s", err.message);
        }
    }

    public async string download_subscription (string url, bool is_base64) {
        var session = new Soup.Session ();
        var message = new Soup.Message ("GET", url);
        try {
            var response = (string) (yield session.send_and_read_async (message, 0, null)).get_data ();
            if (message.get_status () != Soup.Status.OK)
                warning ("Subscription download returned code %u", message.status_code);
            if (is_base64)
                response = (string) Base64.decode (response);
            return response;
        } catch (Error err) {
            warning ("Subscription download error: %s", err.message);
        }
        return "";
    }
}
