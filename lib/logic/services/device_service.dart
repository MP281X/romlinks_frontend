import 'package:get/get.dart';

import 'http_handler.dart';

class DeviceService extends GetxController {
  static final String url = "http://mp281x.xyz:9090";

  //TODO: da fare
  void editDeviceInfo() {}

  static Future<Map<String, dynamic>> getDeviceInfo(String codename) async {
    Map<String, dynamic> response =
        await HttpHandler.post(url + "/devices/" + codename);
    return response;
  }

  static Future<Map<String, dynamic>> addDevice(
    String codename,
    String name,
    List<String> photo,
    String brand,
    String token,
  ) async {
    Map<String, dynamic> response = await HttpHandler.post(
      url + "/devices",
      header: {"token": token},
      body: {
        "codename": codename,
        "name": name,
        "photo": photo,
        "brand": brand,
      },
    );
    return response;
  }

  //TODO: da fare
  void searchDeviceName(String codename) {}
}
