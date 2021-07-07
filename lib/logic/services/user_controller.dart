import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  var isLogged = false.obs;

  @override
  void onInit() {
    super.onInit();
    autoChangeToken();
  }

  void autoChangeToken() async {
    while (true) {
      generateToken();
      await Future.delayed(Duration(minutes: 20));
    }
  }

  void generateToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("username") ?? "";
    String password = prefs.getString("password") ?? "";
    if (username != "" && password != "") {
      await UserService.logIn(username, password);
      isLogged.value = true;
      update();
    }
  }
}
