class RomModel {
  const RomModel({
    this.id = "",
    this.romname = "",
    this.androidversion = 0,
    this.screenshot = const [],
    this.logo = "",
    this.description = "",
    this.link = const [],
    this.verified = false,
    this.codename = const [],
    this.review = const Review(),
    this.uploadedby = "",
  });

  final String id;
  final String romname;
  final int androidversion;
  final List<String> screenshot;
  final String logo;
  final String description;
  final List<dynamic> link;
  final bool verified;
  final List<String> codename;
  final Review review;
  final String uploadedby;

  factory RomModel.fromMap(Map<String, dynamic> data) => RomModel(
        id: data["id"] ?? "",
        romname: data["romname"] ?? "",
        androidversion: data["androidversion"] ?? "",
        screenshot: List<String>.from(data["screenshot"].map((x) => x)),
        logo: data["logo"] ?? "",
        description: data["description"] ?? "",
        link: List<dynamic>.from(data["link"].map((x) => x)),
        verified: data["verified"] ?? false,
        codename: List<String>.from(data["codename"].map((x) => x)),
        review: Review.fromMap(data["review"]),
        uploadedby: data["uploadedby"] ?? "",
      );
}

class Review {
  const Review({
    this.battery = 0,
    this.batteryrevnum = 0,
    this.performance = 0,
    this.performancerevnum = 0,
    this.stability = 0,
    this.stabilityrevnum = 0,
    this.customization = 0,
    this.customizationrevnum = 0,
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
        battery: double.parse(data["battery"].toString()),
        batteryrevnum: int.parse(data["batteryrevnum"].toString()),
        performance: double.parse(data["performance"].toString()),
        performancerevnum: int.parse(data["performancerevnum"].toString()),
        stability: double.parse(data["stability"].toString()),
        stabilityrevnum: int.parse(data["stabilityrevnum"].toString()),
        customization: double.parse(data["customization"].toString()),
        customizationrevnum: int.parse(data["customizationrevnum"].toString()),
      );
}
