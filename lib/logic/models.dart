import 'package:get/get.dart';

//! user model
class UserModel {
  const UserModel({
    this.userId = "",
    this.username = "",
    this.email = "",
    this.savedRom = const [],
    this.verified = false,
    this.moderator = false,
  });

  final String userId;
  final String username;
  final String email;
  final List savedRom;
  final bool verified;
  final bool moderator;

  factory UserModel.fromMap(Map<String, dynamic> data) => UserModel(
        userId: data["_id"],
        username: data["username"],
        email: data["email"],
        savedRom: data["savedRom"],
        verified: data["verified"],
        moderator: data["moderator"],
      );
}

//! device model
class DeviceModel {
  const DeviceModel({
    this.codename = "",
    this.name = "",
  });

  final String codename;
  final String name;

  factory DeviceModel.fromMap(Map<String, dynamic> data) => DeviceModel(
        codename: data["codename"] ?? "",
        name: data["name"] ?? "",
      );
}

//! specs -> device model
class Specs {
  const Specs({
    this.camera = "",
    this.battery = 0,
    this.processor = "",
  });

  final String camera;
  final int battery;
  final String processor;

  factory Specs.fromMap(Map<String, dynamic> data) => Specs(
        camera: data["camera"] ?? "",
        battery: data["battery"] ?? 0,
        processor: data["processor"] ?? "",
      );
}

//! version model
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
    this.uploadedBy = "",
    this.versionNum = "",
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
  final String uploadedBy;
  final String versionNum;

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
      relasetype: data["relasetype"] ?? "",
      uploadedBy: data["uploadedby"] ?? "",
      versionNum: data["version"] ?? "");
}

//! rom model
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

//! review -> rom model
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
    if (x == 0) return const Review(battery: 0, performance: 0, stability: 0, customization: 0, revNum: 0);
    return Review(
      battery: double.parse(data["battery"].toString()) / x,
      performance: double.parse(data["performance"].toString()) / x,
      stability: double.parse(data["stability"].toString()) / x,
      customization: double.parse(data["customization"].toString()) / x,
      revNum: x,
    );
  }
}

//! comment -> rom model
class CommentModel {
  const CommentModel({
    this.romId = "",
    this.codename = "",
    this.username = "",
    this.msg = "",
    this.battery = 0,
    this.performance = 0,
    this.stability = 0,
    this.customization = 0,
  });

  final String romId;
  final String codename;
  final String username;
  final String msg;
  final double battery;
  final double performance;
  final double stability;
  final double customization;

  factory CommentModel.fromMap(Map<String, dynamic> data) => CommentModel(
        romId: data["romid"] ?? "",
        codename: data["codename"] ?? "",
        username: data["username"] ?? "",
        msg: data["msg"] ?? "",
        battery: double.parse(data["battery"].toString()),
        performance: double.parse(data["performance"].toString()),
        stability: double.parse(data["stability"].toString()),
        customization: double.parse(data["customization"].toString()),
      );
}

class RequestModel {
  const RequestModel({
    this.id = "",
    this.romname = "",
    this.codename = "",
    this.androidVersion = 0,
  });

  final String id;
  final String romname;
  final String codename;
  final double androidVersion;

  factory RequestModel.fromMap(Map<String, dynamic> data) => RequestModel(
        id: data["id"] ?? "",
        romname: data["romname"] ?? "",
        codename: data["codename"] ?? "",
        androidVersion: double.parse(data["androidversion"] ?? "0"),
      );
}
