import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/controller/image_controller.dart';
import 'package:romlinks_frontend/logic/controller/user_controller.dart';
import 'package:romlinks_frontend/views/screen/addRom_screen.dart';
import 'package:romlinks_frontend/views/screen/auth_screen.dart';
import 'package:romlinks_frontend/views/screen/home_screen.dart';
import 'package:romlinks_frontend/views/screen/login_screen.dart';
import 'package:romlinks_frontend/views/screen/profile_screen.dart';
import 'package:romlinks_frontend/views/screen/signUp_screen.dart';
import 'package:romlinks_frontend/views/theme.dart';

void main() {
  Get.put<UserController>(UserController(), permanent: true);
  Get.put<ImageLinkController>(ImageLinkController(), permanent: true);
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
      home: HomeScreen(),
      getPages: [
        GetPage(name: "/logIn", page: () => LoginScreen()),
        GetPage(name: "/signUp", page: () => SignUpScreen()),
        GetPage(name: "/auth", page: () => AuthScreen()),
        GetPage(name: "/profile", page: () => ProfileScreen()),
        GetPage(name: "/addRom", page: () => AddRomScreen()),
      ],
    );
  }
}
