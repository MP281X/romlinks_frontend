import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';
import 'package:romlinks_frontend/logic/services/saveImage_service.dart';
import 'package:romlinks_frontend/views/screen/saveImage_screen.dart';
import 'package:romlinks_frontend/views/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  final SaveImageLink links = Get.put(SaveImageLink());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonW(
              "auth",
              height: 50,
              width: 200,
              white: true,
              onTap: () => Get.toNamed("/auth"),
            ),
            ButtonW(
              "token",
              height: 50,
              width: 200,
              white: true,
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? token = prefs.getString("token");
                print(token);
                String? username = prefs.getString("username");
                print(username);
                String? password = prefs.getString("password");
                print(password);
              },
            ),
            ButtonW(
              "Crop and save",
              height: 50,
              width: 200,
              white: true,
              onTap: () => Get.to(
                SaveImageScreen(
                  aspectRatio: 1,
                  category: PhotoCategory.logo,
                  romName: "test",
                  androidVersion: 11,
                ),
              ),
            ),
            ButtonW(
              "Image link",
              height: 50,
              width: 200,
              white: true,
              onTap: () => print(links.imageLinks),
            ),
          ],
        ),
      ),
    );
  }
}
