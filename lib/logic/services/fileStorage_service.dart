import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:romlinks_frontend/logic/controller/user_controller.dart';

class FileStorageService extends GetxController {
  //! file storage service base url
  static final String url = "http://localhost:9091";

  //! save an image in the backend
  static Future<String> postImage({required PhotoCategory category, required String romName, required double androidVersion, required Uint8List image}) async {
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
      romName = romName + ".png";

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
        Get.snackbar(
          "Error",
          data["err"],
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        );

        // return an empty string
        return "";
      }

      // if the response code is 200 open a snackbar with the image link
      if (data["imgLink"] != null)
        Get.snackbar(
          "Image uploaded",
          url + "/image/" + data["imgLink"],
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        );

      // return the image link or an empty string
      return data["imgLink"] ?? "";

      // catch error
    } catch (_) {
      // if there is error open a snackbar with an error message
      Get.snackbar(
        "Error",
        "unable to save the image",
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      );

      // return an empty string
      return "";
    }
  }

  //! save a profile picture in the backend
  static Future<String> postProfilePicture(String username, Uint8List image) async {
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
        Get.snackbar(
          "Error",
          data["err"],
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        );

        // return an empty string
        return "";
      }

      // open a snackbar with the image link
      if (data["imgLink"] != null)
        Get.snackbar(
          "Image uploaded",
          url + "/image/" + data["imgLink"],
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        );

      // return the image link or an empty string
      return data["imgLink"] ?? "";
    } catch (_) {
      // if there is error open a snackbar with the error message
      Get.snackbar(
        "Error",
        "unable to save the image",
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      );

      // return an empty string
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
