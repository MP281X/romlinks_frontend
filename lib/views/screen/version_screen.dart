import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/models.dart';
import 'package:romlinks_frontend/logic/services/rom_service.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';
import 'package:romlinks_frontend/views/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionScreen extends StatelessWidget {
  const VersionScreen({required this.codename, required this.romId, this.hasUploaed = false, Key? key}) : super(key: key);
  final String codename;
  final String romId;
  final bool hasUploaed;

  @override
  Widget build(BuildContext context) {
    return ScaffoldW(
      FutureBuilderW<List<VersionModel>>(
        future: RomService.getVersionList(codename: codename, romId: romId),
        builder: (data) {
          List<VersionModel> vanilla = data.where((element) => element.vanillalink != "").toList();
          vanilla.sort((a, b) => a.codename.compareTo(b.codename));
          List<VersionModel> gapps = data.where((element) => element.gappslink != "").toList();
          gapps.sort((a, b) => a.codename.compareTo(b.codename));

          return PageViewW([
            (vanilla.isNotEmpty)
                ? Column(
                    children: [
                      const TextW("Vanilla", big: true),
                      const SpaceW(),
                      ListView.builder(
                        controller: ScrollController(),
                        shrinkWrap: true,
                        itemCount: vanilla.length,
                        itemBuilder: (BuildContext context, int index) => MaxWidthW(VersionW(vanilla[index], false, hasUploaded: hasUploaed)),
                      ),
                    ],
                  )
                : const ErrorW(msg: "No vanilla build"),
            (gapps.isNotEmpty)
                ? Column(
                    children: [
                      const TextW("Gapps", big: true),
                      const SpaceW(),
                      ListView.builder(
                        controller: ScrollController(),
                        shrinkWrap: true,
                        itemCount: gapps.length,
                        itemBuilder: (BuildContext context, int index) => MaxWidthW(VersionW(gapps[index], true, hasUploaded: hasUploaed)),
                      ),
                    ],
                  )
                : const ErrorW(msg: "No gapps build"),
          ]);
        },
      ),
    );
  }
}

class VersionW extends StatelessWidget {
  const VersionW(this.version, this.gapps, {this.hasUploaded = false, this.verify = false, Key? key}) : super(key: key);
  final bool gapps;
  final VersionModel version;
  final bool hasUploaded;
  final bool verify;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => dialogW(
        DialogW(
          text1: "Download",
          button1: () => launch(gapps ? version.gappslink : version.vanillalink),
          text2: verify ? "Approve" : null,
          button2: verify
              ? () {
                  RomService.verifyVersion(version.id);
                  Get.close(1);
                }
              : null,
          text3: hasUploaded ? "Delete version" : null,
          button3: hasUploaded
              ? () async {
                  RomService.deleteVersion(version.id);
                  await Future.delayed(const Duration(seconds: 1, milliseconds: 300));
                  Get.close(3);
                }
              : null,
          child: Column(
            children: [
              Padding(padding: (width > 400) ? const EdgeInsets.all(5.0) : EdgeInsets.zero, child: VersionInfoW(version)),
              if (version.changelog.isNotEmpty) const TextW("Changelog", big: true),
              if (version.changelog.isNotEmpty) const SpaceW(),
              if (version.changelog.isNotEmpty)
                ContainerW(
                  ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: version.changelog.length,
                    itemBuilder: (BuildContext context, int index) => TextW(version.changelog[index]),
                    separatorBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: Divider(color: Colors.white, thickness: .5),
                    ),
                  ),
                  width: width,
                  height: (version.error.isNotEmpty) ? 200 : 400,
                ),
              if (version.error.isNotEmpty) const SpaceW(),
              if (version.error.isNotEmpty) const TextW("Notes", big: true),
              if (version.error.isNotEmpty) const SpaceW(),
              if (version.error.isNotEmpty)
                ContainerW(
                  ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: version.error.length,
                    itemBuilder: (BuildContext context, int index) => TextW(version.error[index]),
                    separatorBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: Divider(color: Colors.white, thickness: .5),
                    ),
                  ),
                  width: Get.width,
                  height: (version.changelog.isNotEmpty) ? 200 : 400,
                ),
              const SpaceW(),
              const TextW("Uploaded by", size: 25),
              const SpaceW(),
              UserW(version.uploadedBy),
              const SpaceW(),
              const SizedBox(width: 170, child: Divider(color: Colors.white, thickness: .5)),
              const SpaceW(),
              TextW("Device: " + version.codename),
              TextW("Version: " + version.versionNum),
              SizedBox(height: !hasUploaded ? 70 : 100),
            ],
          ),
          height: 1000,
          width: 1000,
        ),
      ),
      child: ContainerW(VersionInfoW(version), height: 65),
    );
  }
}

class VersionInfoW extends StatelessWidget {
  const VersionInfoW(this.version, {Key? key}) : super(key: key);
  final VersionModel version;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Row(
      children: [
        SizedBox(
          child: TextW("${version.date.day}/${version.date.month}/${version.date.year}", singleLine: true),
          height: (width > 400) ? 30 : 25,
        ),
        const Spacer(),
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
                size: 25,
              )
      ],
    );
  }
}
