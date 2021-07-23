import 'package:get/get.dart';

class RomModel {
  const RomModel({
    this.id = "",
    this.romname = "",
    this.androidversion = 0,
    this.screenshot,
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
  final RxList<String>? screenshot;
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
        screenshot: RxList<String>.from(data["screenshot"].map((x) => x)),
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
    this.performance = 0,
    this.stability = 0,
    this.customization = 0,
    this.revNum = 0,
  });

  final double battery;
  final double performance;
  final double stability;
  final double customization;
  final int revNum;

  factory Review.fromMap(Map<String, dynamic> data) {
    var x = int.parse(data["reviewnum"].toString());
    if (x == 0) return Review(battery: 0, performance: 0, stability: 0, customization: 0, revNum: 0);
    return Review(
      battery: double.parse(data["battery"].toString()) / x,
      performance: double.parse(data["performance"].toString()) / x,
      stability: double.parse(data["stability"].toString()) / x,
      customization: double.parse(data["customization"].toString()) / x,
      revNum: x,
    );
  }
}
