import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/models.dart';
import 'package:romlinks_frontend/logic/services/rom_service.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';
import 'package:romlinks_frontend/views/screen/uploaded_screen.dart';
import 'package:romlinks_frontend/views/screen/version_screen.dart';

//! display a list of unverified rom and version
class UnverifiedScreen extends StatelessWidget {
  const UnverifiedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldW(
      PageViewW(
        [
          FutureBuilderW<List<RequestModel>>(
            future: RomService.getRequest(),
            builder: (data) {
              return (data.isNotEmpty) ? RomRequestW(data) : const ErrorW(msg: "No rom request");
            },
          ),
          FutureBuilderW<List<RomModel>>(
            future: RomService.getUnverifiedRom(),
            builder: (data) {
              return (data.isNotEmpty) ? UploadedRomW(data, verify: true) : const ErrorW(msg: "All rom are verified");
            },
          ),
          FutureBuilderW<List<VersionModel>>(
            future: RomService.getUnverifiedVersion(),
            builder: (data) {
              return (data.isNotEmpty) ? UnverifiedVersionW(data, true) : const ErrorW(msg: "All version are verified");
            },
          ),
        ],
        page: 3,
      ),
      auth: true,
    );
  }
}

//! display a list of rom request
class RomRequestW extends StatelessWidget {
  const RomRequestW(this.req, {Key? key}) : super(key: key);
  final List<RequestModel> req;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: ScrollController(),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const TextW("Rom request"),
          const SpaceW(big: true),
          ListView.builder(
            physics: const BouncingScrollPhysics(),
            controller: ScrollController(),
            shrinkWrap: true,
            itemCount: req.length,
            itemBuilder: (BuildContext context, int index) {
              return MaxWidthW(
                GestureDetector(
                  onTap: () => dialogW(DialogW(
                    button1: () async {
                      await RomService.removeRequest(req[index].id);
                      req.removeAt(index);
                      await Future.delayed(const Duration(seconds: 1, milliseconds: 500));
                      Get.close(3);
                    },
                    text1: "Remove request",
                    child: const SizedBox.shrink(),
                    height: 120,
                    width: 450,
                  )),
                  child: ContainerW(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(child: TextW(req[index].codename, singleLine: true), height: 20),
                        SizedBox(child: TextW(req[index].romname + " Android: " + req[index].androidVersion.toString(), singleLine: true), height: 20),
                      ],
                    ),
                    height: 60,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

//!display the unverified version
class UnverifiedVersionW extends StatelessWidget {
  const UnverifiedVersionW(this.version, this.verify, {Key? key}) : super(key: key);
  final List<VersionModel> version;
  final bool verify;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: ScrollController(),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const TextW("Uploaded version"),
          const SpaceW(big: true),
          ListView.builder(
            physics: const BouncingScrollPhysics(),
            controller: ScrollController(),
            shrinkWrap: true,
            itemCount: version.length,
            itemBuilder: (BuildContext context, int index) {
              return MaxWidthW(
                VersionW(
                  version[index],
                  (version[index].gappslink != "") ? true : false,
                  hasUploaded: true,
                  verify: verify,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
