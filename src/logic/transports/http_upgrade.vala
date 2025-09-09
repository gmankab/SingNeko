/* http_upgrade.vala
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

/*
 * HTTPUpgrade transport.
 * TYPE FIX REQUIRED
 */
class SingNeko.Transport.HttpUpgrade : Transport, Json.Serializable {
    public string host { get; set; default = null; }
    public string path { get; set; default = null; }
    public Gee.HashMap<string, string> headers { get; set; default = new Gee.HashMap<string, string> (); }

    construct {
        type_name = "httpupgrade";
    }

    public override Json.Node serialize_property (string property_name, GLib.Value value, GLib.ParamSpec pspec) {
        if (property_name == "headers")
            return Utils.serialize_string_map (headers);
        return default_serialize_property (property_name, value, pspec);
    }
}
