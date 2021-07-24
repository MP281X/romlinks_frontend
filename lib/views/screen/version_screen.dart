import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/models.dart';
import 'package:romlinks_frontend/logic/services/rom_service.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';
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
                  : ErrorW(msg: "No vanilla build"),
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
                  : ErrorW(msg: "No gapps build"),
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
      onTap: () => dialogW(
        DialogW(
          button1: () => launch(gapps ? version.gappslink : version.vanillalink),
          text1: "Add version",
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    TextW("${version.date.day}/${version.date.month}/${version.date.year}", singleLine: true),
                    Spacer(),
                    ChipW(
                      text: version.relasetype,
                      color: ThemeApp.secondaryColor,
                      height: 36,
                      width: 40 * 2.2,
                    ),
                    (width > 400)
                        ? ChipW(
                            text: version.official ? "Official" : "Unofficial",
                            color: ThemeApp.primaryColor,
                            height: 36,
                            width: 40 * 2.2,
                          )
                        : Icon(
                            version.official ? Icons.gpp_good_rounded : Icons.gpp_bad_rounded,
                            color: Colors.white,
                          )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Divider(color: Colors.white, thickness: 1),
              ),
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
              SizedBox(height: 60),
            ],
          ),
          height: 1000,
          width: context.width,
        ),
      ),
      child: ContainerW(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: TextW("${version.date.day}/${version.date.month}/${version.date.year}", singleLine: true)),
            Expanded(child: SizedBox()),
            Expanded(
              child: ChipW(
                text: version.relasetype,
                color: ThemeApp.secondaryColor,
                height: 36,
                width: 40 * 2.2,
              ),
            ),
            (width > 400)
                ? Expanded(
                    child: ChipW(
                      text: version.official ? "Official" : "Unofficial",
                      color: ThemeApp.primaryColor,
                      height: 36,
                      width: 40 * 2.2,
                    ),
                  )
                : Expanded(
                    child: Icon(
                      version.official ? Icons.gpp_good_rounded : Icons.gpp_bad_rounded,
                      color: Colors.white,
                    ),
                  )
          ],
        ),
        height: 65,
      ),
    );
  }
}
