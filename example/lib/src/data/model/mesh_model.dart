// import 'package:json_annotation/json_annotation.dart';
// part 'mesh_model.g.dart';

// @JsonSerializable(explicitToJson: true)
// class Header {
//   String meshUUID;
//   String meshName;
//   String version;
//   DateTime? timestamp;

//   Header({
//     required this.meshUUID,
//     required this.meshName,
//     required this.version,
//     required this.timestamp,
//   });

//   factory Header.fromJson(Map<String, dynamic> json) => _$HeaderFromJson(json);
//   Map<String, dynamic> toJson() => _$HeaderToJson(this);
// }

// @JsonSerializable(explicitToJson: true)
// class NetKey {
//   String name;
//   int index;
//   String key;
//   int phase;
//   bool minSecurity;
//   int timestamp;

//   NetKey({
//     required this.name,
//     required this.index,
//     required this.key,
//     required this.phase,
//     required this.minSecurity,
//     required this.timestamp,
//   });

//   factory NetKey.fromJson(Map<String, dynamic> json) => _$NetKeyFromJson(json);
//   Map<String, dynamic> toJson() => _$NetKeyToJson(this);
// }

// @JsonSerializable(explicitToJson: true)
// class AppKey {
//   String name;
//   int index;
//   int boundNetKey;
//   String key;

//   AppKey({
//     required this.name,
//     required this.index,
//     required this.boundNetKey,
//     required this.key,
//   });

//   factory AppKey.fromJson(Map<String, dynamic> json) => _$AppKeyFromJson(json);
//   Map<String, dynamic> toJson() => _$AppKeyToJson(this);
// }

// @JsonSerializable(explicitToJson: true)
// class Provisioner {
//   String provisionerName;
//   String uuid;
//   Map allocatedUnicastRange;
//   Map allocatedGroupRange;
//   Map allocatedSceneRange;

//   Provisioner({
//     required this.provisionerName,
//     required this.uuid,
//     required this.allocatedUnicastRange,
//     required this.allocatedGroupRange,
//     required this.allocatedSceneRange,
//   });

//   factory Provisioner.fromJson(Map<String, dynamic> json) =>
//       _$ProvisionerFromJson(json);
//   Map<String, dynamic> toJson() => _$ProvisionerToJson(this);
// }
