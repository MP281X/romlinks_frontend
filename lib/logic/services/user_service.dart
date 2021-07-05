import 'package:romlinks_frontend/logic/services/http_handler.dart';

class UserService {
  // service url
  static final String url = "http://mp281x.xyz:9093";

  // create a new user
  static Future<String> signUp({
    required String username,
    required String email,
    required String password,
    required String image,
  }) async {
    // make the request
    Map<String, dynamic> response =
        await HttpHandler.post(url + "/user", body: {
      "username": username,
      "email": email,
      "password": password,
      "image": image,
    });
    // return the token
    return response["token"];
  }

  // edit user perm
  static Future<String> editUserPerm(
    String username,
    PermType perm,
    bool value,
    String token,
  ) async {
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
    return response["username"];
  }

  // log in
  static Future<String> logIn(String username, String password) async {
    Map<String, dynamic> response = await HttpHandler.get(
      url + "/user",
      header: {"username": username, "password": password},
    );
    return response["token"];
  }

  // return the user data
  static Future<Map<String, dynamic>> userData(String token) async {
    Map<String, dynamic> response = await HttpHandler.get(
      url + "/user",
      header: {"token": token},
    );
    return response;
  }
}

enum PermType { verified, ban, moderator }
