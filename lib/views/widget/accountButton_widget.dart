import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';
import 'package:romlinks_frontend/logic/controller/user_controller.dart';
import 'package:romlinks_frontend/views/theme.dart';

import 'custom_widget.dart';

class AccountButtonW extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<UserController>(
      builder: (_userController) {
        if (_userController.isLogged.value) {
          return GestureDetector(
            onTap: () => Get.toNamed("/profile"),
            child: ContainerW(
              (_userController.userData.value.username != "")
                  ? Image.network(
                      FileStorageService.imgUrl(
                        PhotoCategory.profile,
                        _userController.userData.value.username,
                      ),
                      errorBuilder: (_, __, ___) {
                        return Icon(Icons.person, color: ThemeApp.accentColor);
                      },
                    )
                  : SizedBox.shrink(),
              height: 40,
              width: 40,
              padding: EdgeInsets.zero,
            ),
          );
        } else {
          return ButtonW(
            "Log in",
            width: 40 * 2.2,
            onTap: () => Get.toNamed("/auth"),
          );
        }
      },
    );
  }
}
