/* dial.vala
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
 * Base for outbound with Dial fields.
 * DASH and TYPE FIX REQUIRED
 */
class SingNeko.Outbound.Dial : Outbound {
    public string detour { get; set; default = null; }
    public string bind_interface { get; set; default = null; }
    public string inet4_bind_address { get; set; default = null; }
    public string inet6_bind_address { get; set; default = null; }
    public int64 routing_mark { get; set; default = 0; }
    public bool reuse_addr { get; set; default = false; }
    public string netns { get; set; default = null; }
    public string connect_timeout { get; set; default = null; }
    public bool tcp_fast_open { get; set; default = false; }
    public bool tcp_multi_path { get; set; default = false; }
    public bool udp_fragment { get; set; default = false; }

    public string[] domain_resolver { get; set; default = new string[0]; }
    public string network_strategy { get; set; default = null; }
    public string[] network_type { get; set; default = new string[0]; }
    public string[] fallback_network_type { get; set; default = new string[0]; }
    public string fallback_delay { get; set; default = null; }
}
