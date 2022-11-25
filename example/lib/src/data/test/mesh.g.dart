// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'mesh.dart';

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

// GatewayProperties _$GatewayPropertiesFromJson(Map<String, dynamic> json) =>
//     GatewayProperties(
//       name: json['name'] as String,
//       ip: json['ip'] as String,
//       host: json['host'] as int,
//       apikey: json['apikey'] as String,
//       documentPath: json['documentPath'] as String,
//       projectid: json['projectid'] as String,
//       properties: json['properties'] as Map<String, dynamic>?,
//     );

// Map<String, dynamic> _$GatewayPropertiesToJson(GatewayProperties instance) =>
//     <String, dynamic>{
//       'name': instance.name,
//       'ip': instance.ip,
//       'host': instance.host,
//       'apikey': instance.apikey,
//       'documentPath': instance.documentPath,
//       'projectid': instance.projectid,
//       'properties': instance.properties,
//     };

// GatewayTCPConfig _$GatewayTCPConfigFromJson(Map<String, dynamic> json) =>
//     GatewayTCPConfig(
//       apiKey: json['apiKey'] as String,
//       projectId: json['projectId'] as String,
//       email: json['email'] as String?,
//       password: json['password'] as String?,
//       documentPath: json['documentPath'] as String,
//     );

// Map<String, dynamic> _$GatewayTCPConfigToJson(GatewayTCPConfig instance) =>
//     <String, dynamic>{
//       'apiKey': instance.apiKey,
//       'projectId': instance.projectId,
//       'email': instance.email,
//       'password': instance.password,
//       'documentPath': instance.documentPath,
//     };

// BaseTCP _$BaseTCPFromJson(Map<String, dynamic> json) => BaseTCP(
//       topic: json['topic'] as String?,
//       payload: json['payload'] as Map<String, dynamic>?,
//     );

// Map<String, dynamic> _$BaseTCPToJson(BaseTCP instance) => <String, dynamic>{
//       'topic': instance.topic,
//       'payload': instance.payload,
//     };

// Node _$NodeFromJson(Map<String, dynamic> json) => Node(
//       name: json['name'] as String?,
//       context: json['context'] as int?,
//       netKeyIndex: json['netKeyIndex'] as int?,
//       appKeyIndex: json['appKeyIndex'] as int?,
//       advAddr: json['advAddr'] as String?,
//       advAddrType: json['advAddrType'] as int?,
//       gattSupported: json['gattSupported'] as int?,
//       rssi: json['rssi'] as int?,
//       uuid: json['uuid'] as String?,
//       address: json['address'] as String?,
//       deviceKey: json['deviceKey'] as String?,
//       networkKey: json['networkKey'] as String?,
//       appKey: json['appKey'] as String?,
//       numberOfElements: json['numberOfElements'] as int?,
//       elementAddress: json['elementAddress'] as String?,
//       devKeyHandle: json['devKeyHandle'] as String?,
//       addressHandle: json['addressHandle'] as String?,
//       cid: json['cid'] as String?,
//       pid: json['pid'] as String?,
//       vid: json['vid'] as String?,
//       crpl: json['crpl'] as String?,
//       relay: json['relay'] as bool?,
//       proxy: json['proxy'] as bool?,
//       friends: json['friends'] as bool?,
//       lowPower: json['lowPower'] as bool?,
//       loc: json['loc'] as String?,
//       models: json['models'] as List<dynamic>?,
//       effects: json['effects'] as List<dynamic>?,
//       bindModels: json['bindModels'] as List<dynamic>?,
//       public: json['public'] as Map<String, dynamic>,
//       hubConfig: json['hubConfig'] as Map<String, dynamic>?,
//     );

// Map<String, dynamic> _$NodeToJson(Node instance) => <String, dynamic>{
//       'name': instance.name,
//       'context': instance.context,
//       'netKeyIndex': instance.netKeyIndex,
//       'appKeyIndex': instance.appKeyIndex,
//       'advAddr': instance.advAddr,
//       'gattSupported': instance.gattSupported,
//       'advAddrType': instance.advAddrType,
//       'rssi': instance.rssi,
//       'uuid': instance.uuid,
//       'address': instance.address,
//       'deviceKey': instance.deviceKey,
//       'networkKey': instance.networkKey,
//       'appKey': instance.appKey,
//       'numberOfElements': instance.numberOfElements,
//       'elementAddress': instance.elementAddress,
//       'devKeyHandle': instance.devKeyHandle,
//       'addressHandle': instance.addressHandle,
//       'cid': instance.cid,
//       'pid': instance.pid,
//       'vid': instance.vid,
//       'crpl': instance.crpl,
//       'relay': instance.relay,
//       'proxy': instance.proxy,
//       'friends': instance.friends,
//       'lowPower': instance.lowPower,
//       'loc': instance.loc,
//       'models': instance.models,
//       'effects': instance.effects,
//       'bindModels': instance.bindModels,
//       'public': instance.public,
//       'hubConfig': instance.hubConfig,
//     };

// Model _$ModelFromJson(Map<String, dynamic> json) => Model(
//       modelId: json['modelId'] as int,
//       bind: (json['bind'] as List<dynamic>?)?.map((e) => e as int).toList(),
//       subscribe:
//           (json['subscribe'] as List<dynamic>?)?.map((e) => e as int).toList(),
//       public: (json['public'] as List<dynamic>?)
//           ?.map((e) => Public.fromJson(e as Map<String, dynamic>))
//           .toList(),
//     );

// Map<String, dynamic> _$ModelToJson(Model instance) => <String, dynamic>{
//       'modelId': instance.modelId,
//       'bind': instance.bind,
//       'subscribe': instance.subscribe,
//       'public': instance.public?.map((e) => e.toJson()).toList(),
//     };

// Public _$PublicFromJson(Map<String, dynamic> json) => Public(
//       address: json['address'] as int,
//       index: json['index'] as int,
//       ttl: json['ttl'] as int,
//       credentials: json['credentials'] as int,
//       period: (json['period'] as Map<String, dynamic>?)?.map(
//         (k, e) => MapEntry(k, e as int),
//       ),
//       transmit: (json['transmit'] as Map<String, dynamic>?)?.map(
//         (k, e) => MapEntry(k, e as int),
//       ),
//     );

// Map<String, dynamic> _$PublicToJson(Public instance) => <String, dynamic>{
//       'address': instance.address,
//       'index': instance.index,
//       'ttl': instance.ttl,
//       'credentials': instance.credentials,
//       'period': instance.period,
//       'transmit': instance.transmit,
//     };

// Element _$ElementFromJson(Map<String, dynamic> json) => Element(
//       name: json['name'] as String,
//       index: json['index'] as int,
//       location: json['location'] as int,
//       models: (json['models'] as List<dynamic>)
//           .map((e) => Model.fromJson(e as Map<String, dynamic>))
//           .toList(),
//     );

// Map<String, dynamic> _$ElementToJson(Element instance) => <String, dynamic>{
//       'name': instance.name,
//       'index': instance.index,
//       'location': instance.location,
//       'models': instance.models.map((e) => e.toJson()).toList(),
//     };

// UnProvisioning _$UnProvisioningFromJson(Map<String, dynamic> json) =>
//     UnProvisioning(
//       context: json['context'] as int,
//       netKeyIndex: json['netKeyIndex'] as int,
//       uuid: json['uuid'] as String,
//       address: json['address'] as String,
//     );

// Map<String, dynamic> _$UnProvisioningToJson(UnProvisioning instance) =>
//     <String, dynamic>{
//       'context': instance.context,
//       'netKeyIndex': instance.netKeyIndex,
//       'uuid': instance.uuid,
//       'address': instance.address,
//     };

// EffectJson _$EffectJsonFromJson(Map<String, dynamic> json) => EffectJson(
//       name: json['name'] as String,
//       opcode: json['opcode'] as String,
//       id: json['id'] as int,
//       speed: json['speed'] as int,
//       lightness: json['lightness'] as int,
//     );

// Map<String, dynamic> _$EffectJsonToJson(EffectJson instance) =>
//     <String, dynamic>{
//       'name': instance.name,
//       'opcode': instance.opcode,
//       'id': instance.id,
//       'speed': instance.speed,
//       'lightness': instance.lightness,
//     };

// HubSetting _$HubSettingFromJson(Map<String, dynamic> json) => HubSetting(
//       opcode: json['opcode'] as String,
//       address: json['address'] as String,
//       type: json['type'] as int,
//       chanel: json['chanel'] as int,
//       amount: json['amount'] as int,
//       row: json['row'] as int,
//       column: json['column'] as int,
//       speed: json['speed'] as int,
//       lightness: json['lightness'] as int,
//       zigzac: json['zigzac'] as int,
//       coordinator: json['coordinator'] as int,
//       direction: json['direction'] as int,
//       portNumber: json['portNumber'] as List<dynamic>,
//     );

// Map<String, dynamic> _$HubSettingToJson(HubSetting instance) =>
//     <String, dynamic>{
//       'opcode': instance.opcode,
//       'address': instance.address,
//       'type': instance.type,
//       'chanel': instance.chanel,
//       'amount': instance.amount,
//       'row': instance.row,
//       'column': instance.column,
//       'speed': instance.speed,
//       'lightness': instance.lightness,
//       'zigzac': instance.zigzac,
//       'coordinator': instance.coordinator,
//       'direction': instance.direction,
//       'portNumber': instance.portNumber,
//     };
