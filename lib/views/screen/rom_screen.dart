import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/models/rom_model.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';
import 'package:romlinks_frontend/views/screen/saveImage_screen.dart';
import 'package:romlinks_frontend/views/widget/custom_widget.dart';
import 'package:romlinks_frontend/views/widget/image_widget.dart';
import 'package:romlinks_frontend/views/widget/scaffold_widget.dart';

//! display the info of a rom
class RomScreen extends StatelessWidget {
  const RomScreen(this.romData);
  final RomModel romData;

  @override
  Widget build(BuildContext context) {
    return ScaffoldW(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          ScreenshotW(romData.screenshot),
          ReviewW(romData.review),
          SpaceW(big: true),
          TextW("Vanilla Build", big: true),
          SpaceW(),
          ButtonW("Upload rom", onTap: () => Get.to(SaveImageScreen(category: PhotoCategory.logo, fileName: "a", aspectRatio: 9 / 16)))
        ],
      ),
    );
  }
}

//! display a list of screenshot
class ScreenshotW extends StatelessWidget {
  const ScreenshotW(this.image);
  final List<String> image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SpaceW(big: true),
        TextW("Screenshot", big: true),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: image.length,
            itemBuilder: (BuildContext context, int index) {
              return AspectRatio(
                aspectRatio: 9 / 16,
                child: ImageW(
                  first: (index == 0),
                  category: PhotoCategory.screenshot,
                  name: image[index],
                ),
              );
            },
          ),
        ),
      ],
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
