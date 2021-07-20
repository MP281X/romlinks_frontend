import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/models/rom_model.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';
import 'package:romlinks_frontend/logic/services/rom_service.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';
import 'package:romlinks_frontend/views/screen/rom_screen.dart';

class UnverifiedRomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScaffoldW(
      FutureBuilderW<List<RomModel>>(
        future: RomService.getUnverifiedRom(),
        builder: (data) {
          return (data.length > 0)
              ? SizedBox.expand(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return MaxWidthW(
                        GestureDetector(
                          onTap: () => bottomSheetW(
                              child: TextW(data[index].romname, big: true, maxLine: 1),
                              text: "Approve",
                              onTap: () {
                                RomService.verifyRom(data[index].id);
                                Get.close(1);
                              },
                              scrollable: false,
                              height: 150,
                              text2: "View rom data",
                              onTap2: () => Get.to(RomScreen(data[index]))),
                          child: ContainerW(
                            Row(
                              children: [
                                SizedBox(
                                  height: 70,
                                  width: 70,
                                  child: ImageW(category: PhotoCategory.logo, name: data[index].logo),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextW(data[index].romname, maxLine: 1),
                                      SizedBox(height: 5),
                                      TextW("Android ${data[index].androidversion}", maxLine: 1),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : ErrorW("All rom are verified");
        },
      ),
      auth: true,
    );
  }
}
