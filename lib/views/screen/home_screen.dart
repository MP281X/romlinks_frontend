import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/models/device_model.dart';
import 'package:romlinks_frontend/logic/models/rom_model.dart';
import 'package:romlinks_frontend/logic/services/device_service.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';
import 'package:romlinks_frontend/logic/services/rom_service.dart';
import 'package:romlinks_frontend/views/screen/rom_screen.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';
import 'package:romlinks_frontend/views/theme.dart';

class HomeScreenController extends GetxController {
  @override
  void onInit() async {
    await setValue();
    super.onInit();
  }

  String unlocked = "";
  String codename = "";
  double androidVersion = 0;

  Future<void> setValue() async {
    if (!GetPlatform.isWeb) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      codename = androidInfo.device ?? "treble";
      androidVersion = double.parse(androidInfo.version.release ?? "0");
    } else {
      codename = "treble";
      androidVersion = 11;
    }
    update();
  }

  void searchDevice(String device, double version) {
    codename = device;
    androidVersion = version;
    update();
  }
}

//! main screen, display list of rom ordered by the review
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenController>(
      builder: (roms) {
        return RefreshIndicator(
          onRefresh: () => roms.setValue(),
          child: ScaffoldW(
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(height: 60, child: Image.asset("images/logo.png")),
                    Spacer(),
                    AccountButtonW(),
                    SearchButton(),
                  ],
                ),
                SpaceW(),
                FutureBuilderW<DeviceModel>(
                    future: DeviceService.getDeviceInfo(roms.codename),
                    builder: (data) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextW(data.name[0].toUpperCase() + data.name.substring(1), size: 25),
                            TextW("Android ${roms.androidVersion.toInt()}", size: 25),
                          ],
                        )),
                SpaceW(),
                RomListW(codename: roms.codename, androidVersion: roms.androidVersion, orderBy: OrderBy.battery),
                RomListW(codename: roms.codename, androidVersion: roms.androidVersion, orderBy: OrderBy.customization),
                RomListW(codename: roms.codename, androidVersion: roms.androidVersion, orderBy: OrderBy.performance),
                RomListW(codename: roms.codename, androidVersion: roms.androidVersion, orderBy: OrderBy.stability),
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
  const RomListW({required this.codename, required this.androidVersion, required this.orderBy});
  final String codename;
  final double androidVersion;
  final OrderBy orderBy;

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
            future: RomService.getRomList(codename: codename, androidVersion: androidVersion, orderBy: orderBy),
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
                      ),
                    )
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
    String? heroTag = new Random().nextInt(1000).toString();
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
              TextW(data.romname, singleLine: true, size: 23),
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
  final RxList suggestion = [].obs;
  final HomeScreenController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    TextEditingController codename = TextEditingController(text: controller.codename);
    TextEditingController version = TextEditingController(text: controller.androidVersion.toString());
    void searchDevice(String x) async {
      if (codename.text != "") suggestion.value = await DeviceService.searchDeviceName(codename.text);
    }

    return GestureDetector(
      onTap: () => dialogW(
        DialogW(
          alignment: Alignment.center,
          tag: "searchButton",
          button1: () {
            controller.searchDevice(codename.text, double.parse(version.text));
            Get.close(1);
          },
          text1: "Search",
          child: Column(
            children: [
              TextFieldW("codename", controller: codename, onChanged: searchDevice),
              Center(
                child: Obx(
                  () => (suggestion.length > 0)
                      ? ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 45, maxWidth: 800),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: suggestion.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ButtonW(
                                suggestion[index],
                                width: 90,
                                color: ThemeApp.secondaryColor,
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                onTap: () => codename.text = suggestion[index],
                              );
                            },
                          ),
                        )
                      : SizedBox.shrink(),
                ),
              ),
              TextFieldW("Version", controller: version, number: true),
            ],
          ),
          height: 300,
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
