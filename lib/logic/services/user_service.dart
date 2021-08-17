import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/controller.dart';
import 'package:romlinks_frontend/logic/models.dart';
import 'package:romlinks_frontend/logic/services/http_handler.dart';

class UserService {
  //! user service base url
  static final bool local = HttpHandler.local;
  static final String url = (local) ? "http://localhost:9093" : "https://romlinks.user.mp281x.xyz:9093";

  //! create a new user
  static Future<String> signUp({required String username, required String email, required String password}) async {
    // make the request
    Map<String, dynamic> response = await HttpHandler.req(
      url + "/user",
      RequestType.post,
      body: {
        "username": username,
        "email": email,
        "password": password,
      },
    );

    // check if the token is null
    if (response["token"] == null || response["token"] == "") {
      return "";
    }

    return response["token"] ?? "";
  }

  //! log in
  static Future<String> logIn(String username, String password) async {
    // make the request
    Map<String, dynamic> response = await HttpHandler.req(
      url + "/user",
      RequestType.get,
      header: {"username": username, "password": password},
    );

    // check if the token is null
    if (response["token"] == null || response["token"] == "") {
      return "";
    }

    return response["token"] ?? "";
  }

  //! edit user perm
  static Future<void> editUserPerm({required String username, required PermType perm, required bool value}) async {
    // get the user controller
    UserController _userController = Get.find();

    // convert the permtype to a string
    String permString;
    switch (perm) {
      case PermType.verified:
        permString = "verified";
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
      header: {"token": _userController.token},
    );
  }

  //! return the user data
  static Future<UserModel> userData() async {
    // get the user controller
    UserController _userController = Get.find();
    // make the request
    Map<String, dynamic> response = await HttpHandler.req(
      url + "/userData",
      RequestType.get,
      header: {"token": _userController.token},
    );

    // return the user data
    return UserModel.fromMap(response);
  }

  //! save a rom
  static Future<void> saveRom(String romId) async {
    // get the user controller
    UserController _userController = Get.find();
    // make the request
    await HttpHandler.req(
      url + "/saveRom/" + romId,
      RequestType.put,
      header: {"token": _userController.token},
    );
  }
}

enum PermType { verified, ban, moderator }
