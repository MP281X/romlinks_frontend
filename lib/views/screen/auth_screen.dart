import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/views/theme.dart';
import 'package:romlinks_frontend/views/widget/custom_widget.dart';
import 'package:romlinks_frontend/views/widget/scaffold_widget.dart';

//! redirect to the login and sign up screen
class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScaffoldW(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextW("RomLinks", big: true),
          SpaceW(big: true),
          ButtonW("Log in", onTap: () => Get.toNamed("/logIn")),
          ButtonW("Sign up", color: ThemeApp.primaryColor, margin: EdgeInsets.zero, onTap: () => Get.toNamed("/signUp")),
        ],
      ),
    );
  }
}
