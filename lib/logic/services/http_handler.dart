import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HttpHandler extends GetxController {
  //! http get handler
  static Future<Map<String, dynamic>> req(String url, RequestType request, {final Map<String, String>? header, final Map<String, dynamic>? body}) async {
    // try and catch error
    try {
      // conver the url string to a uri
      Uri uri = Uri.parse(url);

      late http.Response response;
      // make the request
      switch (request) {
        case RequestType.get:
          response = await http.get(uri, headers: header);
          break;
        case RequestType.post:
          response = await http.post(uri, headers: header, body: json.encode(body));
          break;
        case RequestType.put:
          response = await http.put(uri, headers: header, body: json.encode(body));
          break;
      }

      // decode the body
      Map<String, dynamic> data = jsonDecode(response.body);

      // check if there is a response message in the response
      if (data["res"] != null) {
        // open a snackbar with the response message
        Get.snackbar(
          "Response",
          data["res"],
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        );
      }

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

        // return an empty map
        return {};
      }

      // return the response data
      return data;

      // catch the error
    } catch (e) {
      // open a snackbar with the error message
      print(e);
      // return an empty map
      return {};
    }
  }
}

enum RequestType { get, post, put }
