import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/models/device_model.dart';
import 'package:romlinks_frontend/logic/models/rom_model.dart';
import 'package:romlinks_frontend/logic/services/device_service.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';
import 'package:romlinks_frontend/logic/services/rom_service.dart';
import 'package:romlinks_frontend/views/screen/addVersion_screen.dart';
import 'package:romlinks_frontend/views/screen/rom_screen.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';

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
      androidVersion = 12;
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextW("RomLinks", big: true),
                    AccountButtonW(),
                  ],
                ),
                SelectedDeviceW(),
                SpaceW(),
                SpaceW(),
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
  const RomListW({Key? key, required this.codename, required this.androidVersion, required this.orderBy}) : super(key: key);
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
        TextW(categoryName(), big: true, maxLine: 1),
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
                        key: Key(data[index].id),
                        first: (index == 0),
                      ),
                    )
                  : ErrorW("No rom found for this device");
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
    Key? key,
    required this.data,
    required this.codename,
    this.first = false,
  }) : super(key: key);
  final RomModel data;
  final bool first;
  final String codename;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.9,
      child: GestureDetector(
        onTap: () => Get.to(RomScreen(data, codename: codename)),
        child: ContainerW(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: ImageW(category: PhotoCategory.logo, name: data.logo),
              ),
              SpaceW(),
              TextW(data.romname, maxLine: 1, size: 23),
            ],
          ),
          marginLeft: (!first),
        ),
      ),
    );
  }
}

//TODO: migliorare

//! display the device and the android version of the current device
class SelectedDeviceW extends StatelessWidget {
  final HomeScreenController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FutureBuilderW<DeviceModel>(
            future: DeviceService.getDeviceInfo(controller.codename),
            builder: (data) {
              return Row(
                children: [
                  TextW(data.name, size: 25),
                  Spacer(),
                  TextW("Android " + controller.androidVersion.toString(), size: 25),
                ],
              );
            },
          ),
        ),
        RomSelectionW()
      ],
    );
  }
}

//! controller for the device search
class RomSelectionController extends GetxController {
  List suggestion = [];

  TextEditingController codenameController = TextEditingController();
  double androidVerision = 0;

  // setter method
  void setCodenameAndSuggestion(String x) async {
    if (codenameController.text != "") {
      suggestion = await DeviceService.searchDeviceName(codenameController.text);
      update();
    }
  }

  void setAndroidVersion(String x) {
    androidVerision = double.parse(x);
  }

  void setCodename(String x) {
    codenameController.text = x;
    update();
  }

  @override
  void onInit() {
    HomeScreenController controller = Get.find();
    codenameController.text = controller.codename;
    update();
    super.onInit();
  }
}

//! widget for searching device
class RomSelectionW extends StatelessWidget {
  final HomeScreenController roms = Get.find();
  final RomSelectionController searchController = Get.put(RomSelectionController());

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => bottomSheetW(
        child: GetBuilder<RomSelectionController>(builder: (controller) {
          return Column(
            children: [
              TextFieldW(
                "codename",
                onChanged: controller.setCodenameAndSuggestion,
                controller: controller.codenameController,
              ),
              SuggestionW(suggestion: controller.suggestion, onTap: controller.setCodename),
              TextFieldW("android version", onChanged: controller.setAndroidVersion, number: true),
            ],
          );
        }),
        text: "Search rom",
        onTap: () {
          roms.searchDevice(searchController.codenameController.text, searchController.androidVerision);
          Get.close(1);
        },
        scrollable: false,
        text2: "Cancel",
      ),
      icon: Icon(Icons.search, size: 25),
      color: Colors.white,
      splashRadius: 25,
    );
  }
}
