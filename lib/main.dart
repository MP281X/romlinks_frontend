import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/services/user_controller.dart';
import 'package:romlinks_frontend/views/screen/auth_screen.dart';
import 'package:romlinks_frontend/views/screen/test_screen.dart';
import 'package:romlinks_frontend/views/screen/login_screen.dart';
import 'package:romlinks_frontend/views/screen/signUp_screen.dart';
import 'package:romlinks_frontend/views/theme.dart';

void main() {
  Get.put<UserController>(UserController(), permanent: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      enableLog: false,
      theme: ThemeApp.themeData,
      darkTheme: ThemeApp.themeData,
      debugShowCheckedModeBanner: false,
      home: TestScreen(),
      getPages: [
        GetPage(name: "/logIn", page: () => LoginScreen()),
        GetPage(name: "/signUp", page: () => SignUpScreen()),
        GetPage(name: "/auth", page: () => AuthScreen()),
      ],
    );
  }
}
