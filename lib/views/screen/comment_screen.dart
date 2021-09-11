import 'package:flutter/material.dart';
import 'package:romlinks_frontend/logic/models.dart';
import 'package:romlinks_frontend/logic/services/filestorage_service.dart';
import 'package:romlinks_frontend/logic/services/rom_service.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';
import 'package:romlinks_frontend/views/theme.dart';

class CommentScreen extends StatelessWidget {
  const CommentScreen(this.romId, {Key? key}) : super(key: key);
  final String romId;
  @override
  Widget build(BuildContext context) {
    return FutureBuilderW<List<CommentModel>>(
      future: RomService.getComment(romId),
      builder: (data) {
        data = data.where((element) => element.msg != "").toList();
        return (data.isNotEmpty)
            ? ScaffoldW(
                SingleChildScrollView(
                  child: MaxWidthW(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const TextW("Review", big: true),
                        const SpaceW(big: true),
                        ListView.builder(
                          controller: ScrollController(),
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            double generalReview = (data[index].battery + data[index].performance + data[index].stability + data[index].customization) / 4;
                            return ContainerW(
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const SpaceW(big: true),
                                      TextW(data[index].codename, singleLine: true),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        child: Divider(
                                          color: Colors.white,
                                          thickness: 1,
                                        ),
                                      ),
                                      TextW(data[index].username, singleLine: true),
                                      const SpaceW(),
                                      SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: ImageW(category: PhotoCategory.profile, name: data[index].username),
                                      ),
                                      const SpaceW(),
                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    flex: 5,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        const SpaceW(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: List<Widget>.generate(5, (index) => Icon((index >= generalReview.round()) ? Icons.star_outline_rounded : Icons.star_rounded, color: Colors.white)),
                                        ),
                                        Expanded(
                                          child: ContainerW(
                                            SingleChildScrollView(
                                              child: TextW(data[index].msg),
                                              physics: const BouncingScrollPhysics(),
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
                ),
                scroll: true,
              )
            : ScaffoldW(const Center(child: ErrorW(msg: "No review found for this rom")));
      },
    );
  }
}
