import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/views/theme.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: context.height,
        width: context.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextW(
              "RomLinks",
              size: 40,
            ),
            SizedBox(height: 30),
            ButtonW(
              "Log in",
              height: 50,
              width: 200,
              white: true,
              onTap: () => Get.toNamed("/logIn"),
            ),
            ButtonW(
              "Sign up",
              height: 50,
              width: 200,
              white: true,
              color: ThemeApp.primaryColor,
              margin: EdgeInsets.zero,
              onTap: () => Get.toNamed("/signUp"),
            ),
          ],
        ),
      ),
    );
  }
}
