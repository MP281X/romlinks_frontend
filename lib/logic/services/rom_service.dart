import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/controller.dart';
import 'package:romlinks_frontend/logic/models.dart';

import 'http_handler.dart';

class RomService extends GetxController {
  //! rom service base url
  static final bool local = HttpHandler.local;
  static final String url = (local) ? "http://localhost:9092" : "https://romlinks.rom.mp281x.xyz";

  //! add a rom version to the db
  static Future<void> addVersion({
    required String romId,
    required String codename,
    required List<String> changelog,
    required List<String> error,
    required String token,
    required String? gappsLink,
    required String? vanillaLink,
    required String relasetype,
    required bool official,
    required DateTime date,
  }) async {
    print(date.toIso8601String());
    // make the request
    await HttpHandler.req(
      url + "/version",
      RequestType.post,
      header: {"token": token},
      body: {
        "romid": romId,
        "codename": codename,
        "changelog": changelog,
        "error": error,
        "gappslink": gappsLink,
        "vanillalink": vanillaLink,
        "relasetype": relasetype,
        "official": official,
        "date": date.toIso8601String() + "+00:00",
      },
    );
  }

  //! get a list of rom
  static Future<List<RomModel>> getRomList({required String codename, required double androidVersion, required OrderBy orderBy}) async {
    // convert the order by to a string
    String orderByString;
    switch (orderBy) {
      case OrderBy.performance:
        orderByString = "review.performance";
        break;
      case OrderBy.battery:
        orderByString = "review.battery";
        break;
      case OrderBy.stability:
        orderByString = "review.stability";
        break;
      case OrderBy.customization:
        orderByString = "review.customization";
        break;
      default:
        orderByString = "";
    }

    // make the request
    Map<String, dynamic> response = await HttpHandler.req(url + "/romlist/" + codename + "/" + androidVersion.toString() + "/" + orderByString, RequestType.get);

    // convert the response to a list of rom model
    List<RomModel> romList = List<RomModel>.from(response["list"].map((x) => RomModel.fromMap(x)));

    // return the rom list or an empty list
    return romList;
  }

  //! get a list of rom version
  static Future<List<VersionModel>> getVersionList({required String codename, required String romId}) async {
    // make the request
    Map<String, dynamic> response = await HttpHandler.req(url + "/versionList/" + codename + "/" + romId, RequestType.get);

    // convert the response to a list of versionmodel
    List<VersionModel> versionList = List<VersionModel>.from(response["list"].map((x) => VersionModel.fromMap(x)));
    // return the list of version or an empty list
    return versionList;
  }

  //! verify a rom
  static Future<void> verifyRom(String romId) async {
    // get the user controller
    UserController _userController = Get.find();
    // make the request
    await HttpHandler.req(url + "/verifyrom/" + romId, RequestType.put, header: {"token": _userController.token});
  }

  //! get a list of unverified rom
  static Future<List<RomModel>> getUnverifiedRom() async {
    // get the user controller
    UserController _userController = Get.find();

    // make the request
    Map<String, dynamic> response = await HttpHandler.req(url + "/verifyrom", RequestType.get, header: {"token": _userController.token});

    // convert the response to a list of rom model
    List<RomModel> romList = List<RomModel>.from(response["list"].map((x) => RomModel.fromMap(x)));

    // return a list of rom or an empty list
    return romList;
  }

  //! get a single rom from the rom data
  static Future<RomModel> getRom({required String codename, required double androidVersion, required String romName}) async {
    // replace the space in the rom name with %
    romName = romName.replaceAll(" ", "%");

    // make the request
    Map<String, dynamic> response = await HttpHandler.req(url + "/rom/" + codename + "/" + androidVersion.toString() + "/" + romName, RequestType.get);

    // return the rom
    return RomModel.fromMap(response);
  }

  //! get a single rom from the id
  static Future<RomModel> getRomById(String id) async {
    // make the request
    Map<String, dynamic> response = await HttpHandler.req(url + "/romid/" + id, RequestType.get);

    // return the rom data
    return RomModel.fromMap(response);
  }

  //! add a rom to the db
  static Future<void> addRom({
    required String romName,
    required double androidVersion,
    required List<String> screenshot,
    required String logo,
    required String description,
  }) async {
    // get the user controller
    UserController _userController = Get.find();

    // make the request
    await HttpHandler.req(
      url + "/rom",
      RequestType.post,
      header: {"token": _userController.token},
      body: {
        "romname": romName,
        "androidversion": androidVersion,
        "screenshot": screenshot,
        "logo": logo,
        "description": description,
      },
    );
  }

  //! search rom by name
  static Future<List<dynamic>> searchRomName(String romName) async {
    // make the request
    Map<String, dynamic> response = await HttpHandler.req(url + "/romName/" + romName, RequestType.get);
    // return a list of rom name
    return response["list"] ?? [];
  }

  //! get a single rom from the rom data
  static Future<RomVersionModel> getUploaded() async {
    // get the user controller
    UserController _userController = Get.find();
    // make the request
    Map<String, dynamic> response = await HttpHandler.req(url + "/romVersion", RequestType.get, header: {"token": _userController.token});

    if (response["rom"] == null && response["version"] == null) {
      return RomVersionModel();
    }
    // return the rom
    return RomVersionModel.fromMap(response);
  }

  //! get a list comment
  static Future<List<CommentModel>> getComment(String romId) async {
    // make the request
    Map<String, dynamic> response = await HttpHandler.req(url + "/review/" + romId, RequestType.get);

    // convert the response to a list of comment model
    List<CommentModel> commentList = List<CommentModel>.from(response["list"].map((x) => CommentModel.fromMap(x)));

    // return a list of comment or an empty list
    return commentList;
  }

  //! add a comment
  static Future<void> addComment({
    required String romId,
    required String codename,
    required String msg,
    required double battery,
    required double performance,
    required double stability,
    required double customization,
  }) async {
    // get the user controller
    UserController _userController = Get.find();

    // make the request
    await HttpHandler.req(
      url + "/review",
      RequestType.put,
      header: {"token": _userController.token},
      body: {
        "romid": romId,
        "codename": codename,
        "msg": msg,
        "battery": battery,
        "performance": performance,
        "stability": stability,
        "customization": customization,
      },
    );
  }
}

enum OrderBy { performance, battery, stability, customization }
