import 'package:flutter/material.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';
import 'package:romlinks_frontend/views/theme.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () =>
              FileStorageService.postImage(PhotoCategory.logo, "test.jpg", 11),
          child: ContainerW(
            SizedBox.shrink(),
            height: 100,
            width: 200,
          ),
        ),
      ),
    );
  }
}
