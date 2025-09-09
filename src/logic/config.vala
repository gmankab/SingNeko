/* config.vala
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

class SingNeko.SingConfig : Object, Json.Serializable {
    public List<Outbound.Outbound> outbounds { get; owned set; default = new List<Outbound.Outbound> (); }
    public override Json.Node serialize_property (string property_name, GLib.Value value, GLib.ParamSpec pspec) {
        if (property_name == "outbounds") {
            var node = Utils.serialize_object_list<Outbound.Outbound> (outbounds);
            var arr = node.get_array ();
            arr.foreach_element ((_, __, node) => {
                var _node = node;
                Utils.fix_type (ref _node);
                Utils.fix_dash (ref _node);
            });
            return node;
        }
        return default_serialize_property (property_name, value, pspec);;
    }
}
