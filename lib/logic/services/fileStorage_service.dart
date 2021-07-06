import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class FileStorageService extends GetxController {
  static final String url = "http://localhost:9091";

  static Future<String> postImage({
    required PhotoCategory category,
    required String romName,
    required double androidVersion,
  }) async {
    // get the image category
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

    // create the uri
    Uri uri = Uri.parse(
      url +
          "/image/" +
          categoryString +
          "/" +
          androidVersion.toString() +
          "/" +
          romName,
    );

    // get the image
    final picker = ImagePicker();
    PickedFile? pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      Get.snackbar(
        "Error",
        "Unable to get the image",
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      );
      return "";
    }

    // convert the image
    Uint8List fileToByte = await pickedFile.readAsBytes();
    List<int> byteToIntList = fileToByte.cast();

    // create the request
    var request = http.MultipartRequest('POST', uri);

    // add the file to the request
    request.files.add(
        http.MultipartFile.fromBytes("file", byteToIntList, filename: "ciao"));

    // make the request
    var response = await http.Response.fromStream(await request.send());

    // decode the body
    Map<String, dynamic> data = jsonDecode(response.body);

    // check the response code
    if (response.statusCode != 200) {
      Get.snackbar(
        "Error",
        data["err"],
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      );
      return "";
    }
    Get.snackbar(
      "Image uploaded",
      url + "/image/" + data["imgLink"],
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    );
    // return the image link
    return data["imgLink"] ?? "";
  }

  Future<String> postProfilePicture(String username) async {
    // create the uri
    Uri uri = Uri.parse(url + "/profile/" + username);

    // get the image
    final picker = ImagePicker();
    PickedFile? pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      Get.snackbar(
        "Error",
        "Unable to get the image",
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      );
      return "";
    }

    // convert the image
    Uint8List fileToByte = await pickedFile.readAsBytes();
    List<int> byteToIntList = fileToByte.cast();

    // create the request
    var request = http.MultipartRequest('POST', uri);

    // add the file to the request
    request.files.add(
        http.MultipartFile.fromBytes("file", byteToIntList, filename: "ciao"));

    // make the request
    var response = await http.Response.fromStream(await request.send());

    // decode the body
    Map<String, dynamic> data = jsonDecode(response.body);

    // check the response code
    if (response.statusCode != 200) {
      Get.snackbar(
        "Error",
        data["err"],
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      );
      return "";
    }
    Get.snackbar(
      "Image uploaded",
      url + "/image/" + data["imgLink"],
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    );
    // return the image link
    return data["imgLink"] ?? "";
  }

  // build the image url
  static String imgUrl(PhotoCategory category, String name) {
    // get the image category
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

    return url + "/" + categoryString + "/" + name;
  }
}

enum PhotoCategory { logo, devicePhoto, screenshot }
