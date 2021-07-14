import 'package:romlinks_frontend/logic/models/rom_model.dart';
import 'package:romlinks_frontend/logic/models/version_model.dart';

class RomVersionModel {
  RomVersionModel({
    this.rom = const <RomModel>[],
    this.version = const <VersionModel>[],
  });

  final List<RomModel> rom;
  final List<VersionModel> version;

  factory RomVersionModel.fromMap(Map<String, dynamic> data) => RomVersionModel(
        rom: List<RomModel>.from(data["rom"].map((x) => RomModel.fromMap(x))),
        version: List<VersionModel>.from(data["version"].map((x) => VersionModel.fromMap(x))),
      );
}
