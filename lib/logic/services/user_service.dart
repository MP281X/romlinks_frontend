import 'package:romlinks_frontend/logic/services/http_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  // service url
  static final String url = "http://localhost:9093";

  // create a new user
  static Future<String> signUp({
    required String username,
    required String email,
    required String password,
    required String image,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // make the request
    Map<String, dynamic> response =
        await HttpHandler.post(url + "/user", body: {
      "username": username,
      "email": email,
      "password": password,
      "image": image,
    });

    if (response["token"] != "") {
      prefs.setString("token", response["token"]);
      prefs.setString("username", username);
      prefs.setString("password", password);
    }
    // return the token
    return response["token"] ?? "";
  }

  // edit user perm
  static Future<String> editUserPerm({
    required String username,
    required PermType perm,
    required bool value,
    required String token,
  }) async {
    // select the perm to edit
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
    Map<String, dynamic> response = await HttpHandler.put(
      url + "/user/" + username + "/" + permString + "/" + value.toString(),
      header: {"token": token},
    );

    // return the username of the edited user
    return response["username"] ?? "";
  }

  // log in
  static Future<String> logIn(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> response = await HttpHandler.get(
      url + "/user",
      header: {"username": username, "password": password},
    );
    if (response["token"] != "") {
      prefs.setString("token", response["token"]);
      prefs.setString("username", username);
      prefs.setString("password", password);
    }
    return response["token"] ?? "";
  }

  // return the user data
  static Future<Map<String, dynamic>> userData(String token) async {
    Map<String, dynamic> response = await HttpHandler.get(
      url + "/user",
      header: {"token": token},
    );
    return response;
  }

  static void logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("username");
    prefs.remove("password");
    prefs.remove("token");
  }
}

enum PermType { verified, ban, moderator }
