class VersionModel {
  VersionModel({
    this.id = "",
    this.romid = "",
    this.codename = "",
    required this.date,
    this.changelog = const [],
    this.error = const [],
    this.gappslink = "",
    this.vanillalink = "",
    this.downloadnumber = 0,
    this.relasetype = "",
    this.official = false,
  });

  final String id;
  final String romid;
  final String codename;
  final DateTime date;
  final List<dynamic> changelog;
  final bool official;
  final List<dynamic> error;
  final String gappslink;
  final String vanillalink;
  final int downloadnumber;
  final String relasetype;

  factory VersionModel.fromMap(Map<String, dynamic> data) => VersionModel(
        id: data["id"] ?? "",
        romid: data["romid"] ?? "",
        codename: data["codename"] ?? "",
        date: DateTime.parse(data["date"]),
        changelog: List<dynamic>.from(data["changelog"].map((x) => x)),
        error: List<dynamic>.from(data["error"].map((x) => x)),
        official: data["official"] ?? false,
        gappslink: data["gappslink"] ?? "",
        vanillalink: data["vanillalink"] ?? "",
        downloadnumber: data["downloadnumber"] ?? 0,
        relasetype: data["relasetype"] ?? "??" "",
      );
}
