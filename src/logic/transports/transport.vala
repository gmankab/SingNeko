/*
 * Base class for transport.
 * TYPE FIX REQUIRED
 */
class SingNeko.Transport.Transport : Object, Json.Serializable {
    // We can't use name `type` in vala
    public string type_name { get; construct set; default = ""; }
}
