import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/controller/user_controller.dart';
import 'package:romlinks_frontend/logic/models/device_model.dart';

import 'http_handler.dart';

class DeviceService extends GetxController {
  //! device service base url
  static final bool local = HttpHandler.local;
  static final String url = (local) ? "http://localhost:9090" : "https://romlinks.device.mp281x.xyz";

  //! get the info of a device
  static Future<DeviceModel> getDeviceInfo(String codename) async {
    // make the request
    Map<String, dynamic> response = await HttpHandler.req(url + "/devices/" + codename, RequestType.get);

    // if it doesn't find the device in the db add the device to the db
    if (response.isEmpty && GetPlatform.isAndroid) {
      // get the device info
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      String codenameD = androidInfo.device ?? "";
      String name = androidInfo.model ?? "";
      String brand = androidInfo.brand ?? "";

      // check the device info and add the device
      await DeviceService.addDevice(
        codename: codenameD,
        name: name,
        brand: brand,
      );

      // get the device info again
      response = await HttpHandler.req(url + "/devices/" + codename, RequestType.get);
    }

    // convert the response in a device model
    DeviceModel deviceInfo = DeviceModel.fromMap(response);

    // return the device info model
    return deviceInfo;
  }

  //! add a device to the db
  static Future<void> addDevice({required String codename, required String name, required String brand}) async {
    // get the user controller
    UserController _userController = Get.find();

    // make the request
    await HttpHandler.req(
      url + "/devices",
      RequestType.post,
      header: {"token": _userController.token},
      body: {
        "codename": codename,
        "name": name,
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

  //! edit the info of a device
  static Future<void> editDeviceInfo(String codename, {List<String>? gcamLinks, String? camera, double? battery, String? processor}) async {
    // get the user controller
    UserController _userController = Get.find();

    await HttpHandler.req(
      url + "/devices/" + codename,
      RequestType.put,
      header: {"token": _userController.token},
      body: {
        "gcamlinks": gcamLinks,
        "specs": {
          "camera": camera,
          "battery": battery,
          "processor": processor,
        }
      },
    );
  }

  //! get a list of uploaded devices
  static Future<List<DeviceModel>> getUploaded() async {
    // get the user controller
    UserController _userController = Get.find();
    // make the request
    Map<String, dynamic> response = await HttpHandler.req(url + "/devices", RequestType.get, header: {"token": _userController.token});

    // return the list of devices
    return List<DeviceModel>.from(response["list"].map((x) => DeviceModel.fromMap(x)));
  }
}
