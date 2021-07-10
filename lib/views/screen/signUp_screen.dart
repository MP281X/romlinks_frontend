import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/controller/user_controller.dart';
import 'package:romlinks_frontend/views/widget/custom_widget.dart';
import 'package:romlinks_frontend/views/widget/scaffold_widget.dart';

//! screen for the sign up
class SignUpScreen extends StatelessWidget {
  final UserController _userController = Get.find();

  @override
  Widget build(BuildContext context) {
    late String username;
    late String password;
    late String email;
    return ScaffoldW(
      SizedBox(
        width: 230,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextW("Sign up", big: true),
            SpaceW(big: true),
            TextField(
              onChanged: (text) => username = text,
              decoration: InputDecoration(hintText: "Username", prefixIcon: Icon(Icons.person)),
            ),
            SpaceW(),
            TextField(
              onChanged: (text) => email = text,
              decoration: InputDecoration(hintText: "Email", prefixIcon: Icon(Icons.email)),
            ),
            SpaceW(),
            TextField(
              onChanged: (text) => password = text,
              decoration: InputDecoration(hintText: "Password", prefixIcon: Icon(Icons.lock)),
              obscureText: true,
            ),
            SpaceW(),
            ButtonW(
              "Sign up",
              onTap: () async {
                if (username != "" && password != "") {
                  await _userController.signUp(username, password, email);
                  if (_userController.isLogged.value) Get.toNamed("/");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
