/* window.vala
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

[GtkTemplate (ui = "/io/gitlab/nekocwd/singularity/gtk/window.ui")]
public class Singularity.Window : Adw.ApplicationWindow {
    [GtkChild]
    private unowned Gtk.ListView outbounds;

    public Window (Gtk.Application app) {
        Object (application: app);
        var factory = new Gtk.SignalListItemFactory ();
        factory.setup.connect ((obj) => {
            var item = (Gtk.ListItem) obj;
            item.set_child (new Ui.OutboundRow ());
        });
        factory.bind.connect ((obj) => {
            var item = (Gtk.ListItem) obj;
            var row = (Ui.OutboundRow) item.child;
            var data = (Outbound.Outbound) item.item;
            row.set_outbound (data);
        });
        outbounds.set_model (SingBox.instance.outbound_selection);
        outbounds.set_factory (factory);
    }
}
