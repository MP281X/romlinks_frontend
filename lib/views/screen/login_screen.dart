import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/services/user_service.dart';

import '../theme.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    late String username;
    late String password;
    return Scaffold(
      body: SizedBox(
        height: context.height,
        width: context.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextW(
              "Log in",
              size: 40,
            ),
            SizedBox(height: 30),
            SizedBox(
              height: 50,
              width: 250,
              child: TextField(
                onChanged: (text) => username = text,
                decoration: InputDecoration(
                  hintText: "Username",
                  prefixIcon: Icon(Icons.person),
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: 250,
              child: TextField(
                onChanged: (text) => password = text,
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
            ),
            SizedBox(height: 10),
            ButtonW(
              "Log in",
              height: 50,
              width: 200,
              white: true,
              onTap: () async {
                if (username != "" && password != "") {
                  String token = await UserService.logIn(username, password);
                  if (token.isNotEmpty) {
                    Get.toNamed("/");
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
