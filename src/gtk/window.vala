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

[GtkTemplate(ui = "/io/gitlab/nekocwd/singneko/gtk/window.ui")]
public class SingNeko.Window : Adw.ApplicationWindow {
    [GtkChild]
    private unowned Adw.BottomSheet sheet;
    [GtkChild]
    private unowned Gtk.ListView outbounds;
    [GtkChild]
    private unowned Gtk.TextBuffer singbox_log;
    [GtkChild]
    private unowned Gtk.Label singbox_status;

    private void on_singbox_status_change() {
        var status = SingBox.instance.singbox_status;
        singbox_status.label = "%s %s".printf(_("SingBox"), status ? _("running") : _("stopped"));
        if (status) {
            singbox_status.add_css_class("success");
            singbox_status.remove_css_class("error");
        } else {
            singbox_status.add_css_class("error");
            singbox_status.remove_css_class("success");
        }
    }

    private void setup_outbound_list() {
        var sg = new Gtk.SizeGroup(Gtk.SizeGroupMode.HORIZONTAL); // Keep schema labels same size
        var factory = new Gtk.SignalListItemFactory();
        factory.setup.connect((obj) => {
            var item = (Gtk.ListItem) obj;
            var row = new Ui.OutboundRow();
            row.add_to_sizegroup(sg);
            item.set_child(row);
        });
        factory.bind.connect((obj) => {
            var item = (Gtk.ListItem) obj;
            var row = (Ui.OutboundRow) item.child;
            var data = (Outbound.Outbound) item.item;
            row.set_outbound(data);
        });
        outbounds.set_model(SingBox.instance.outbound_selection);
        outbounds.set_factory(factory);
    }

    public Window(Gtk.Application app) {
        Object(application: app);

        SingBox.instance.notify["singbox-status"].connect(() => on_singbox_status_change());
        SingBox.instance.singbox_message.connect((message) => {
            Gtk.TextIter iter;
            var msg = "\n" + message;
            singbox_log.get_end_iter(out iter);
            singbox_log.insert_text(ref iter, msg, msg.length);
        });
        on_singbox_status_change();

        setup_outbound_list();
    }
}