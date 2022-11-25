// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'mesh_model.dart';

// // **************************************************************************
// // JsonSerializableGenerator
// // **************************************************************************

// Header _$HeaderFromJson(Map<String, dynamic> json) => Header(
//       meshUUID: json['meshUUID'] as String,
//       meshName: json['meshName'] as String,
//       version: json['version'] as String,
//       timestamp: json['timestamp'] == null
//           ? null
//           : DateTime.parse(json['timestamp'] as String),
//     );

// Map<String, dynamic> _$HeaderToJson(Header instance) => <String, dynamic>{
//       'meshUUID': instance.meshUUID,
//       'meshName': instance.meshName,
//       'version': instance.version,
//       'timestamp': instance.timestamp?.toIso8601String(),
//     };

// NetKey _$NetKeyFromJson(Map<String, dynamic> json) => NetKey(
//       name: json['name'] as String,
//       index: json['index'] as int,
//       key: json['key'] as String,
//       phase: json['phase'] as int,
//       minSecurity: json['minSecurity'] as bool,
//       timestamp: json['timestamp'] as int,
//     );

// Map<String, dynamic> _$NetKeyToJson(NetKey instance) => <String, dynamic>{
//       'name': instance.name,
//       'index': instance.index,
//       'key': instance.key,
//       'phase': instance.phase,
//       'minSecurity': instance.minSecurity,
//       'timestamp': instance.timestamp,
//     };

// AppKey _$AppKeyFromJson(Map<String, dynamic> json) => AppKey(
//       name: json['name'] as String,
//       index: json['index'] as int,
//       boundNetKey: json['boundNetKey'] as int,
//       key: json['key'] as String,
//     );

// Map<String, dynamic> _$AppKeyToJson(AppKey instance) => <String, dynamic>{
//       'name': instance.name,
//       'index': instance.index,
//       'boundNetKey': instance.boundNetKey,
//       'key': instance.key,
//     };

// Provisioner _$ProvisionerFromJson(Map<String, dynamic> json) => Provisioner(
//       provisionerName: json['provisionerName'] as String,
//       uuid: json['uuid'] as String,
//       allocatedUnicastRange:
//           json['allocatedUnicastRange'] as Map<String, dynamic>,
//       allocatedGroupRange: json['allocatedGroupRange'] as Map<String, dynamic>,
//       allocatedSceneRange: json['allocatedSceneRange'] as Map<String, dynamic>,
//     );

// Map<String, dynamic> _$ProvisionerToJson(Provisioner instance) =>
//     <String, dynamic>{
//       'provisionerName': instance.provisionerName,
//       'uuid': instance.uuid,
//       'allocatedUnicastRange': instance.allocatedUnicastRange,
//       'allocatedGroupRange': instance.allocatedGroupRange,
//       'allocatedSceneRange': instance.allocatedSceneRange,
//     };
