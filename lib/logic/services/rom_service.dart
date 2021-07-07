import 'package:get/get.dart';

import 'http_handler.dart';

class RomService extends GetxController {
  //! rom service base url
  static final String url = "http://localhost:9092";

  //! add a rom version to the db
  static Future<void> addVersion({required String romId, required String codename, required String changelog, required String token, required String gappsLink, required String vanillaLink}) async {
    // make the request
    await HttpHandler.req(
      url + "/version",
      RequestType.post,
      header: {"token": token},
      body: {
        "romid": romId,
        "codename": codename,
        "changelog": changelog,
        "gappslink": gappsLink,
        "vanillalink": vanillaLink,
      },
    );
  }

  //! get a list of rom
  static Future<List<dynamic>> getRomList({required String codename, required double androidVersion, required OrderBy orderBy}) async {
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

    // return the rom list or an empty list
    return response["list"] ?? [];
  }

  //! get a list of rom version
  static Future<List<dynamic>> getVersionList({required String codename, required String romId}) async {
    // make the request
    Map<String, dynamic> response = await HttpHandler.req(url + "/versionList/" + codename + "/" + romId, RequestType.get);

    // return the list of version or an empty list
    return response["list"] ?? [];
  }

  //! verify a rom
  static Future<void> verifyRom(String token, String romId) async {
    // make the request
    await HttpHandler.req(url + "/verifyrom/" + romId, RequestType.put, header: {"token": token});
  }

  //! get a list of unverified rom
  static Future<List<dynamic>> getUnverifiedRom(String token) async {
    // make the request
    Map<String, dynamic> response = await HttpHandler.req(url + "/verifyrom", RequestType.get, header: {"token": token});

    // return a list of rom or an empty list
    return response["list"] ?? [];
  }

  //! get a single rom from the rom data
  static Future<Map<String, dynamic>> getRom({required String codename, required double androidVersion, required String romName}) async {
    // replace the space in the rom name with %
    romName = romName.replaceAll(" ", "%");

    // make the request
    Map<String, dynamic> response = await HttpHandler.req(url + "/rom/" + codename + "/" + androidVersion.toString() + "/" + romName, RequestType.get);

    // return the rom
    return response;
  }

  //! get a single rom from the id
  static Future<Map<String, dynamic>> getRomById(String id) async {
    // make the request
    Map<String, dynamic> response = await HttpHandler.req(url + "/romid/" + id, RequestType.get);

    // return the rom data
    return response;
  }

  //! add a rom to the db
  static Future<void> addRom({
    required String romName,
    required double androidVersion,
    required List<String> screenshot,
    required String logo,
    required String description,
    required List<String> codename,
    required String token,
  }) async {
    // make the request
    await HttpHandler.req(
      url + "/rom",
      RequestType.post,
      header: {"token": token},
      body: {"romname": romName, "androidversion": androidVersion, "screenshot": screenshot, "logo": logo, "description": description, "codename": codename},
    );
  }

  //! search rom by name
  static Future<List<dynamic>> searchRomName(String romName) async {
    // make the request
    Map<String, dynamic> response = await HttpHandler.req(url + "/romName/" + romName, RequestType.get);

    // return a list of rom name
    return response["list"] ?? [];
  }
}

enum OrderBy { performance, battery, stability, customization }
