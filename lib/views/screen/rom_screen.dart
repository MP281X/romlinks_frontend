import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/models/rom_model.dart';
import 'package:romlinks_frontend/logic/models/version_model.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';
import 'package:romlinks_frontend/logic/services/rom_service.dart';
import 'package:romlinks_frontend/views/screen/addVersion_screen.dart';
import 'package:romlinks_frontend/views/screen/version_screen.dart';
import 'package:romlinks_frontend/views/theme.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';
import 'package:romlinks_frontend/views/widget/screenshot_widget.dart';
import 'package:url_launcher/url_launcher.dart';
//TODO: da fixare

//! display the info of a rom
class RomScreen extends StatelessWidget {
  const RomScreen(this.romData, this.codename);
  final RomModel romData;
  final String codename;

  @override
  Widget build(BuildContext context) {
    return ScaffoldW(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ButtonW("Add version", onTap: () => Get.to(AddVersionScreen(romData.id))),
          TextW(romData.romname, big: true),
          SpaceW(),
          TextW("Android ${romData.androidversion}", big: true),
          SpaceW(big: true),
          Center(
            child: SizedBox(
              child: ImageW(category: PhotoCategory.logo, name: romData.logo),
              height: 200,
              width: 200,
            ),
          ),
          SpaceW(big: true),
          TextW("Description", big: true),
          SpaceW(),
          TextW(romData.description),
          SpaceW(big: true),
          TextW("Screenshot", big: true),
          ScreenshotW(romData.screenshot),
          ReviewW(romData.review),
          SpaceW(),
          RomVersionListW(codename: codename, romId: romData.id),
          SizedBox(height: 70),
        ],
      ),
      scroll: true,
    );
  }
}

//! display the review of the rom
class ReviewW extends StatelessWidget {
  const ReviewW(this.rev);
  final Review rev;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpaceW(big: true),
        TextW("Review", big: true),
        ContainerW(
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextW("Performance:"),
                  TextW("Stability:"),
                  TextW("Customization:"),
                  TextW("Battery:"),
                ],
              ),
              SizedBox(width: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(children: List<Widget>.generate(5, (index) => Icon((index >= rev.performance) ? Icons.star_outline : Icons.star, color: Colors.white))),
                  Row(children: List<Widget>.generate(5, (index) => Icon((index >= rev.stability) ? Icons.star_outline : Icons.star, color: Colors.white))),
                  Row(children: List<Widget>.generate(5, (index) => Icon((index >= rev.customization) ? Icons.star_outline : Icons.star, color: Colors.white))),
                  Row(children: List<Widget>.generate(5, (index) => Icon((index >= rev.battery) ? Icons.star_outline : Icons.star, color: Colors.white))),
                ],
              ),
            ],
          ),
          marginLeft: false,
          height: 200,
          width: 350,
        ),
      ],
    );
  }
}

//! display a list of vanilla build and a list of gapps
class RomVersionListW extends StatelessWidget {
  const RomVersionListW({required this.codename, required this.romId});
  final String codename;
  final String romId;
  @override
  Widget build(BuildContext context) {
    return FutureBuilderW<List<VersionModel>>(
      future: RomService.getVersionList(codename: codename, romId: romId),
      builder: (data) {
        List<VersionModel> vanilla = data.where((element) => element.vanillalink != "").toList();
        List<VersionModel> gapps = data.where((element) => element.gappslink != "").toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (vanilla.length > 0) SpaceW(big: true),
            if (vanilla.length > 0) TextW("Vanilla Build", big: true),
            if (vanilla.length > 0)
              SizedBox(
                width: context.width,
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: vanilla.length,
                  itemBuilder: (BuildContext context, int index) => RomVersionW(version: vanilla[index], gapps: false),
                ),
              ),
            if (gapps.length > 0) SpaceW(big: true),
            if (gapps.length > 0) TextW("Gapps Build", big: true),
            if (gapps.length > 0)
              SizedBox(
                width: context.width,
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: gapps.length,
                  itemBuilder: (BuildContext context, int index) => RomVersionW(version: gapps[index], gapps: true),
                ),
              ),
          ],
        );
      },
    );
  }
}

//! tile of the romversionlist
class RomVersionW extends StatelessWidget {
  const RomVersionW({required this.version, required this.gapps, this.index = 1, Key? key}) : super(key: key);
  final VersionModel version;
  final int index;
  final bool gapps;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(VersionScreen(version: version, gapps: gapps)),
      child: ContainerW(
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                ButtonW(version.relasetype, onTap: () {}, color: ThemeApp.primaryColor, width: 90),
                TextW("${version.date.day}/${version.date.month}/${version.date.year}"),
                SpaceW(),
                TextW("Download: ${version.downloadnumber}"),
              ],
            ),
            GestureDetector(
              onTap: () async => await launch((gapps) ? version.gappslink : version.vanillalink),
              child: ContainerW(
                Icon(Icons.file_download, color: Colors.white),
                height: 50,
                width: 50,
                color: ThemeApp.primaryColor,
              ),
            )
          ],
        ),
        height: 200,
        width: 350,
        marginLeft: (index != 0),
      ),
    );
  }
}
