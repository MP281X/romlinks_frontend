class RomModel {
  RomModel({
    required this.id,
    required this.romname,
    required this.androidversion,
    required this.screenshot,
    required this.logo,
    required this.description,
    required this.link,
    required this.verified,
    required this.official,
    required this.codename,
    required this.review,
    required this.uploadedby,
  });

  final String id;
  final String romname;
  final int androidversion;
  final List<String> screenshot;
  final String logo;
  final String description;
  final List<dynamic> link;
  final bool verified;
  final bool official;
  final List<String> codename;
  final Review review;
  final String uploadedby;

  factory RomModel.fromMap(Map<String, dynamic> data) => RomModel(
        id: data["id"],
        romname: data["romname"],
        androidversion: data["androidversion"],
        screenshot: List<String>.from(data["screenshot"].map((x) => x)),
        logo: data["logo"],
        description: data["description"],
        link: List<dynamic>.from(data["link"].map((x) => x)),
        verified: data["verified"],
        official: data["official"],
        codename: List<String>.from(data["codename"].map((x) => x)),
        review: Review.fromMap(data["review"]),
        uploadedby: data["uploadedby"],
      );
}

class Review {
  Review({
    required this.battery,
    required this.batteryrevnum,
    required this.performance,
    required this.performancerevnum,
    required this.stability,
    required this.stabilityrevnum,
    required this.customization,
    required this.customizationrevnum,
  });

  final double battery;
  final int batteryrevnum;
  final double performance;
  final int performancerevnum;
  final double stability;
  final int stabilityrevnum;
  final double customization;
  final int customizationrevnum;

  factory Review.fromMap(Map<String, dynamic> data) => Review(
        battery: data["battery"],
        batteryrevnum: data["batteryrevnum"],
        performance: data["performance"],
        performancerevnum: data["performancerevnum"],
        stability: data["stability"],
        stabilityrevnum: data["stabilityrevnum"],
        customization: data["customization"],
        customizationrevnum: data["customizationrevnum"],
      );
}
