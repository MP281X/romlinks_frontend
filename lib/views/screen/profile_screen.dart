import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/controller.dart';
import 'package:romlinks_frontend/logic/models.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';
import 'package:romlinks_frontend/views/screen/saveImage_screen.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';
import 'package:romlinks_frontend/views/theme.dart';

//! display the user information
class ProfileScreen extends StatelessWidget {
  final UserController controller = Get.find();
  final link = "".obs;
  @override
  Widget build(BuildContext context) {
    UserModel userData = controller.userData.value;
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
              if (userData.moderator)
                ChipW(
                  text: "Mod",
                  color: ThemeApp.accentColor,
                  height: 30,
                  width: 50,
                ),
            ],
          ),
          SpaceW(),
          TextW(userData.email, singleLine: true),
          SpaceW(),
          ButtonW("Add new rom", onTap: () => Get.toNamed("/addRom")),
          ButtonW("Saved", onTap: () => Get.toNamed("/savedRom")),
          ButtonW("Uploaded", onTap: () => Get.toNamed("/uploaded")),
          if (userData.moderator) ButtonW("Unverified", onTap: () => Get.toNamed("/unverified")),
          ButtonW("Log out", onTap: () async => await controller.logOut()),
        ],
      ),
      auth: true,
    );
  }
}
