class DeviceModel {
  DeviceModel({
    required this.codename,
    required this.name,
    required this.photo,
    required this.brand,
    required this.specs,
    required this.bootloaderlinks,
    required this.recoverylinks,
    required this.gcamlinks,
  });

  final String codename;
  final String name;
  final List<String> photo;
  final String brand;
  final Specs specs;
  final List<dynamic> bootloaderlinks;
  final List<dynamic> recoverylinks;
  final List<dynamic> gcamlinks;

  factory DeviceModel.fromMap(Map<String, dynamic> data) => DeviceModel(
        codename: data["codename"],
        name: data["name"],
        photo: List<String>.from(data["photo"].map((x) => x)),
        brand: data["brand"],
        specs: Specs.fromMap(data["specs"]),
        bootloaderlinks: List<dynamic>.from(data["bootloaderlinks"].map((x) => x)),
        recoverylinks: List<dynamic>.from(data["recoverylinks"].map((x) => x)),
        gcamlinks: List<dynamic>.from(data["gcamlinks"].map((x) => x)),
      );
}

class Specs {
  Specs({
    required this.camera,
    required this.battery,
    required this.processor,
  });

  final String camera;
  final int battery;
  final String processor;

  factory Specs.fromMap(Map<String, dynamic> data) => Specs(
        camera: data["camera"],
        battery: data["battery"],
        processor: data["processor"],
      );
}
