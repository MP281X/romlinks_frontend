import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/models.dart';
import 'package:romlinks_frontend/logic/services/device_service.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';
import 'package:romlinks_frontend/logic/services/rom_service.dart';
import 'package:romlinks_frontend/views/screen/rom_screen.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';
import 'package:romlinks_frontend/views/theme.dart';

//! controller for the home screen
class HomeScreenController extends GetxController {
  @override
  void onInit() async {
    await setValue();
    super.onInit();
  }

  String codename = "";
  String romName = "";
  double androidVersion = 0;

  Future<void> setValue() async {
    if (!GetPlatform.isWeb) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      codename = androidInfo.device ?? "treble";
      androidVersion = double.parse(androidInfo.version.release ?? "0");
      update();
    } else {
      codename = "treble";
      androidVersion = 11;
      update();
    }
  }

  void searchDevice(String device, double version, String name) {
    codename = device;
    romName = name;
    androidVersion = version;
    update();
  }
}

//! main screen, display list of rom ordered by the review
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenController>(
      builder: (controller) {
        return RefreshIndicator(
          onRefresh: () async => controller.update(),
          child: ScaffoldW(
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(children: [
                  SizedBox(height: 40, child: Image.asset("images/logo1.png")),
                  Spacer(),
                  AccountButtonW(),
                  SearchButton(),
                ]),
                SpaceW(),
                FutureBuilderW<DeviceModel>(
                  future: DeviceService.getDeviceInfo(controller.codename),
                  builder: (data) => SizedBox(
                    height: 25,
                    child: Row(
                      children: [
                        if (data.name != "") TextW(data.name, size: 25, singleLine: true),
                        Spacer(),
                        if (controller.androidVersion != 0) TextW("Android ${controller.androidVersion.toInt()}", size: 25, singleLine: true),
                      ],
                    ),
                  ),
                ),
                SpaceW(),
                RomListW(codename: controller.codename, androidVersion: controller.androidVersion, orderBy: OrderBy.battery, romName: controller.romName),
                RomListW(codename: controller.codename, androidVersion: controller.androidVersion, orderBy: OrderBy.customization, romName: controller.romName),
                RomListW(codename: controller.codename, androidVersion: controller.androidVersion, orderBy: OrderBy.performance, romName: controller.romName),
                RomListW(codename: controller.codename, androidVersion: controller.androidVersion, orderBy: OrderBy.stability, romName: controller.romName),
              ],
            ),
            scroll: true,
          ),
        );
      },
    );
  }
}

//! display a list of rom
class RomListW extends StatelessWidget {
  const RomListW({required this.codename, required this.androidVersion, required this.orderBy, required this.romName});
  final String codename;
  final double androidVersion;
  final OrderBy orderBy;
  final String romName;

  String categoryName() {
    String orderByString;
    switch (orderBy) {
      case OrderBy.performance:
        orderByString = "Performance";
        break;
      case OrderBy.battery:
        orderByString = "Battery";
        break;
      case OrderBy.stability:
        orderByString = "Stability";
        break;
      case OrderBy.customization:
        orderByString = "Customization";
        break;
      default:
        orderByString = "";
    }
    orderByString = orderByString + " rom";
    return orderByString;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpaceW(),
        TextW(categoryName(), big: true, singleLine: true),
        SpaceW(),
        SizedBox(
          height: 200,
          child: FutureBuilderW<List<RomModel>>(
            future: RomService.getRomList(codename: codename, androidVersion: androidVersion, orderBy: orderBy, romName: romName),
            builder: (data) {
              return (data.length != 0)
                  ? ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) => RomPreviewW(
                            codename: codename,
                            data: data[index],
                            first: (index == 0),
                          ))
                  : ErrorW(msg: "No rom found for this device");
            },
          ),
        ),
      ],
    );
  }
}

//! display the rom name, the logo and basic rom info in the romlist widget
class RomPreviewW extends StatelessWidget {
  const RomPreviewW({
    required this.data,
    required this.codename,
    this.first = false,
  });
  final RomModel data;
  final bool first;
  final String codename;

  @override
  Widget build(BuildContext context) {
    String? heroTag = new Random().nextInt(100).toString() + new Random().nextInt(100).toString();
    return AspectRatio(
      aspectRatio: 0.8,
      child: GestureDetector(
        onTap: () => Get.to(RomScreen(data, codename: codename, heroTag: heroTag)),
        child: ContainerW(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 120,
                width: 140,
                child: ImageW(category: PhotoCategory.logo, name: data.logo, heroTag: heroTag),
              ),
              SpaceW(),
              TextW(data.romname + " - " + data.androidversion.toString(), singleLine: true, size: 23),
            ],
          ),
          marginLeft: (!first),
        ),
      ),
    );
  }
}

//! dialog for searchign devices and android version
class SearchButton extends StatelessWidget {
  final RxList deviceSuggestion = [].obs;
  final RxList romSuggestion = [].obs;
  final HomeScreenController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    TextEditingController codename = TextEditingController(text: controller.codename);
    TextEditingController version = TextEditingController(text: (controller.androidVersion != 0) ? controller.androidVersion.toString() : "");
    TextEditingController romName = TextEditingController(text: controller.romName);

    void searchDevice(String x) async {
      if (codename.text != "") deviceSuggestion.value = await DeviceService.searchDeviceName(codename.text);
    }

    void searchRom(String x) async {
      if (romName.text != "") romSuggestion.value = await RomService.searchDeviceName(romName.text);
    }

    return GestureDetector(
      onTap: () => dialogW(
        DialogW(
          alignment: Alignment.center,
          tag: "searchButton",
          text1: "Search rom",
          button1: () {
            controller.searchDevice(codename.text, double.tryParse(version.text) ?? 0, romName.text);
            Get.close(1);
          },
          child: Column(
            children: [
              TextFieldW(
                "rom name",
                controller: romName,
                onChanged: searchRom,
                onPressed: () => romName.clear(),
                buttonIcon: Icons.clear,
              ),
              Center(child: SuggestionW(suggestion: romSuggestion, onTap: (x) => romName.text = x)),
              TextFieldW(
                "codename",
                controller: codename,
                onChanged: searchDevice,
                onPressed: () => codename.clear(),
                buttonIcon: Icons.clear,
              ),
              Center(child: SuggestionW(suggestion: deviceSuggestion, onTap: (x) => codename.text = x)),
              TextFieldW(
                "Version",
                controller: version,
                number: true,
                onPressed: () => version.clear(),
                buttonIcon: Icons.clear,
              ),
            ],
          ),
          height: 400,
          width: 400,
        ),
      ),
      child: ContainerW(
        Icon(Icons.search_rounded, color: Colors.white, size: 25),
        padding: EdgeInsets.zero,
        marginRight: false,
        height: 40,
        width: 40,
        color: ThemeApp.secondaryColor,
        tag: "searchButton",
      ),
    );
  }
}
