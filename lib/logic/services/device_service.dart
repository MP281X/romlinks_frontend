import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/models/device_model.dart';

import 'http_handler.dart';

class DeviceService extends GetxController {
  //! device service base url
  static final bool local = true;
  static final String url = (local) ? "http://localhost:9090" : "https://romlinks.device.mp281x.xyz";

  //! get the info of a device
  static Future<DeviceModel> getDeviceInfo(String codename) async {
    // make the request
    Map<String, dynamic> response = await HttpHandler.req(url + "/devices/" + codename, RequestType.get);

    DeviceModel deviceInfo = DeviceModel.fromMap(response);

    // return the device info
    return deviceInfo;
  }

  //! add a device to the db
  static Future<void> addDevice({required String codename, required String name, required List<String> photo, required String brand, required String token}) async {
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
