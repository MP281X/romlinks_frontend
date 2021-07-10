class VersionModel {
  VersionModel({
    required this.id,
    required this.romid,
    required this.codename,
    required this.date,
    required this.changelog,
    required this.error,
    required this.gappslink,
    required this.vanillalink,
    required this.downloadnumber,
    required this.relasetype,
  });

  final String id;
  final String romid;
  final String codename;
  final DateTime date;
  final String changelog;
  final List<dynamic> error;
  final String gappslink;
  final String vanillalink;
  final int downloadnumber;
  final String relasetype;

  factory VersionModel.fromMap(Map<String, dynamic> data) => VersionModel(
        id: data["id"],
        romid: data["romid"],
        codename: data["codename"],
        date: DateTime.parse(data["date"]),
        changelog: data["changelog"],
        error: List<dynamic>.from(data["error"].map((x) => x)),
        gappslink: data["gappslink"],
        vanillalink: data["vanillalink"],
        downloadnumber: data["downloadnumber"],
        relasetype: data["relasetype"],
      );
}
