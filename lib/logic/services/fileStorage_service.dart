import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:romlinks_frontend/logic/controller/user_controller.dart';
import 'package:romlinks_frontend/logic/services/http_handler.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';

class FileStorageService extends GetxController {
  //! file storage service base url
  static final bool local = HttpHandler.local;
  static final String url = (local) ? "http://localhost:9091" : "https://romlinks.filestorage.mp281x.xyz";

  //! save an image in the backend
  static Future<String> postImage({
    required PhotoCategory category,
    required String romName,
    required double androidVersion,
    required List<int> image,
    required int index,
    required String format,
  }) async {
    String errMsg = "";
    // try and catch error
    try {
      imageCache!.clear();
      if (index > 5 || index < 0) {
        snackbarW("Error", "invalid screenshot index");
      }
      // convert the photo category to a string
      String categoryString;
      switch (category) {
        case PhotoCategory.logo:
          index = 0;
          categoryString = "logo";
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
      Uri uri = Uri.parse(url + "/image/" + categoryString);

      // create the request
      var request = http.MultipartRequest('POST', uri);

      // add the image data to the headers
      UserController _userController = Get.find();
      request.headers.addAll(
        {
          "android": androidVersion.toString(),
          "index": index.toString(),
          "format": format,
          "romName": romName,
          "token": _userController.token,
        },
      );

      // add the file to the request
      request.files.add(http.MultipartFile.fromBytes("file", image, filename: "img"));

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
      snackbarW("Error", errMsg);
      return "";
    } catch (e) {
      snackbarW("Error", "No server response");
      return "";
    }
  }

  //! save a profile picture in the backend
  static Future<String> postProfilePicture(List<int> image) async {
    String errMsg = "";
    // try and catch error
    try {
      imageCache!.clear();
      // create the uri
      Uri uri = Uri.parse(url + "/profile");

      // create the request
      var request = http.MultipartRequest('POST', uri);

      // add the token to the request
      UserController _userController = Get.find();
      request.headers.assign("token", _userController.token);

      // add the file to the request
      request.files.add(http.MultipartFile.fromBytes("file", image, filename: "img"));

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

enum PhotoCategory { logo, screenshot, profile }
