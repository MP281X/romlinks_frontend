class CommentModel {
  const CommentModel({
    this.romId = "",
    this.codename = "",
    this.username = "",
    this.msg = "",
    this.battery = 0,
    this.performance = 0,
    this.stability = 0,
    this.customization = 0,
  });

  final String romId;
  final String codename;
  final String username;
  final String msg;
  final double battery;
  final double performance;
  final double stability;
  final double customization;

  factory CommentModel.fromMap(Map<String, dynamic> data) => CommentModel(
        romId: data["romid"] ?? "",
        codename: data["codename"] ?? "",
        username: data["username"] ?? "",
        msg: data["msg"] ?? "",
        battery: double.parse(data["battery"].toString()),
        performance: double.parse(data["performance"].toString()),
        stability: double.parse(data["stability"].toString()),
        customization: double.parse(data["customization"].toString()),
      );
}
