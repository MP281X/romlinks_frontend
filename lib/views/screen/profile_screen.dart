import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/controller/user_controller.dart';
import 'package:romlinks_frontend/logic/models/user_model.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';
import 'package:romlinks_frontend/views/screen/saveImage_screen.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';

//! display the user information
class ProfileScreen extends StatelessWidget {
  final UserController _userController = Get.find();
  final link = "".obs;
  @override
  Widget build(BuildContext context) {
    UserModel userData = _userController.userData.value;
    link.value = userData.username;
    return ScaffoldW(
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 150,
            width: 150,
            child: Stack(
              children: [
                SizedBox(
                  child: Obx(() => ImageW(category: PhotoCategory.profile, name: link.value, profileIcon: true)),
                  height: 150,
                  width: 150,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () async {
                      link.value = "";
                      await Get.dialog(SaveImageDialog(index: 0, category: PhotoCategory.profile));
                      link.value = userData.username;
                    },
                    iconSize: 30,
                    splashRadius: 20,
                    icon: Icon(Icons.edit),
                  ),
                )
              ],
            ),
          ),
          SpaceW(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextW(userData.username.toUpperCase(), big: true),
              if (userData.verified) SizedBox(width: 10),
              if (userData.verified) Icon(Icons.verified),
              if (userData.moderator) ButtonW("Mod", onTap: () {}, height: 30, width: 50, padding: EdgeInsets.all(5))
            ],
          ),
          SpaceW(),
          TextW(userData.email, maxLine: 1),
          if (userData.savedRom.isNotEmpty) TextW(userData.savedRom.toString()),
          if (userData.link.isNotEmpty) TextW(userData.link.toString()),
          SpaceW(),
          ButtonW("Add new rom", onTap: () => Get.toNamed("/addRom")),
          ButtonW("Uploaded rom", onTap: () => Get.toNamed("/uploaded")),
          if (userData.moderator) ButtonW("Unverified rom", onTap: () => Get.toNamed("/unverified")),
          ButtonW("Log out", onTap: () async => await _userController.logOut()),
        ],
      ),
      auth: true,
    );
  }
}
