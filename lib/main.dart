import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/controller.dart';
import 'package:romlinks_frontend/views/screen/addRom_screen.dart';
import 'package:romlinks_frontend/views/screen/addVersion_screen.dart';
import 'package:romlinks_frontend/views/screen/auth_screen.dart';
import 'package:romlinks_frontend/views/screen/home_screen.dart';
import 'package:romlinks_frontend/views/screen/login_screen.dart';
import 'package:romlinks_frontend/views/screen/profile_screen.dart';
import 'package:romlinks_frontend/views/screen/savedRom_screen.dart';
import 'package:romlinks_frontend/views/screen/signUp_screen.dart';
import 'package:romlinks_frontend/views/screen/unverified_screen.dart';
import 'package:romlinks_frontend/views/screen/uploaded_screen.dart';
import 'package:romlinks_frontend/views/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  Get.put<HomeScreenController>(HomeScreenController(), permanent: true);
  Get.put<UserController>(UserController(), permanent: true);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "RomLinks",
      enableLog: false,
      theme: ThemeApp.themeData,
      darkTheme: ThemeApp.themeData,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      getPages: [
        GetPage(name: "/logIn", page: () => LoginScreen()),
        GetPage(name: "/signUp", page: () => SignUpScreen()),
        GetPage(name: "/auth", page: () => const AuthScreen()),
        GetPage(name: "/profile", page: () => ProfileScreen()),
        GetPage(name: "/uploaded", page: () => const UploadedScreen()),
        GetPage(name: "/addRom", page: () => AddRomScreen()),
        GetPage(name: "/addVersion/:romId", page: () => AddVersionScreen()),
        GetPage(name: "/unverified", page: () => const UnverifiedScreen()),
        GetPage(name: "/savedRom", page: () => const SavedRomScreen())
      ],
    );
  }
}
