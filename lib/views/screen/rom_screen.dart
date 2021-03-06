import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/controller.dart';
import 'package:romlinks_frontend/logic/models.dart';
import 'package:romlinks_frontend/logic/services/device_service.dart';
import 'package:romlinks_frontend/logic/services/filestorage_service.dart';
import 'package:romlinks_frontend/logic/services/rom_service.dart';
import 'package:romlinks_frontend/logic/services/user_service.dart';
import 'package:romlinks_frontend/views/screen/comment_screen.dart';
import 'package:romlinks_frontend/views/screen/version_screen.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';
import 'package:romlinks_frontend/views/theme.dart';
import 'package:url_launcher/url_launcher.dart';

//! display the info of a rom
class RomScreen extends StatelessWidget {
  const RomScreen(this.romData, {this.codename, this.heroTag, this.uploadedVersion = false, Key? key}) : super(key: key);
  final RomModel romData;
  final String? codename;
  final String? heroTag;
  final bool uploadedVersion;

  @override
  Widget build(BuildContext context) {
    return ScaffoldW(
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SpaceW(),
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
          const SpaceW(),
          TextW(romData.romname, size: 45, singleLine: true),
          const SpaceW(),
          TextW("Android ${romData.androidversion}", big: true),
          const SpaceW(big: true),
          TextW(romData.description),
          const SpaceW(big: true),
          ScreenshotW(romData.screenshot!),
          if (romData.review.revNum > 0) ReviewW(romData.review, romData.id),
          const SpaceW(),
          if (codename != null && codename != "") ButtonW("Download", onTap: () => Get.to(VersionScreen(codename: codename!, romId: romData.id))),
          if (uploadedVersion) ButtonW("Uploaded Version", onTap: () => Get.to(VersionScreen(codename: "*", romId: romData.id, hasUploaed: true))),
          const SpaceW(),
          const TextW("Uploaded by", size: 25),
          const SpaceW(),
          UserW(romData.uploadedby),
          const SpaceW(),
          LinkW(romData.link.obs, false),
        ],
      ),
      button: (Get.find<UserController>().token != "")
          ? SizedBox(
              height: 150,
              width: 70,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => UserService.saveRom(romData.id),
                    child: const ContainerW(
                      Icon(Icons.favorite, size: 25),
                      padding: EdgeInsets.zero,
                      marginRight: false,
                      height: 50,
                      width: 50,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => dialogW(
                      DialogW(
                        tag: "romButton",
                        text2: "Add review",
                        button2: () async {
                          Get.close(1);
                          dialogW(
                            DialogW(
                              text1: "Add review",
                              button1: () => Get.find<AddReviewController>().addReview(),
                              button2: () => Get.close(1),
                              child: AddReviewW(romId: romData.id, codename: codename ?? ""),
                              height: 420,
                              width: 400,
                              alignment: Alignment.center,
                            ),
                          );
                          await Future.delayed(const Duration(seconds: 1));
                        },
                        text1: "Add version",
                        button1: () => Get.toNamed("/addVersion/" + romData.id),
                        child: TextW("${romData.romname} - ${romData.androidversion}", singleLine: true),
                        height: 170,
                        width: 400,
                      ),
                    ),
                    child: const ContainerW(
                      Icon(Icons.add_rounded, size: 25),
                      padding: EdgeInsets.zero,
                      marginRight: false,
                      height: 50,
                      width: 50,
                      tag: "romButton",
                    ),
                  ),
                ],
              ),
            )
          : null,
      scroll: true,
    );
  }
}

//! display the review of the rom
class ReviewW extends StatelessWidget {
  const ReviewW(this.rev, this.romId, {Key? key}) : super(key: key);
  final Review rev;
  final String romId;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 350,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const TextW("Review", big: true),
                GestureDetector(
                  onTap: () => Get.to(CommentScreen(romId)),
                  child: const Icon(Icons.arrow_right_rounded, color: Colors.white, size: 50),
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
                  children: const [
                    TextW("Performance:"),
                    TextW("Stability:"),
                    TextW("Customization:"),
                    TextW("Battery:"),
                    TextW("Review:"),
                  ],
                ),
                const SizedBox(width: 30),
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
  final RxString codename;
  var msg = "".obs;
  var battery = 1.0.obs;
  var performance = 1.0.obs;
  var stability = 1.0.obs;
  var customization = 1.0.obs;
  var codenameSuggestion = [].obs;

  void getSuggestion(String x) async {
    codename.value = x;
    if (codename.value != "") codenameSuggestion.value = await DeviceService.searchDeviceName(codename.value);
  }

  void addReview() async {
    if (romId != "" && codename.value != "") {
      await RomService.addComment(
        romId: romId,
        codename: codename.value,
        msg: msg.value,
        battery: battery.value,
        performance: performance.value,
        stability: stability.value,
        customization: customization.value,
      );
      await Future.delayed(const Duration(seconds: 1, milliseconds: 300));
      Get.close(2);
    } else {
      snackbarW("Error", "Enter all the value");
      await Future.delayed(const Duration(seconds: 1, milliseconds: 300));
      Get.close(2);
    }
  }
}

class AddReviewW extends StatelessWidget {
  const AddReviewW({required this.romId, required this.codename, Key? key}) : super(key: key);
  final String romId;
  final String codename;

  @override
  Widget build(BuildContext context) {
    final AddReviewController controller = Get.put(AddReviewController(romId, codename.obs));
    final TextEditingController codenameController = TextEditingController(text: codename);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  TextW("Performance:"),
                  TextW("Stability:"),
                  TextW("Customization:"),
                  TextW("Battery:"),
                ],
              ),
              const SizedBox(width: 20),
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
          const SpaceW(),
          TextFieldW("Comment", onChanged: (x) => controller.msg.value = x),
          TextFieldW("Codename", onChanged: controller.getSuggestion, controller: codenameController),
          SuggestionW(
              suggestion: controller.codenameSuggestion,
              onTap: (x) {
                controller.codename.value = x;
                codenameController.text = x;
              }),
        ],
      ),
    );
  }
}

class StarW extends StatelessWidget {
  const StarW(this.value, {Key? key}) : super(key: key);
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

//! display a list of link
class LinkW extends StatelessWidget {
  const LinkW(this.links, this.editLink, {Key? key}) : super(key: key);
  final RxList<dynamic> links;
  final bool editLink;

  @override
  Widget build(BuildContext context) {
    IconData selectIcon(int index) {
      String link = links[index].toString();
      if (link.contains("github")) {
        return AppIcons.github_circled;
      } else if (link.contains("twitter")) {
        return AppIcons.twitter;
      } else if (link.contains("t.me")) {
        return AppIcons.telegram_plane;
      } else {
        return Icons.language;
      }
    }

    return SizedBox(
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<Widget>.generate(
            links.length,
            (index) => GestureDetector(
              onTap: () => editLink ? links.removeAt(index) : launch(links[index]),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Icon(selectIcon(index), color: Colors.white),
              ),
            ),
          ),
        ),
      ),
      height: 40,
      width: 1000,
    );
  }
}
