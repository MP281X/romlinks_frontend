import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/controller/user_controller.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';

//! screen for the login
class LoginScreen extends StatelessWidget {
  final UserController _userController = Get.find();

  @override
  Widget build(BuildContext context) {
    String username = "";
    String password = "";

    Future<void> logIn() async {
      await _userController.logIn(username, password);
      if (_userController.isLogged.value) Get.toNamed("/");
    }

    return ScaffoldW(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextW("Log In", big: true),
          SpaceW(big: true),
          TextFieldW("Username", onChanged: (text) => username = text, prefixIcon: Icons.person),
          TextFieldW("Password", onChanged: (text) => password = text, prefixIcon: Icons.lock, hide: true),
          ButtonW("Log in", animated: true, onTap: () async => await logIn()),
        ],
      ),
    );
  }
}
