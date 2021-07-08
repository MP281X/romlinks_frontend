import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/controller/user_controller.dart';
import 'package:romlinks_frontend/views/widget/custom_widget.dart';
import 'package:romlinks_frontend/views/widget/scaffold_widget.dart';

class LoginScreen extends StatelessWidget {
  final UserController _userController = Get.find();

  @override
  Widget build(BuildContext context) {
    late String username;
    late String password;
    return ScaffoldW(
      SizedBox(
        width: 230,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextW(
              "Log In",
              big: true,
            ),
            SizedBox(height: 30),
            TextField(
              onChanged: (text) => username = text,
              decoration: InputDecoration(
                hintText: "Username",
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              onChanged: (text) => password = text,
              decoration: InputDecoration(
                hintText: "Password",
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            SizedBox(height: 10),
            ButtonW(
              "Log in",
              animated: true,
              onTap: () async {
                if (username != "" && password != "") {
                  await _userController.logIn(username, password);
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
