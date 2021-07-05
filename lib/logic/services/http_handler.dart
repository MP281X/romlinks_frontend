import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HttpHandler extends GetxController {
  // http get handler
  static Future<Map<String, dynamic>> get(
    String url, {
    final Map<String, String>? header,
    final Map<String, dynamic>? body,
  }) async {
    // create the uri
    Uri uri = Uri.parse(url);

    // make the request
    http.Response response = await http.get(uri, headers: header);

    // decode the body
    Map<String, dynamic> data = jsonDecode(response.body);

    // check and return the response
    if (response.statusCode == 200) {
      return data;
    } else {
      Get.snackbar(
        "Error",
        data["error"],
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      );
      return {};
    }
  }

  // http post handler
  static Future<Map<String, dynamic>> post(
    String url, {
    final Map<String, String>? header,
    final Map<String, dynamic>? body,
  }) async {
    // create the uri
    Uri uri = Uri.parse(url);

    // make the request
    http.Response response = await http.post(uri, headers: header, body: body);

    // decode the body
    Map<String, dynamic> data = jsonDecode(response.body);

    // check and return the response
    if (response.statusCode == 200) {
      return data;
    } else {
      Get.snackbar(
        "Error",
        data["error"],
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      );
      return {};
    }
  }

  // http put handler
  static Future<Map<String, dynamic>> put(
    String url, {
    final Map<String, String>? header,
    final Map<String, dynamic>? body,
  }) async {
    // create the uri
    Uri uri = Uri.parse(url);

    // make the request
    http.Response response = await http.put(uri, headers: header, body: body);

    // decode the body
    Map<String, dynamic> data = jsonDecode(response.body);

    // check and return the response
    if (response.statusCode == 200) {
      return data;
    } else {
      Get.snackbar(
        "Error",
        data["error"],
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      );
      return {};
    }
  }
}
