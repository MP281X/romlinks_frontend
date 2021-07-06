import 'package:get/get.dart';

import 'http_handler.dart';

class RomService extends GetxController {
  static final String url = "http://localhost:9092";

  static Future<String> addVersion({
    required String romId,
    required String codename,
    required String changelog,
    required String token,
    required String gappsLink,
    required String vanillaLink,
  }) async {
    Map<String, dynamic> response = await HttpHandler.post(
      url + "/version",
      header: {"token": token},
      body: {
        "romid": romId,
        "codename": codename,
        "changelog": changelog,
        "gappslink": gappsLink,
        "vanillalink": vanillaLink,
      },
    );
    return response["id"] ?? "";
  }

  static Future<Map<String, dynamic>> getRomList({
    required String codename,
    required double androidVersion,
    required OrderBy orderBy,
  }) async {
    // get the image category
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
    Map<String, dynamic> response = await HttpHandler.get(
      url +
          "/romlist/" +
          codename +
          "/" +
          androidVersion.toString() +
          "/" +
          orderByString,
    );
    return response;
  }

  static Future<Map<String, dynamic>> getVersionList({
    required String codename,
    required String romId,
  }) async {
    Map<String, dynamic> response =
        await HttpHandler.get(url + "/versionList/" + codename + "/" + romId);
    return response;
  }

  Future<String> verifyRom(String token, String romId) async {
    Map<String, dynamic> response = await HttpHandler.put(
      url + "/verifyrom/" + romId,
      header: {"token": token},
    );
    return response["res"] ?? "";
  }

  static Future<Map<String, dynamic>> getUnverifiedRom(String token) async {
    Map<String, dynamic> response =
        await HttpHandler.get(url + "/verifyrom", header: {"token": token});
    return response;
  }

  static Future<Map<String, dynamic>> getRom({
    required String codename,
    required double androidVersion,
    required String romName,
  }) async {
    romName = romName.replaceAll(" ", "%");
    Map<String, dynamic> response = await HttpHandler.get(
      url +
          "/rom/" +
          codename +
          "/" +
          androidVersion.toString() +
          "/" +
          romName,
    );
    return response;
  }

  static Future<Map<String, dynamic>> getRomById(String id) async {
    Map<String, dynamic> response = await HttpHandler.get(
      url + "/romid/" + id,
    );
    return response;
  }

  static Future<String> addRom({
    required String romName,
    required double androidVersion,
    required List<String> screenshot,
    required String logo,
    required String description,
    required List<String> codename,
    required String token,
  }) async {
    Map<String, dynamic> response = await HttpHandler.post(
      url + "/rom",
      header: {"token": token},
      body: {
        "romname": romName,
        "androidversion": androidVersion,
        "screenshot": screenshot,
        "logo": logo,
        "description": description,
        "codename": codename
      },
    );
    return response["id"] ?? "";
  }

  // search rom by name
  static Future<List<dynamic>> searchRomName(String romName) async {
    Map<String, dynamic> response =
        await HttpHandler.get(url + "/romName/" + romName);
    return response["list"] ?? [];
  }
}

enum OrderBy { performance, battery, stability, customization }
