import 'dart:async';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../../config/text_style.dart';
import '../../../widget/app_bar.dart';
import '../../../widget/no_found_screen.dart';
import '../control_module/device_module.dart';
import '../provider/ble_scanner2.dart';
import '../widget/unprovisioned_node.dart';

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
  late List<DiscoveredDevice> listData = [];
  late String inputSearch = "";

  @override
  void initState() {
    super.initState();
    checkAndAskPermissions();
    meshManagerApi = widget.nrfMesh.meshManagerApi;
    widget.startScan([]);
  }

  @override
  void dispose() {
    widget.stopScan();
    super.dispose();
  }

// hàm search
  void searchProvisioned(String input) {
    inputSearch = input;
    if (inputSearch.isEmpty) {
      listData = widget.scannerState.discoveredDevices;
    } else {
      final data = widget.scannerState.discoveredDevices
          .where((element) =>
              // element.name.contains(input.toLowerCase()) ||
              element.id.toLowerCase().contains(inputSearch.toLowerCase()) ||
              element.name.toLowerCase().contains(inputSearch.toLowerCase()))
          .toList();
      setState(() {
        listData = data;
      });
    }
  }

// check bluetooth và vị trí
  Future<void> checkAndAskPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 31) {
        // location
        await Permission.locationWhenInUse.request();
        await Permission.locationAlways.request();
        // bluetooth
        await Permission.bluetooth.request();
      } else {
        // bluetooth for Android 12 and up
        await Permission.bluetoothScan.request();
        await Permission.bluetoothConnect.request();
      }
    } else {
      // bluetooth for iOS 13 and up
      await Permission.bluetooth.request();
    }
  }

// chuyển tới trang cấu hình thiết bị
  Future<void> navToProvisionedNode(DiscoveredDevice device) async {
    setState(() {
      widget.stopScan;
    });
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
        appBar: CustomAppBar(
          title: "Quét",
          centerTitle: false,
          subTitle: "Dò tìm các thiết bị đã ghép nối",
          leading: GestureDetector(onTap: () => Get.back(), child: const Icon(CupertinoIcons.back)),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                onChanged: (value) => searchProvisioned(value),
                style: TextStyles.defaultStyle.italic,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  labelText: "Tìm kiếm thiết bị ...",
                ),
              ),
            ),
            inputSearch == ""
                ? widget.scannerState.discoveredDevices.isEmpty
                    ? const NoFoundScreen(isScanScreen: true)
                    : Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 100),
                          // shrinkWrap: true,
                          itemCount: widget.scannerState.discoveredDevices.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                                onTap: () async =>
                                    await navToProvisionedNode(widget.scannerState.discoveredDevices[index]),
                                child: UnprovisionedNode(
                                  device: widget.scannerState.discoveredDevices.elementAt(index),
                                ));
                          },
                        ),
                      )
                : Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 100),
                      // shrinkWrap: true,
                      itemCount: listData.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () async => await navToProvisionedNode(listData[index]),
                            child: UnprovisionedNode(
                              device: listData.elementAt(index),
                            ));
                      },
                    ),
                  ),
          ],
        ),
      );
}
