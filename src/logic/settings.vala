/* settings.vala
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

namespace SingNeko.Settings {
    public const string KEY_SUBSCRIPTION_URL = "subscription-url";
    public const string KEY_SUBSCRIPTION_IS_BASE64 = "subscription-is-base64";
    public const string KEY_ACTIVE_OUTBOUND = "active-outbound";
    public const string KEY_SUBSCRIPTION_PULL_ON_STARTUP = "subscription-pull-on-startup";

    public GLib.Settings get() {
        return new GLib.Settings.with_path("io.gitlab.nekocwd.singneko", "/io/gitlab/nekocwd/singularity/");
    }
}
