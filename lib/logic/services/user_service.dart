import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/services/http_handler.dart';
import 'package:romlinks_frontend/logic/services/user_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  //! user service base url
  static final String url = "http://localhost:9093";

  //! create a new user
  static Future<void> signUp({required String username, required String email, required String password, required String image}) async {
    // create an instance of the shared
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // make the request
    Map<String, dynamic> response = await HttpHandler.req(
      url + "/user",
      RequestType.post,
      body: {
        "username": username,
        "email": email,
        "password": password,
        "image": image,
      },
    );

    // check if the token is null
    if (response["token"] == null || response["token"] == "") {
      return;
    }

    // get the user controller
    UserController userController = Get.find();

    // set the logger propriety to false
    userController.isLogged.value = true;

    // save the token and the user info
    prefs.setString("token", response["token"]);
    prefs.setString("username", username);
    prefs.setString("password", password);

    // return true
  }

  //! edit user perm
  static Future<void> editUserPerm({required String username, required PermType perm, required bool value, required String token}) async {
    // convert the permtype to a string
    String permString;
    switch (perm) {
      case PermType.verified:
        permString = "dev.verified";
        break;
      case PermType.ban:
        permString = "ban";
        break;
      case PermType.moderator:
        permString = "moderator";
        break;
      default:
        permString = "";
    }

    // make the request
    await HttpHandler.req(
      url + "/user/" + username + "/" + permString + "/" + value.toString(),
      RequestType.put,
      header: {"token": token},
    );
  }

  //! log in
  static Future<void> logIn(String username, String password) async {
    // create an instance of the shared preference
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // make the request
    Map<String, dynamic> response = await HttpHandler.req(
      url + "/user",
      RequestType.get,
      header: {"username": username, "password": password},
    );

    // check if the token is null
    if (response["token"] == null || response["token"] == "") {
      return;
    }
    // get the user controller
    UserController userController = Get.find();

    // set the logger propriety to true
    userController.isLogged.value = true;

    // save the user info and the token
    prefs.setString("token", response["token"]);
    prefs.setString("username", username);
    prefs.setString("password", password);
  }

  //! return the user data
  static Future<Map<String, dynamic>> userData(String token) async {
    // make the request
    Map<String, dynamic> response = await HttpHandler.req(
      url + "/user",
      RequestType.get,
      header: {"token": token},
    );

    // return the user data
    return response;
  }

  //! log out a user
  static Future<void> logOut() async {
    // create an instance of the shared preference
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // get the user controller
    UserController userController = Get.find();

    // set the logger propriety to false
    userController.isLogged.value = false;

    // remove the user info and the token
    prefs.remove("username");
    prefs.remove("password");
    prefs.remove("token");
  }
}

enum PermType { verified, ban, moderator }
