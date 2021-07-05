import 'package:get/get.dart';

import 'http_handler.dart';

class RomService extends GetxController {
  static final String url = "http://mp281x.xyz:9092";

  static Future<String> addVersion(
    String romId,
    String codename,
    String changelog,
    String token, {
    required String gappsLink,
    required String vanillaLink,
  }) async {
    Map<String, dynamic> response = await HttpHandler.post(
      url + "/devices",
      header: {"token": token},
      body: {
        "romid": romId,
        "codename": codename,
        "changelog": changelog,
        "gappslink": gappsLink,
        "vanillalink": vanillaLink,
      },
    );
    return response["id"];
  }

  static Future<Map<String, dynamic>> getRomList(
    String codename,
    double androidVersion,
    OrderBy orderBy,
  ) async {
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

  static Future<Map<String, dynamic>> getVersionList(
    String codename,
    String romId,
  ) async {
    Map<String, dynamic> response =
        await HttpHandler.get(url + "/versionList/" + codename + "/" + romId);
    return response;
  }

  Future<String> verifyRom(String token, String romId) async {
    Map<String, dynamic> response = await HttpHandler.put(
      url + "/verifyrom/" + romId,
      header: {"token": token},
    );
    return response["res"];
  }

  static Future<Map<String, dynamic>> getUnverifiedRom(String token) async {
    Map<String, dynamic> response =
        await HttpHandler.get(url + "/verifyrom", header: {"token": token});
    return response;
  }

  static Future<Map<String, dynamic>> getRom(
    String codename,
    double androidVersion,
    String romName,
  ) async {
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

  static Future<String> addRom(
    String romName,
    double androidVersion,
    List<String> screenshot,
    String logo,
    String description,
    List<String> codename,
    String token,
  ) async {
    Map<String, dynamic> response = await HttpHandler.post(
      url + "/devices",
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
    return response["id"];
  }

  //TODO: da fare
  void searchRomName() {}
}

enum OrderBy { performance, battery, stability, customization }
