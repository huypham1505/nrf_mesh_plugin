// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'send_provisioning_pdu.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
SendProvisioningPduData _$SendProvisioningPduDataFromJson(
    Map<String, dynamic> json) {
  return _SendProvisioningPduData.fromJson(json);
}

class _$SendProvisioningPduDataTearOff {
  const _$SendProvisioningPduDataTearOff();

  _SendProvisioningPduData call(List<int> pdu, String meshNodeUuid) {
    return _SendProvisioningPduData(
      pdu,
      meshNodeUuid,
    );
  }
}

// ignore: unused_element
const $SendProvisioningPduData = _$SendProvisioningPduDataTearOff();

mixin _$SendProvisioningPduData {
  List<int> get pdu;
  String get meshNodeUuid;

  Map<String, dynamic> toJson();
  $SendProvisioningPduDataCopyWith<SendProvisioningPduData> get copyWith;
}

abstract class $SendProvisioningPduDataCopyWith<$Res> {
  factory $SendProvisioningPduDataCopyWith(SendProvisioningPduData value,
          $Res Function(SendProvisioningPduData) then) =
      _$SendProvisioningPduDataCopyWithImpl<$Res>;
  $Res call({List<int> pdu, String meshNodeUuid});
}

class _$SendProvisioningPduDataCopyWithImpl<$Res>
    implements $SendProvisioningPduDataCopyWith<$Res> {
  _$SendProvisioningPduDataCopyWithImpl(this._value, this._then);

  final SendProvisioningPduData _value;
  // ignore: unused_field
  final $Res Function(SendProvisioningPduData) _then;

  @override
  $Res call({
    Object pdu = freezed,
    Object meshNodeUuid = freezed,
  }) {
    return _then(_value.copyWith(
      pdu: pdu == freezed ? _value.pdu : pdu as List<int>,
      meshNodeUuid: meshNodeUuid == freezed
          ? _value.meshNodeUuid
          : meshNodeUuid as String,
    ));
  }
}

abstract class _$SendProvisioningPduDataCopyWith<$Res>
    implements $SendProvisioningPduDataCopyWith<$Res> {
  factory _$SendProvisioningPduDataCopyWith(_SendProvisioningPduData value,
          $Res Function(_SendProvisioningPduData) then) =
      __$SendProvisioningPduDataCopyWithImpl<$Res>;
  @override
  $Res call({List<int> pdu, String meshNodeUuid});
}

class __$SendProvisioningPduDataCopyWithImpl<$Res>
    extends _$SendProvisioningPduDataCopyWithImpl<$Res>
    implements _$SendProvisioningPduDataCopyWith<$Res> {
  __$SendProvisioningPduDataCopyWithImpl(_SendProvisioningPduData _value,
      $Res Function(_SendProvisioningPduData) _then)
      : super(_value, (v) => _then(v as _SendProvisioningPduData));

  @override
  _SendProvisioningPduData get _value =>
      super._value as _SendProvisioningPduData;

  @override
  $Res call({
    Object pdu = freezed,
    Object meshNodeUuid = freezed,
  }) {
    return _then(_SendProvisioningPduData(
      pdu == freezed ? _value.pdu : pdu as List<int>,
      meshNodeUuid == freezed ? _value.meshNodeUuid : meshNodeUuid as String,
    ));
  }
}

@JsonSerializable()
class _$_SendProvisioningPduData implements _SendProvisioningPduData {
  const _$_SendProvisioningPduData(this.pdu, this.meshNodeUuid)
      : assert(pdu != null),
        assert(meshNodeUuid != null);

  factory _$_SendProvisioningPduData.fromJson(Map<String, dynamic> json) =>
      _$_$_SendProvisioningPduDataFromJson(json);

  @override
  final List<int> pdu;
  @override
  final String meshNodeUuid;

  @override
  String toString() {
    return 'SendProvisioningPduData(pdu: $pdu, meshNodeUuid: $meshNodeUuid)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _SendProvisioningPduData &&
            (identical(other.pdu, pdu) ||
                const DeepCollectionEquality().equals(other.pdu, pdu)) &&
            (identical(other.meshNodeUuid, meshNodeUuid) ||
                const DeepCollectionEquality()
                    .equals(other.meshNodeUuid, meshNodeUuid)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(pdu) ^
      const DeepCollectionEquality().hash(meshNodeUuid);

  @override
  _$SendProvisioningPduDataCopyWith<_SendProvisioningPduData> get copyWith =>
      __$SendProvisioningPduDataCopyWithImpl<_SendProvisioningPduData>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_SendProvisioningPduDataToJson(this);
  }
}

abstract class _SendProvisioningPduData implements SendProvisioningPduData {
  const factory _SendProvisioningPduData(List<int> pdu, String meshNodeUuid) =
      _$_SendProvisioningPduData;

  factory _SendProvisioningPduData.fromJson(Map<String, dynamic> json) =
      _$_SendProvisioningPduData.fromJson;

  @override
  List<int> get pdu;
  @override
  String get meshNodeUuid;
  @override
  _$SendProvisioningPduDataCopyWith<_SendProvisioningPduData> get copyWith;
}