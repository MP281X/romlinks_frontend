import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/models/device_model.dart';
import 'package:romlinks_frontend/logic/services/device_service.dart';
import 'package:romlinks_frontend/logic/services/rom_service.dart';
import 'package:romlinks_frontend/logic/controller/image_controller.dart';
import 'package:romlinks_frontend/views/widget/accountButton_widget.dart';
import 'package:romlinks_frontend/views/widget/custom_widget.dart';
import 'package:romlinks_frontend/views/widget/futureBuilder_widget.dart';
import 'package:romlinks_frontend/views/widget/romList_widget.dart';
import 'package:romlinks_frontend/views/widget/scaffold_widget.dart';

//! main screen, display list of rom ordered by the review
class HomeScreen extends StatelessWidget {
  final ImageLinkController links = Get.put(ImageLinkController());
  @override
  Widget build(BuildContext context) {
    //TODO: renderli dinamici
    String codename = "ginkgo";
    double androidVersion = 12;
    return ScaffoldW(
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [TextW("RomLinks", big: true), AccountButtonW()],
          ),
          SpaceW(),
          FutureBuilderW<DeviceModel>(
            future: DeviceService.getDeviceInfo(codename),
            builder: (data) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [TextW(data.name), TextW("Android " + androidVersion.toString())],
              );
            },
          ),
          SpaceW(),
          RomListW(codename: codename, androidVersion: androidVersion, orderBy: OrderBy.battery),
          RomListW(codename: codename, androidVersion: androidVersion, orderBy: OrderBy.customization),
          RomListW(codename: codename, androidVersion: androidVersion, orderBy: OrderBy.performance),
          RomListW(codename: codename, androidVersion: androidVersion, orderBy: OrderBy.stability),
        ],
      ),
    );
  }
}
