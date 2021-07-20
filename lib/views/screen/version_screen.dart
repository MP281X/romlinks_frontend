import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/models/version_model.dart';
import 'package:romlinks_frontend/logic/services/rom_service.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';
import 'package:romlinks_frontend/views/screen/home_screen.dart';
import 'package:romlinks_frontend/views/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionScreen extends StatelessWidget {
  const VersionScreen({required this.codename, required this.romId});
  final String codename;
  final String romId;

  @override
  Widget build(BuildContext context) {
    return ScaffoldW(
      FutureBuilderW<List<VersionModel>>(
        future: RomService.getVersionList(codename: codename, romId: romId),
        builder: (data) {
          List<VersionModel> vanilla = data.where((element) => element.vanillalink != "").toList();
          List<VersionModel> gapps = data.where((element) => element.gappslink != "").toList();

          return PageView(
            controller: new PageController(),
            physics: BouncingScrollPhysics(),
            children: [
              (vanilla.length > 0)
                  ? Column(
                      children: [
                        TextW("Vanilla", big: true),
                        SpaceW(),
                        ListView.builder(
                          controller: new ScrollController(),
                          shrinkWrap: true,
                          itemCount: vanilla.length,
                          itemBuilder: (BuildContext context, int index) => MaxWidthW(VersionW(vanilla[index], false)),
                        ),
                      ],
                    )
                  : ErrorW("No vanilla build"),
              (gapps.length > 0)
                  ? Column(
                      children: [
                        TextW("Gapps", big: true),
                        SpaceW(),
                        ListView.builder(
                          controller: new ScrollController(),
                          shrinkWrap: true,
                          itemCount: gapps.length,
                          itemBuilder: (BuildContext context, int index) => MaxWidthW(VersionW(gapps[index], true)),
                        ),
                      ],
                    )
                  : ErrorW("No gapps build"),
            ],
          );
        },
      ),
    );
  }
}

class VersionW extends StatelessWidget {
  VersionW(this.version, this.gapps);
  final bool gapps;
  final VersionModel version;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => bottomSheetW(
        oneButton: true,
        height: 1000,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [TextW("${version.date.day}/${version.date.month}/${version.date.year}"), TextW(version.relasetype)],
              ),
            ),
            SpaceW(),
            TextW("Changelog", big: true),
            SpaceW(),
            ContainerW(
              ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: version.changelog.length,
                itemBuilder: (BuildContext context, int index) => TextW(version.changelog[index]),
              ),
              width: width,
              height: 200,
            ),
            SpaceW(),
            TextW("Known issue", big: true),
            SpaceW(),
            ContainerW(
              ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: version.error.length,
                itemBuilder: (BuildContext context, int index) => TextW(version.error[index]),
              ),
              width: Get.width,
              height: 200,
            ),
          ],
        ),
        text: "Download",
        onTap: () => launch(gapps ? version.gappslink : version.vanillalink),
      ),
      child: ContainerW(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [TextW("${version.date.day}/${version.date.month}/${version.date.year}"), TextW(version.relasetype)],
        ),
        height: 65,
      ),
    );
  }
}
