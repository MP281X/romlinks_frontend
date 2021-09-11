import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:romlinks_frontend/views/custom_widget.dart';

class HttpHandler extends GetxController {
  static bool local = false;
  //! http get handler
  static Future<Map<String, dynamic>> req(String url, RequestType request, {final Map<String, String>? header, final Map<String, dynamic>? body}) async {
    String errMsg = "";
    // try and catch error
    try {
      // conver the url string to a uri
      Uri uri = Uri.parse(url);

      late http.Response response;

      // make the request
      switch (request) {
        case RequestType.get:
          response = await http.get(uri, headers: header).timeout(const Duration(seconds: 10));
          break;
        case RequestType.post:
          response = await http.post(uri, headers: header, body: json.encode(body)).timeout(const Duration(seconds: 10));
          break;
        case RequestType.put:
          response = await http.put(uri, headers: header, body: json.encode(body)).timeout(const Duration(seconds: 10));
          break;
        case RequestType.delete:
          response = await http.delete(uri, headers: header).timeout(const Duration(seconds: 10));
          break;
      }

      // decode the body
      Map<String, dynamic> data = jsonDecode(response.body);

      // check if there is a response message in the response
      snackbarW("Response", data["res"]);

      // check the response code
      if (response.statusCode != 200) {
        // save the error msg and throw an exception
        errMsg = data["err"];
        throw ServerResErr();
      }

      // return the response data
      return data;

      // catch the error
    } on TimeoutException {
      snackbarW("Error", "No api response");
      return {};
    } on SocketException {
      snackbarW("Error", "No internet connection");
      return {};
    } on ServerResErr {
      snackbarW("Error", errMsg);
      return {};
    } catch (e) {
      snackbarW("Error", "No server response");
      return {};
    }
  }
}

enum RequestType { get, post, put, delete }

class ServerResErr implements Exception {
  ServerResErr();
}
