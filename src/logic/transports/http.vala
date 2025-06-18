/* http.vala
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
 * HTTP transport.
 * DASH and TYPE FIX REQUIRED
 */
class Singularity.Transport.Http : Transport, Json.Serializable {
    public string[] host { get; set; default = new string[0]; }
    public string path { get; set; default = ""; }
    public string method { get; set; default = ""; }
    public Gee.HashMap<string, string> headers { get; set; default = new Gee.HashMap<string, string> (); }
    public string idle_timeout { get; set; default = "15s"; }
    public string ping_timeout { get; set; default = "15s"; }

    construct {
        type_name = "http";
    }

    public override Json.Node serialize_property (string property_name, GLib.Value value, GLib.ParamSpec pspec) {
        if (property_name == "headers")
            return Utils.serialize_string_map (headers);
        return default_serialize_property (property_name, value, pspec);
    }
}
