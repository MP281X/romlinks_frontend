import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/controller.dart';
import 'package:romlinks_frontend/views/screen/addRom_screen.dart';
import 'package:romlinks_frontend/views/screen/addVersion_screen.dart';
import 'package:romlinks_frontend/views/screen/auth_screen.dart';
import 'package:romlinks_frontend/views/screen/home_screen.dart';
import 'package:romlinks_frontend/views/screen/login_screen.dart';
import 'package:romlinks_frontend/views/screen/profile_screen.dart';
import 'package:romlinks_frontend/views/screen/signUp_screen.dart';
import 'package:romlinks_frontend/views/screen/unverifyed_screen.dart';
import 'package:romlinks_frontend/views/screen/uploaded_screen.dart';
import 'package:romlinks_frontend/views/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
  Get.put<HomeScreenController>(HomeScreenController(), permanent: true);
  Get.put<UserController>(UserController(), permanent: true);
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
        GetPage(name: "/uploaded", page: () => UploadedScreen()),
        GetPage(name: "/addRom", page: () => AddRomScreen()),
        GetPage(name: "/addVersion/:romId", page: () => AddVersionScreen()),
        GetPage(name: "/unverified", page: () => UnverifiedScreen()),
      ],
    );
  }
}
