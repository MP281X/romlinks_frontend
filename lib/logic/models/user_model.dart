class UserModel {
  // constructor
  const UserModel({
    this.userId = "",
    this.username = "",
    this.email = "",
    this.savedRom = const [],
    this.link = const [],
    this.verified = false,
    this.moderator = false,
  });

  // serialize the map
  factory UserModel.fromMap(Map<String, dynamic> data) => UserModel(
        userId: data["_id"],
        username: data["username"],
        email: data["email"],
        savedRom: data["savedRom"],
        link: data["dev"]["link"],
        verified: data["dev"]["verified"],
        moderator: data["moderator"],
      );

  // variable
  final String userId;
  final String username;
  final String email;
  final List savedRom;
  final List link;
  final bool verified;
  final bool moderator;
}
