import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/views/theme.dart';

import 'views/screen/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeApp.themeData,
      darkTheme: ThemeApp.themeData,
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
