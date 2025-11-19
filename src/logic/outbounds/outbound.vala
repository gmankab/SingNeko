/* outbound.vala
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

class SingNeko.Outbound.Outbound : Object, Json.Serializable {
    // We can't use name `type` in vala
    public string type_name { get; construct set; default = ""; }
    public string tag { get; set; default = "proxy"; }
    public string name; // Not a property
    public string hash; // Not a property

    public virtual string pretty_schema () {
        return "FIXME";
    }

    public static Outbound parse_uri (string profile) throws UriError, ParseError {
        Uri uri = null;
        uri = Uri.parse (profile, UriFlags.HAS_PASSWORD | UriFlags.NON_DNS | UriFlags.PARSE_RELAXED);

        var scheme = uri.get_scheme ();

        var host = uri.get_host ();
        var port = uri.get_port ();
        var user = uri.get_user ();
        var name = uri.get_fragment ();
        HashTable<string, string> params = null;

        if (uri.get_query () != null) {
            params = Uri.parse_params (uri.get_query ());
        } else {
            params = new HashTable<string, string> (null, null);
        }


        Outbound outbound = null;
        TLS tls = null;
        Transport.Transport transport = null;
        tls = new TLS (){
            enabled = true,
            insecure = true,
            server_name = params["sni"]
        };

        params["type"] = params["headerType"] ?? params["type"];
        switch (params["type"] ?? "none") {
        case "ws":
            var ws = new Transport.WebSocket () {
                path = params["path"],
            };
            ws.headers["Host"] = params["host"];
            transport = ws;
            break;
        case "grpc":
            transport = new Transport.GRPC () {
                service_name = params["serviceName"],
            };
            break;
        case "httpupgrade":
            transport = new Transport.HttpUpgrade () {
                path = params["path"],
                host = params["host"],
            };
            break;
        case "http":
            var t = new Transport.Http () {
                path = params["path"],
                method = "GET",
            };
            t.headers["Host"] = params["host"];
            transport = t;
            break;
        case "xhttp":
            throw new ParseError.NOT_IMPLEMENTED ("Transport %s not implemented yet", params["type"]);
        case "tcp":
        case "none":
        case "raw":
            break;
        default:
            warning ("Unknown transport type %s", params["type"]);
            break;
        }

        if (params["pbk"] != null) {
            tls.reality = new TLS.Reality ();
            tls.reality.enabled = true;
            tls.reality.public_key = params["pbk"] ?? "";
            tls.reality.short_id = params["sid"] ?? "";
        }


        if (params["fp"] != null || tls.reality != null) {
            tls.utls = new TLS.UTLS ();
            tls.utls.enabled = true;
            tls.utls.fingerprint = params["fp"];
        }

        switch (scheme) {
        case "vless":
            outbound = new Vless () {
                uuid = user,
                server = host,
                server_port = port,
                transport = transport,
                tls = tls,
                packet_encoding = params["packetEncoding"]
            };
            break;
        case "trojan":
            outbound = new Trojan () {
                password = user,
                server = host,
                server_port = port,
                transport = transport,
                tls = tls,
            };
            break;
        case "ss":
            string creds = (string) Base64.decode (user);
            var temp = creds.split (":", 2);
            if (temp.length != 2)
                throw new ParseError.WRONG_FORMATING ("Shadowsocks formating fail. Failed to parse creditants ?%s?", creds);
            outbound = new ShadowSocks () {
                method = temp[0],
                password = temp[1],
                server = host,
                server_port = port,
            };
            break;
        default:
            throw new ParseError.NOT_IMPLEMENTED ("Protocol %s not implemented yet", scheme);
        }
        outbound.name = name;
        outbound.hash = Base64.encode (profile.data);
        return outbound;
    }
}
