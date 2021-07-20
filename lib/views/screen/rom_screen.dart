import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/models/rom_model.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';
import 'package:romlinks_frontend/views/screen/version_screen.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';

//! display the info of a rom
class RomScreen extends StatelessWidget {
  const RomScreen(this.romData, {this.codename});
  final RomModel romData;
  final String? codename;

  @override
  Widget build(BuildContext context) {
    return ScaffoldW(
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SpaceW(),
          Center(
            child: SizedBox(
              child: ImageW(category: PhotoCategory.logo, name: romData.logo),
              height: 200,
              width: 200,
            ),
          ),
          SpaceW(),
          TextW(romData.romname, size: 45, maxLine: 1),
          SpaceW(),
          TextW("Android ${romData.androidversion}", big: true),
          SpaceW(big: true),
          TextW(romData.description),
          SpaceW(big: true),
          ScreenshotW(romData.screenshot),
          ReviewW(romData.review),
          SpaceW(),
          if (codename != null) ButtonW("Download", onTap: () => Get.to(VersionScreen(codename: codename!, romId: romData.id))),
          SizedBox(height: 30),
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
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Column(
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
      ),
    );
  }
}
