// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/controller.dart';
import 'package:romlinks_frontend/logic/models.dart';
import 'package:romlinks_frontend/logic/services/rom_service.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';
import 'package:romlinks_frontend/views/screen/home_screen.dart';
import 'package:romlinks_frontend/views/screen/uploaded_screen.dart';

//! display a list of saved rom
class SavedRomScreen extends StatelessWidget {
  const SavedRomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldW(
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextW("Saved rom - " + Get.find<HomeScreenController>().codename, big: true),
          const SpaceW(),
          FutureBuilderW<List<RomModel>>(
            future: RomService.getRomById(),
            builder: (data) {
              data = data.where((x) => x.codename.contains(Get.find<HomeScreenController>().codename)).toList();
              return UploadedRomW(data, search: true);
            },
          ),
        ],
      ),
      scroll: (Get.find<UserController>().userData.value.savedRom.isEmpty) ? false : true,
    );
  }
}
