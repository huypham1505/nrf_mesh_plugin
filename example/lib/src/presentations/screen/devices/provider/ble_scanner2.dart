import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

import 'reactive_state.dart';

class BleScanner2 implements ReactiveState<BleScanner2State> {
  BleScanner2({
    required FlutterReactiveBle ble,
    required Function(String message) logMessage,
  })  : _ble = ble,
        _logMessage = logMessage;

  final FlutterReactiveBle _ble;
  final void Function(String message) _logMessage;
  final StreamController<BleScanner2State> _stateStreamController = StreamController();
  final _devices = <DiscoveredDevice>[];

  @override
  Stream<BleScanner2State> get state => _stateStreamController.stream;

  void startScanProvisioned(List<Uuid> serviceIds) {
    final apolloLib = NordicNrfMesh();
    _logMessage('Bắt đầu quét tìm provisioned node 🤖🤖🤖');
    _devices.clear();
    _subscription?.cancel();
    _subscription = apolloLib.scanForProxy().listen((device) {
      final showedDevice = _devices.indexWhere((d) => d.id == device.id);
      if (showedDevice >= 0) {
        _devices[showedDevice] = device;
      } else {
        debugPrint('Device name: ${device.id}');
        _devices.add(device);
      }
      _pushState();
    }, onError: (Object e) => _logMessage('Dò tìm thiết bị lỗi 💢: $e'));
    _pushState();
  }

  void _pushState() {
    _stateStreamController.add(
      BleScanner2State(
        discoveredDevices: _devices,
        scanIsInProgress: _subscription != null,
      ),
    );
  }

  Future<void> stopScan() async {
    _logMessage('Dừng quá trình quét 🛑🛑🛑');

    await _subscription?.cancel();
    _subscription = null;
    _pushState();
  }

  Future<void> dispose() async {
    await _stateStreamController.close();
  }

  StreamSubscription? _subscription;
}

@immutable
class BleScanner2State {
  const BleScanner2State({
    required this.discoveredDevices,
    required this.scanIsInProgress,
  });

  final List<DiscoveredDevice> discoveredDevices;
  final bool scanIsInProgress;
}
