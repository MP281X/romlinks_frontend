import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/controller/user_controller.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';
import 'package:romlinks_frontend/logic/services/saveImage_service.dart';
import 'package:romlinks_frontend/views/screen/saveImage_screen.dart';
import 'package:romlinks_frontend/views/widget/accountButton_widget.dart';
import 'package:romlinks_frontend/views/widget/custom_widget.dart';
import 'package:romlinks_frontend/views/widget/scaffold_widget.dart';

class HomeScreen extends StatelessWidget {
  final UserController _userController = Get.find();
  final SaveImageLink links = Get.put(SaveImageLink());
  @override
  Widget build(BuildContext context) {
    return ScaffoldW(
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextW("RomLinks", big: true),
              AccountButtonW(),
            ],
          ),
          ButtonW(
            "image crop",
            onTap: () => Get.to(
              SaveImageScreen(
                category: PhotoCategory.profile,
                fileName: _userController.userData.value.username,
                aspectRatio: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
