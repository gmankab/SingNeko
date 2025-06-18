class Singularity.Outbound.Outbound : Object, Json.Serializable {
    // We can't use name `type` in vala
    public string type_name { get; construct set; default = ""; }
    public string tag { get; set; default = ""; }
}
