/* utils.vala
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
 * Collection of ugly workarounds and hacks
 */
namespace Singularity.Utils {
    /*
     * In vala we can't use `type` as field name, but we need to use it
     * to make out saves compatible with SingBox configuration.
     */
    public void fix_type(ref Json.Node node) {
        const string TYPE_NAME_SRC = "type-name";
        const string TYPE_NAME_DST = "type";

        var obj = node.get_object();
        if (obj.has_member(TYPE_NAME_SRC)) {
            var type_name = obj.get_member(TYPE_NAME_SRC);
            obj.set_member(TYPE_NAME_DST, type_name);
            obj.remove_member(TYPE_NAME_SRC);
        } else if (obj.has_member(TYPE_NAME_DST)) {
            var type_name = obj.get_member(TYPE_NAME_DST);
            obj.set_member(TYPE_NAME_SRC, type_name);
            obj.remove_member(TYPE_NAME_DST);
        } else {
            warning("Object has no type to fix it");
        }
    }

    public Json.Node serialize_string_map(Gee.Map<string, string> map) {
        var builder = new Json.Builder();
        builder.begin_object();
        foreach (var kv in map) {
            builder.set_member_name(kv.key);
            builder.add_string_value(kv.value);
        }
        builder.end_object();
        return builder.get_root();
    }
}
