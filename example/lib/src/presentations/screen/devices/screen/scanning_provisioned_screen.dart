import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:provider/provider.dart';
import '../../../../repo/permissions.dart';
import '../../../widget/app_bar.dart';
import '../../../widget/no_found_screen.dart';
import '../control_module/device_module.dart';
import '../provider/ble_scanner2.dart';
import '../widget/discovered_node.dart';

class ProvisionedDeviceListScreen extends StatelessWidget {
  final NordicNrfMesh nrfMesh;

  const ProvisionedDeviceListScreen({Key? key, required this.nrfMesh}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer2<BleScanner2, BleScanner2State?>(
        builder: (_, bleScanner, bleScannerState, __) => _DeviceList(
          nrfMesh: nrfMesh,
          scannerState: bleScannerState ??
              const BleScanner2State(
                discoveredDevices: [],
                scanIsInProgress: false,
              ),
          startScan: bleScanner.startScanProvisioned,
          stopScan: bleScanner.stopScan,
        ),
      );
}

class _DeviceList extends StatefulWidget {
  const _DeviceList({
    required this.scannerState,
    required this.startScan,
    required this.stopScan,
    required this.nrfMesh,
  });
  final NordicNrfMesh nrfMesh;

  final BleScanner2State scannerState;
  final void Function(List<Uuid>) startScan;
  final VoidCallback stopScan;

  @override
  _DeviceListState createState() => _DeviceListState();
}

class _DeviceListState extends State<_DeviceList> {
  late MeshManagerApi meshManagerApi;

  @override
  void initState() {
    super.initState();
    Permissions().checkAndAskPermissions();
    meshManagerApi = widget.nrfMesh.meshManagerApi;
    widget.startScan([]);
  }

  @override
  void dispose() {
    widget.stopScan();
    super.dispose();
  }

// chuyển tới trang cấu hình thiết bị
  Future<void> navToProvisionedNode(DiscoveredDevice device) async {
    setState(() => widget.stopScan);
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => DeviceModule(
          meshManagerApi: widget.nrfMesh.meshManagerApi,
          device: device,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const CustomAppBar(
          listAction: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: CircularProgressIndicator(color: Colors.white),
            )
          ],
          title: "Quét",
          centerTitle: false,
          subTitle: "Dò tìm các thiết bị đã ghép nối",
        ),
        body: Column(
          children: [
            widget.scannerState.discoveredDevices.isEmpty
                ? const NoFoundScreen(isScanScreen: true)
                : Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 100),
                      // shrinkWrap: true,
                      itemCount: widget.scannerState.discoveredDevices.length,
                      itemBuilder: (context, index) => GestureDetector(
                          onTap: () async => await navToProvisionedNode(widget.scannerState.discoveredDevices[index]),
                          child: DiscoveredNode(
                            device: widget.scannerState.discoveredDevices.elementAt(index),
                          )),
                    ),
                  )
          ],
        ),
      );
}
