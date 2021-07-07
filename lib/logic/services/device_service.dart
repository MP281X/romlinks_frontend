import 'package:get/get.dart';

import 'http_handler.dart';

class DeviceService extends GetxController {
  //! device service base url
  static final String url = "http://localhost:9090";

  //! get the info of a device
  static Future<Map<String, dynamic>> getDeviceInfo(String codename) async {
    // make the request
    Map<String, dynamic> response = await HttpHandler.req(url + "/devices/" + codename, RequestType.post);

    // return the device info
    return response;
  }

  //! add a device to the db
  static Future<void> addDevice(String codename, String name, List<String> photo, String brand, String token) async {
    // make the request
    await HttpHandler.req(
      url + "/devices",
      RequestType.post,
      header: {"token": token},
      body: {
        "codename": codename,
        "name": name,
        "photo": photo,
        "brand": brand,
      },
    );
  }

  //! search device by name
  static Future<List<dynamic>> searchDeviceName(String codename) async {
    // make the request
    Map<String, dynamic> response = await HttpHandler.req(url + "/deviceName/" + codename, RequestType.get);

    // return a device name list or an empty list
    return response["list"] ?? [];
  }

  //TODO: da fare
  void editDeviceInfo() {}
}
