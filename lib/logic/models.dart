import 'package:get/get.dart';

//! user model
class UserModel {
  const UserModel({
    this.userId = "",
    this.username = "",
    this.email = "",
    this.savedRom = const [],
    this.link = const [],
    this.verified = false,
    this.moderator = false,
  });

  final String userId;
  final String username;
  final String email;
  final List savedRom;
  final List link;
  final bool verified;
  final bool moderator;

  factory UserModel.fromMap(Map<String, dynamic> data) => UserModel(
        userId: data["_id"],
        username: data["username"],
        email: data["email"],
        savedRom: data["savedRom"],
        link: data["dev"]["link"],
        verified: data["dev"]["verified"],
        moderator: data["moderator"],
      );
}

//! device model
class DeviceModel {
  const DeviceModel({
    this.codename = "",
    this.name = "",
    this.brand = "",
    this.specs = const Specs(),
    this.bootloaderlinks = const [],
    this.recoverylinks = const [],
    this.gcamlinks = const [],
  });

  final String codename;
  final String name;
  final String brand;
  final Specs specs;
  final List<dynamic> bootloaderlinks;
  final List<dynamic> recoverylinks;
  final List<dynamic> gcamlinks;

  factory DeviceModel.fromMap(Map<String, dynamic> data) => DeviceModel(
        codename: data["codename"] ?? "",
        name: data["name"] ?? "",
        brand: data["brand"] ?? "",
        specs: Specs.fromMap(data["specs"]),
        bootloaderlinks: List<dynamic>.from(data["bootloaderlinks"].map((x) => x)),
        recoverylinks: List<dynamic>.from(data["recoverylinks"].map((x) => x)),
        gcamlinks: List<dynamic>.from(data["gcamlinks"].map((x) => x)),
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

//! list of rom and version model
class RomVersionModel {
  RomVersionModel({
    this.rom = const <RomModel>[],
    this.version = const <VersionModel>[],
  });

  final List<RomModel> rom;
  final List<VersionModel> version;

  factory RomVersionModel.fromMap(Map<String, dynamic> data) => RomVersionModel(
        rom: List<RomModel>.from(data["rom"].map((x) => RomModel.fromMap(x))),
        version: List<VersionModel>.from(data["version"].map((x) => VersionModel.fromMap(x))),
      );
}
