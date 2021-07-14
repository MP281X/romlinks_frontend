import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:romlinks_frontend/logic/controller/user_controller.dart';
import 'package:romlinks_frontend/logic/services/http_handler.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';

class FileStorageService extends GetxController {
  //! file storage service base url
  static final bool local = true;
  static final String url = (local) ? "http://localhost:9091" : "https://romlinks.filestorage.mp281x.xyz";

  //! save an image in the backend
  static Future<String> postImage({required PhotoCategory category, required String romName, required double androidVersion, required Uint8List image}) async {
    String errMsg = "";
    // try and catch error
    try {
      // convert the photo category to a string
      String categoryString;
      switch (category) {
        case PhotoCategory.logo:
          categoryString = "logo";
          break;
        case PhotoCategory.devicePhoto:
          categoryString = "devicePhoto";
          break;
        case PhotoCategory.screenshot:
          categoryString = "screenshot";
          break;
        default:
          categoryString = "";
      }

      // add the image format to the image name
      romName = romName;

      // create the uri
      Uri uri = Uri.parse(
        url + "/image/" + categoryString + "/" + androidVersion.toString() + "/" + romName,
      );
      // convert the image to a list of int
      List<int> byteToIntList = image.cast();

      // create the request
      var request = http.MultipartRequest('POST', uri);

      // add the file to the request
      request.files.add(http.MultipartFile.fromBytes("file", byteToIntList, filename: "ciao"));

      // make the request
      var response = await http.Response.fromStream(await request.send());

      // decode the body
      Map<String, dynamic> data = jsonDecode(response.body);

      // check if the response code isn't 200
      if (response.statusCode != 200) {
        // open a snackbar with the error
        errMsg = data["err"];
        throw ServerResErr();
      }

      // return the image link or an empty string
      return data["imgLink"] ?? "";

      // catch error
    } on TimeoutException {
      snackbarW("Error", "No api response");
      return "";
    } on SocketException {
      snackbarW("Error", "No internet connection");
      return "";
    } on ServerResErr {
      print("error");
      snackbarW("Error", errMsg);
      return "";
    } catch (e) {
      snackbarW("Error", "No server response");
      return "";
    }
  }

  //! save a profile picture in the backend
  static Future<String> postProfilePicture(String username, Uint8List image) async {
    String errMsg = "";
    // try and catch error
    try {
      // create the uri
      Uri uri = Uri.parse(url + "/profile/" + username + ".png");

      // convert the image to a int list
      List<int> byteToIntList = image.cast();

      // create the request
      var request = http.MultipartRequest('POST', uri);
      UserController _userController = Get.find();
      request.headers.assign("token", _userController.token);
      // add the file to the request
      request.files.add(http.MultipartFile.fromBytes("file", byteToIntList, filename: "ciao"));

      // make the request
      var response = await http.Response.fromStream(await request.send());

      // decode the body
      Map<String, dynamic> data = jsonDecode(response.body);

      // check the response code
      if (response.statusCode != 200) {
        // open a snackbar with the error
        errMsg = data["err"];
        throw ServerResErr();
      }

      // return the image link or an empty string
      return data["imgLink"] ?? "";
    } on TimeoutException {
      snackbarW("Error", "No api response");
      return "";
    } on SocketException {
      snackbarW("Error", "No internet connection");
      return "";
    } on ServerResErr {
      print("error");
      snackbarW("Error", errMsg);
      return "";
    } catch (e) {
      snackbarW("Error", "No server response");
      return "";
    }
  }

  //! build the image url
  static String imgUrl(PhotoCategory category, String name) {
    // convet the photo category to a string
    String categoryString;
    switch (category) {
      case PhotoCategory.logo:
        categoryString = "logo";
        break;
      case PhotoCategory.devicePhoto:
        categoryString = "devicePhoto";
        break;
      case PhotoCategory.screenshot:
        categoryString = "screenshot";
        break;
      case PhotoCategory.profile:
        categoryString = "profile";
        break;
      default:
        categoryString = "";
    }

    if (category == PhotoCategory.profile) {
      return url + "/image/" + categoryString + "/" + name + ".png";
    }
    // return the image url
    return url + "/image/" + categoryString + "/" + name;
  }
}

enum PhotoCategory { logo, devicePhoto, screenshot, profile }
