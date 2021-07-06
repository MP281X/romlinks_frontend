import 'package:get/get.dart';

class SaveImageLink extends GetxController {
  List<String> imageLinks = [];

  void addLink(String link) {
    imageLinks.add(link);
    update();
  }

  void clearLink() {
    imageLinks.clear();
    update();
  }
}
