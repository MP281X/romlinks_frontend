import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/controller.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';

//! screen for the login
class LoginScreen extends StatelessWidget {
  final UserController controller = Get.find();

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String username = "";
    String password = "";

    Future<void> logIn() async {
      await controller.logIn(username, password);
      if (controller.isLogged.value) Get.toNamed("/");
    }

    return ScaffoldW(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const TextW("Log In", big: true),
          const SpaceW(big: true),
          TextFieldW("Username", onChanged: (text) => username = text, prefixIcon: Icons.person),
          TextFieldW(
            "Password",
            onChanged: (text) => password = text,
            prefixIcon: Icons.lock,
            hide: true,
            onPressed: logIn,
          ),
          ButtonW("Log in", animated: true, onTap: () async => await logIn()),
        ],
      ),
    );
  }
}
