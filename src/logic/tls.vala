/* tls.vala
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
class SingNeko.TLS : Object, Json.Serializable {
    public class Reality : Object, Json.Serializable {
        public bool enabled { get; set; default = false; }
        public string public_key { get; set; default = null; }
        public string short_id { get; set; default = null; }
    }

    public class UTLS : Object, Json.Serializable {
        public bool enabled { get; set; }
        public string fingerprint { get; set; default = ""; }
    }
    public bool enabled { get; construct set; }
    public bool insecure { get; construct set; }
    public string server_name { get; set; default = null; }
    public Reality reality { get; set; default = null; }
    public UTLS utls { get; set; default = null; }

    public override Json.Node serialize_property (string property_name, GLib.Value value, GLib.ParamSpec pspec) {
        var node = default_serialize_property (property_name, value, pspec);
        if (property_name == "reality" && reality != null) {
            Utils.fix_dash (ref node);
        }
        return node;
    }
}
