import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';
import 'package:romlinks_frontend/logic/services/saveImage_service.dart';
import 'package:romlinks_frontend/logic/services/user_controller.dart';
import 'package:romlinks_frontend/logic/services/user_service.dart';
import 'package:romlinks_frontend/views/screen/saveImage_screen.dart';
import 'package:romlinks_frontend/views/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestScreen extends StatelessWidget {
  final SaveImageLink links = Get.put(SaveImageLink());
  final UserController _userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    TextW("User Service"),
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
                      "log out",
                      height: 50,
                      width: 200,
                      white: true,
                      onTap: () => UserService.logOut(),
                    ),
                    Obx(
                      () => TextW(
                        _userController.isLogged.toString(),
                        size: 20,
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    TextW("Image service"),
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
                    ButtonW(
                      "clear mage link",
                      height: 50,
                      width: 200,
                      white: true,
                      onTap: () => links.clearLink(),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    TextW("Rom Service"),
                  ],
                ),
                Column(
                  children: [
                    TextW("Device Service"),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
