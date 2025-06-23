/* shadowsocks.vala
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
 * ShadowSocks outbound.
 * DASH and TYPE FIX REQUIRED
 */
class Singularity.Outbound.ShadowSocks : Dial, Json.Serializable {
    public string server { get; set; default = null; }
    public int64 server_port { get; set; default = 1080; }
    public string method { get; set; default = null; }
    public string password { get; set; default = null; }
    public string plugin { get; set; default = null; }
    public string plugin_opts { get; set; default = null; }
    public string network { get; set; default = null; }
    public bool udp_over_tcp { get; set; default = false; }

    /*
     * public Multiplex multiplex { get; set; default = null; }
     * TODO: Implement Multiplex
     */

    construct {
        type_name = "shadowsocks";
    }

    public override string pretty_schema() {
        return "SSocks";
    }
}
