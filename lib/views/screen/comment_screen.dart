import 'package:flutter/material.dart';
import 'package:romlinks_frontend/logic/models.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';
import 'package:romlinks_frontend/logic/services/rom_service.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';
import 'package:romlinks_frontend/views/theme.dart';

class CommentScreen extends StatelessWidget {
  const CommentScreen(this.romId);
  final String romId;
  @override
  Widget build(BuildContext context) {
    return ScaffoldW(
      FutureBuilderW<List<CommentModel>>(
        future: RomService.getComment(romId),
        builder: (data) {
          data = data.where((element) => element.msg != "").toList();
          return (data.length > 0)
              ? SingleChildScrollView(
                  child: MaxWidthW(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextW("Review", big: true),
                        SpaceW(big: true),
                        ListView.builder(
                          controller: new ScrollController(),
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            double generalReview = (data[index].battery + data[index].performance + data[index].stability + data[index].customization) / 4;
                            return ContainerW(
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SpaceW(big: true),
                                      TextW(data[index].codename, singleLine: true),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Divider(
                                          color: Colors.white,
                                          thickness: 1,
                                        ),
                                      ),
                                      TextW(data[index].username, singleLine: true),
                                      SpaceW(),
                                      SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: ImageW(category: PhotoCategory.profile, name: data[index].username),
                                      ),
                                      SpaceW(),
                                    ],
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    flex: 5,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        SpaceW(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: List<Widget>.generate(5, (index) => Icon((index >= generalReview.round()) ? Icons.star_outline_rounded : Icons.star_rounded, color: Colors.white)),
                                        ),
                                        Expanded(
                                          child: ContainerW(
                                            SingleChildScrollView(
                                              child: TextW(data[index].msg),
                                              physics: BouncingScrollPhysics(),
                                            ),
                                            color: ThemeApp.primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              height: 190,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )
              : Center(child: ErrorW(msg: "No review found for this rom"));
        },
      ),
      scroll: true,
    );
  }
}
