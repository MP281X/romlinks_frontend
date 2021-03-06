import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/models.dart';
import 'package:romlinks_frontend/logic/services/user_service.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

//! log in and keep the user token
class UserController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    autoChangeToken();
  }

  // shared perference
  late SharedPreferences prefs;

  // user variable
  var isLogged = false.obs;
  String token = "";
  var userData = const UserModel().obs;

  //! log in a user
  Future<void> logIn(String username, String password, {bool autoLogOut = false}) async {
    // generate the token
    String token = await UserService.logIn(username, password);

    // check if the token is null
    if (token == "") {
      if (autoLogOut) logOut();
      return;
    }

    // set the user variable
    this.token = token;
    isLogged.value = true;
    userData.value = await UserService.userData();

    // save the user data for future token generation
    prefs.setString("username", username);
    prefs.setString("password", password);
  }

  //! register a new user
  Future<void> signUp(String username, String password, String email) async {
    // generate the token
    String token = await UserService.signUp(username: username, email: email, password: password);

    // check if the token is null
    if (token == "") {
      return;
    }

    // set the user variable
    this.token = token;
    isLogged.value = true;
    userData.value = await UserService.userData();

    // save the user data for future token generation
    prefs.setString("username", username);
    prefs.setString("password", password);
  }

  //! log out a user
  Future<void> logOut() async {
    // set the logger propriety to false
    isLogged.value = false;
    token = "";
    userData.value = const UserModel();

    // remove the user info and the token
    prefs.remove("username");
    prefs.remove("password");
    Get.offAllNamed("/");
    snackbarW("Auth", "Logged out");
  }

  //! generate a new token
  void autoChangeToken() async {
    while (true) {
      String username = prefs.getString("username") ?? "";
      String password = prefs.getString("password") ?? "";
      if (username != "" && password != "") await logIn(username, password, autoLogOut: true);
      await Future.delayed(const Duration(minutes: 20));
    }
  }
}
