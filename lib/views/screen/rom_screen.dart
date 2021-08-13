import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/controller.dart';
import 'package:romlinks_frontend/logic/models.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';
import 'package:romlinks_frontend/logic/services/rom_service.dart';
import 'package:romlinks_frontend/views/screen/comment_screen.dart';
import 'package:romlinks_frontend/views/screen/version_screen.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';
import 'package:romlinks_frontend/views/theme.dart';

//! display the info of a rom
class RomScreen extends StatelessWidget {
  const RomScreen(this.romData, {this.codename, this.heroTag});
  final RomModel romData;
  final String? codename;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    return ScaffoldW(
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SpaceW(),
          Center(
            child: SizedBox(
              child: ImageW(
                category: PhotoCategory.logo,
                name: romData.logo,
                heroTag: heroTag,
              ),
              height: 200,
              width: 200,
            ),
          ),
          SpaceW(),
          TextW(romData.romname, size: 45, singleLine: true),
          SpaceW(),
          TextW("Android ${romData.androidversion}", big: true),
          SpaceW(big: true),
          TextW(romData.description),
          SpaceW(big: true),
          ScreenshotW(romData.screenshot!),
          ReviewW(romData.review, romData.id),
          SpaceW(),
          if (codename != null) ButtonW("Download", onTap: () => Get.to(VersionScreen(codename: codename!, romId: romData.id))),
          SpaceW(),
          SizedBox(child: Divider(color: Colors.white, thickness: 2), width: 130),
          SpaceW(),
          SizedBox(
            height: 100,
            width: 100,
            child: Stack(
              children: [
                SizedBox(
                  child: ImageW(category: PhotoCategory.profile, name: romData.uploadedby, profileIcon: true),
                  height: 100,
                  width: 100,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    Icons.verified,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          SpaceW(),
          TextW(romData.uploadedby, size: 25),
        ],
      ),
      button: (Get.find<UserController>().token != "" && codename != null && codename != "")
          ? GestureDetector(
              onTap: () => dialogW(
                DialogW(
                  tag: "romButton",
                  text1: "Add review",
                  button1: () {
                    Get.close(1);
                    dialogW(
                      DialogW(
                        text1: "Add review",
                        button1: () => Get.find<AddReviewController>().addReview(),
                        button2: () => Get.close(2),
                        child: AddReviewW(romId: romData.id, codename: codename ?? ""),
                        height: 320,
                        width: 400,
                        alignment: Alignment.center,
                      ),
                    );
                  },
                  text2: "Add version",
                  button2: () => Get.toNamed("/addVersion/" + romData.id),
                  child: TextW("${romData.romname} - ${romData.androidversion}", singleLine: true),
                  height: 170,
                  width: 400,
                ),
              ),
              child: ContainerW(
                Icon(Icons.add_rounded, color: Colors.white, size: 25),
                padding: EdgeInsets.zero,
                marginRight: false,
                height: 50,
                width: 50,
                color: ThemeApp.accentColor,
                tag: "romButton",
              ),
            )
          : null,
      scroll: true,
    );
  }
}

//! display the review of the rom
class ReviewW extends StatelessWidget {
  const ReviewW(this.rev, this.romId);
  final Review rev;
  final String romId;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 350,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextW("Review", big: true),
                GestureDetector(
                  onTap: () => Get.to(CommentScreen(romId)),
                  child: Icon(Icons.arrow_right_rounded, color: Colors.white, size: 50),
                ),
              ],
            ),
          ),
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
                    TextW("Review:"),
                  ],
                ),
                SizedBox(width: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(children: List<Widget>.generate(5, (index) => Icon((index >= rev.performance.round()) ? Icons.star_outline_rounded : Icons.star_rounded, color: Colors.white))),
                    Row(children: List<Widget>.generate(5, (index) => Icon((index >= rev.stability.round()) ? Icons.star_outline_rounded : Icons.star_rounded, color: Colors.white))),
                    Row(children: List<Widget>.generate(5, (index) => Icon((index >= rev.customization.round()) ? Icons.star_outline_rounded : Icons.star_rounded, color: Colors.white))),
                    Row(children: List<Widget>.generate(5, (index) => Icon((index >= rev.battery.round()) ? Icons.star_outline_rounded : Icons.star_rounded, color: Colors.white))),
                    TextW(" " + rev.revNum.toString()),
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

class AddReviewController extends GetxController {
  AddReviewController(this.romId, this.codename);
  String romId;
  String codename;
  var msg = "".obs;
  var battery = 1.0.obs;
  var performance = 1.0.obs;
  var stability = 1.0.obs;
  var customization = 1.0.obs;

  void addReview() async {
    if (romId != "" && codename != "") {
      await RomService.addComment(
        romId: romId,
        codename: codename,
        msg: msg.value,
        battery: battery.value,
        performance: performance.value,
        stability: stability.value,
        customization: customization.value,
      );
      await Future.delayed(Duration(seconds: 1));
      Get.close(3);
    }
  }
}

class AddReviewW extends StatelessWidget {
  AddReviewW({required this.romId, required this.codename});
  final String romId;
  final String codename;

  @override
  Widget build(BuildContext context) {
    final AddReviewController controller = Get.put(AddReviewController(romId, codename));

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
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
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  StarW(controller.performance),
                  StarW(controller.stability),
                  StarW(controller.customization),
                  StarW(controller.battery),
                ],
              ),
            ],
          ),
          SpaceW(),
          TextFieldW("Comment", onChanged: (x) => controller.msg.value = x),
        ],
      ),
    );
  }
}

class StarW extends StatelessWidget {
  StarW(this.value);
  final RxDouble value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List<Widget>.generate(
        5,
        (index) => GestureDetector(
          onTap: () => value.value = index.toDouble() + 1,
          child: Obx(
            () => Icon(
              (index >= value.value) ? Icons.star_outline_rounded : Icons.star_rounded,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
