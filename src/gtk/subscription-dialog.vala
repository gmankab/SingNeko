/* subscription-dialog.vala
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

[GtkTemplate (ui = "/link/nekocwd/singneko/gtk/subscription-dialog.ui")]
public class SingNeko.SubscriptionDialg : Adw.PreferencesDialog {
    public string text { get; set; default = ""; }
    public string url { get; set; default = ""; }
    public bool base64_encoded { get; set; default = false; }
    public bool startup_pull { get; set; default = false; }
    public string content_policy { get; set; default = "delete"; }

    construct {
        reload ();

        Settings.get ().bind (Settings.KEY_SUBSCRIPTION_URL, this,
                              "url", SettingsBindFlags.DEFAULT);
        Settings.get ().bind (Settings.KEY_SUBSCRIPTION_IS_BASE64, this,
                              "base64-encoded", SettingsBindFlags.DEFAULT);
        Settings.get ().bind (Settings.KEY_SUBSCRIPTION_PULL_ON_STARTUP, this,
                              "startup-pull", SettingsBindFlags.DEFAULT);
    }

    [GtkCallback ()]
    [CCode (instance_pos = -1)]
    private void reload () {
        text = Subscription.get_content ();
    }

    [GtkCallback ()]
    [CCode (instance_pos = -1)]
    private void save () {
        Subscription.replace_content (text);
        Subscription.load ();
    }

    [GtkCallback (name = "pull")]
    [CCode (instance_pos = -1)]
    private void start_pool () {
        // TODO: Add loading spinner/progress
        pull.begin ();
    }

    private async void pull () {
        var new_subscription = yield Subscription.download_subscription (url, base64_encoded);

        if (content_policy == "delete") {
            text = new_subscription;
        } else {
            text += "\n" + new_subscription;
        }
    }

    [GtkCallback ()]
    [CCode (instance_pos = -1)]
    private void copy () {
        get_clipboard ().set_text (text);
    }

    [GtkCallback ()]
    [CCode (instance_pos = -1)]
    private void paste () {
        get_clipboard ().read_text_async.begin (null, (__, res) => {
            var new_text = "";
            try {
                new_text = get_clipboard ().read_text_async.end (res);
            } catch (Error err) {
                warning ("Failed to get clipboard text: %s", err.message);
                return;
            }
            var dialog = new Adw.AlertDialog (_("Old content"), _("How to handle old content?"));
            dialog.add_response ("delete", _("Delete"));
            dialog.set_response_appearance ("delete", Adw.ResponseAppearance.DESTRUCTIVE);
            dialog.add_response ("keep", _("Keep"));
            dialog.set_response_appearance ("keep", Adw.ResponseAppearance.SUGGESTED);
            dialog.present (null);
            dialog.response.connect ((resp) => {
                if (resp == "delete")
                    text = new_text;
                else
                    text += "\n" + new_text;
            });
        });
    }
}
