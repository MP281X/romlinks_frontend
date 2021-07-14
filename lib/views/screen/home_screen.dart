import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/models/device_model.dart';
import 'package:romlinks_frontend/logic/models/rom_model.dart';
import 'package:romlinks_frontend/logic/services/device_service.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';
import 'package:romlinks_frontend/logic/services/rom_service.dart';
import 'package:romlinks_frontend/logic/controller/image_controller.dart';
import 'package:romlinks_frontend/views/screen/rom_screen.dart';
import 'package:romlinks_frontend/views/theme.dart';
import 'package:romlinks_frontend/views/widget/accountButton_widget.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';

//TODO: da rifare
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
          ButtonW("Add rom screen", onTap: () => Get.toNamed("/addRom")),
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
      scroll: true,
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
        TextW(categoryName(), big: true),
        SpaceW(),
        SizedBox(
          height: 200,
          child: FutureBuilderW<List<RomModel>>(
            future: RomService.getRomList(codename: codename, androidVersion: androidVersion, orderBy: orderBy),
            builder: (data) {
              return (data.length != 0)
                  ? ListView.builder(
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
      aspectRatio: 1,
      child: GestureDetector(
        onTap: () => Get.to(RomScreen(data, codename)),
        child: ContainerW(
          Column(
            children: [
              SizedBox(
                height: 70,
                width: 70,
                child: ImageW(category: PhotoCategory.logo, name: data.logo),
              ),
              SpaceW(),
              TextW(data.romname, maxLine: 1),
              ButtonW(
                (data.official) ? "Official" : "Unofficial",
                height: 36,
                width: 40 * 2.2,
                onTap: () {},
                color: ThemeApp.primaryColor,
              ),
            ],
          ),
          marginLeft: (!first),
        ),
      ),
    );
  }
}
