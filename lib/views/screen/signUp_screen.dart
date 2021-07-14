import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/controller/user_controller.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';

//! screen for the sign up
class SignUpScreen extends StatelessWidget {
  final UserController _userController = Get.find();

  @override
  Widget build(BuildContext context) {
    String username = "";
    String password = "";
    String email = "";

    Future<void> singUp() async {
      if (email.isEmail == false) {
        snackbarW("Error", "Enter a valid email");
        return;
      }
      await _userController.signUp(username, password, email);
      if (_userController.isLogged.value) Get.toNamed("/");
    }

    return ScaffoldW(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextW("Sign up", big: true),
          SpaceW(big: true),
          TextFieldW("Username", onChanged: (text) => username = text, prefixIcon: Icons.person),
          TextFieldW("Email", onChanged: (text) => email = text, prefixIcon: Icons.email),
          TextFieldW("Password", onChanged: (text) => password = text, prefixIcon: Icons.lock, hide: true),
          ButtonW("Sign up", animated: true, onTap: () async => await singUp()),
        ],
      ),
    );
  }
}
