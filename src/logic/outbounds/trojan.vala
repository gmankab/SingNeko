/* trojan.vala
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
 * Trojan outbound.
 * DASH and TYPE FIX REQUIRED
 */
class Singularity.Outbound.Trojan : Dial, Json.Serializable {
    public string server { get; set; default = null; }
    public int64 server_port { get; set; default = 1080; }
    public string password { get; set; default = null; }
    public string network { get; set; default = null; }
    public Transport.Transport transport { get; set; default = null; }

    /*
     * public TLS tls { get; set; default = null; }
     * TODO: Implement TLS
     */
    /*
     * public Multiplex multiplex { get; set; default = null; }
     * TODO: Implement Multiplex
     */

    construct {
        type_name = "trojan";
    }

    public override Json.Node serialize_property (string property_name, GLib.Value value, GLib.ParamSpec pspec) {
        var node = default_serialize_property (property_name, value, pspec);
        if (property_name == "transport" && transport != null) {
            Utils.fix_type (ref node);
            Utils.fix_dash (ref node);
        }
        return node;
    }
}
