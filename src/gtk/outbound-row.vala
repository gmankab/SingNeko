/* outbound-row.vala
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

[GtkTemplate(ui = "/link/nekocwd/singneko/gtk/outbound-row.ui")]
class SingNeko.Ui.OutboundRow : Gtk.Box {
    [GtkChild]
    private unowned Gtk.Label schema;
    [GtkChild]
    private unowned Gtk.Label descr;
    construct {
    }
    public void set_outbound(Outbound.Outbound outbound) {
        schema.label = outbound.pretty_schema();
        descr.label = outbound.name;
    }

    public void add_to_sizegroup(Gtk.SizeGroup group) {
        group.add_widget(schema);
    }
}
