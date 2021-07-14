import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/controller/user_controller.dart';
import 'package:romlinks_frontend/logic/models/user_model.dart';
import 'package:romlinks_frontend/views/theme.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';

//TODO: da rifare
//! display the user information
class ProfileScreen extends StatelessWidget {
  final UserController _userController = Get.find();
  @override
  Widget build(BuildContext context) {
    UserModel userData = _userController.userData.value;
    return ScaffoldW(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextW(userData.username),
          TextW(userData.email),
          if (userData.savedRom.isNotEmpty) TextW(userData.savedRom.toString()),
          if (userData.link.isNotEmpty) TextW(userData.link.toString()),
          Row(
            children: [
              TextW("Verified "),
              ButtonW(
                userData.verified.toString(),
                height: 40,
                width: 40 * 2.2,
                onTap: () {},
                color: ThemeApp.secondaryColor,
              ),
            ],
          ),
          Row(
            children: [
              TextW("Moderator  "),
              ButtonW(
                userData.moderator.toString(),
                height: 40,
                width: 40 * 2.2,
                onTap: () {},
                color: ThemeApp.secondaryColor,
              ),
            ],
          ),
          ButtonW("Log out", onTap: () async => await _userController.logOut()),
        ],
      ),
    );
  }
}
