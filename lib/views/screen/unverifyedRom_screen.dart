import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/models.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';
import 'package:romlinks_frontend/logic/services/rom_service.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';

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
                          onTap: () => dialogW(
                            DialogW(
                              button1: () {
                                RomService.verifyRom(data[index].id);
                                Get.close(1);
                              },
                              text1: "Add version",
                              child: TextW(data[index].romname, big: true, singleLine: true),
                              height: 150,
                              width: 400,
                            ),
                          ),
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
                                      TextW(data[index].romname, singleLine: true),
                                      SizedBox(height: 5),
                                      TextW("Android ${data[index].androidversion}", singleLine: true),
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
              : ErrorW(msg: "All rom are verified");
        },
      ),
      auth: true,
    );
  }
}
