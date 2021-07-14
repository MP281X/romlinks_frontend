import 'package:romlinks_frontend/logic/models/user_model.dart';
import 'package:romlinks_frontend/logic/services/http_handler.dart';

class UserService {
  //! user service base url
  static final bool local = true;
  static final String url = (local) ? "http://localhost:9093" : "https://romlinks.user.mp281x.xyz";

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

  //! return the user data
  static Future<UserModel> userData(String token) async {
    // make the request
    Map<String, dynamic> response = await HttpHandler.req(
      url + "/userData",
      RequestType.get,
      header: {"token": token},
    );

    // return the user data
    return UserModel.fromMap(response);
  }
}

enum PermType { verified, ban, moderator }
