import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';
import 'package:romlinks_frontend/logic/controller/user_controller.dart';
import 'package:romlinks_frontend/views/widget/image_widget.dart';

import 'custom_widget.dart';

//! button that redirect to the auth or the profile screen depending on the auth state
class AccountButtonW extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<UserController>(
      builder: (_userController) {
        if (_userController.isLogged.value) {
          return GestureDetector(
            onTap: () => Get.toNamed("/profile"),
            child: ContainerW(
              (_userController.userData.value.username != "") ? ImageW(category: PhotoCategory.profile, name: _userController.userData.value.username, profileIcon: true) : SizedBox.shrink(),
              height: 40,
              width: 40,
              marginRight: false,
              padding: EdgeInsets.zero,
            ),
          );
        } else {
          return ButtonW(
            "Log in",
            margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
            width: 40 * 2.2,
            onTap: () => Get.toNamed("/auth"),
          );
        }
      },
    );
  }
}
