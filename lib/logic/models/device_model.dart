class DeviceModel {
  const DeviceModel({
    this.codename = "",
    this.name = "",
    this.brand = "",
    this.specs = const Specs(),
    this.bootloaderlinks = const [],
    this.recoverylinks = const [],
    this.gcamlinks = const [],
  });

  final String codename;
  final String name;
  final String brand;
  final Specs specs;
  final List<dynamic> bootloaderlinks;
  final List<dynamic> recoverylinks;
  final List<dynamic> gcamlinks;

  factory DeviceModel.fromMap(Map<String, dynamic> data) => DeviceModel(
        codename: data["codename"] ?? "",
        name: data["name"] ?? "",
        brand: data["brand"] ?? "",
        specs: Specs.fromMap(data["specs"]),
        bootloaderlinks: List<dynamic>.from(data["bootloaderlinks"].map((x) => x)),
        recoverylinks: List<dynamic>.from(data["recoverylinks"].map((x) => x)),
        gcamlinks: List<dynamic>.from(data["gcamlinks"].map((x) => x)),
      );
}

class Specs {
  const Specs({
    this.camera = "",
    this.battery = 0,
    this.processor = "",
  });

  final String camera;
  final int battery;
  final String processor;

  factory Specs.fromMap(Map<String, dynamic> data) => Specs(
        camera: data["camera"] ?? "",
        battery: data["battery"] ?? 0,
        processor: data["processor"] ?? "",
      );
}
