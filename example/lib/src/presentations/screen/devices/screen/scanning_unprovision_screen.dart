import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../config/text_style.dart';
import '../../../widget/app_bar.dart';
import '../../../widget/no_found_screen.dart';
import '../control_module/device_controll_module.dart';
import '../control_module/device_module.dart';
import '../provider/ble_scanner.dart';
import '../widget/unprovisioned_node.dart';

class UnProvisionedDeviceListScreen extends StatelessWidget {
  final NordicNrfMesh nrfMesh;

  const UnProvisionedDeviceListScreen({Key? key, required this.nrfMesh}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer2<BleScanner, BleScannerState?>(
        builder: (_, bleScanner, bleScannerState, __) => _DeviceList(
          nrfMesh: nrfMesh,
          scannerState: bleScannerState ??
              const BleScannerState(
                discoveredDevices: [],
                scanIsInProgress: false,
              ),
          startScan: bleScanner.startScanUnProvisioned,
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

  final BleScannerState scannerState;
  final void Function(List<Uuid>) startScan;
  final VoidCallback stopScan;

  @override
  _DeviceListState createState() => _DeviceListState();
}

class _DeviceListState extends State<_DeviceList> {
  late MeshManagerApi _meshManagerApi;
  late List<DiscoveredDevice> listData = [];
  late String inputSearch = "";

  @override
  void initState() {
    super.initState();
    checkAndAskPermissions();
    _meshManagerApi = widget.nrfMesh.meshManagerApi;
    widget.startScan([]);
  }

  @override
  void dispose() {
    widget.stopScan();
    inputSearch;
    super.dispose();
  }

// hàm search node
  void searchUnprovisioned(String input) {
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

// hàm thực thi provisionig
  Future<void> provisionDevice(DiscoveredDevice device) async {
    widget.stopScan();
    try {
      // Android is sending the mac Adress of the device, but Apple generates
      // an UUID specific by smartphone.
      // Hệ điều hành android thì sẽ gửi địa chỉ mac của thiết bị, còn ios(apple) thì sẽ tự tạo uuid bằng thiết bị
      String deviceUUID;
      if (Platform.isAndroid) {
        // deviceUUID = Uuid.parse(getDeviceUuid(device.serviceData[meshProvisioningUuid]!.toList())).toString();
        deviceUUID =
            Uuid.parse(_meshManagerApi.getDeviceUuid(device.serviceData[meshProvisioningUuid]!.toList())).toString();
        debugPrint("Thiết bị đang ghép nối trên nền tảng android có uuid là $deviceUUID");
      } else if (Platform.isIOS) {
        deviceUUID = device.id.toString();
        debugPrint("Thiết bị đang ghép nối trên nền tảng ios có uuid là $deviceUUID");
      } else {
        throw UnimplementedError('device uuid on platform : ${Platform.operatingSystem}');
      }
      final provisioningEvent = ProvisioningEvent();
      // thực hiện ghép thiết bị
      // start to provisioning
      final provisionedMeshNodeF =
          widget.nrfMesh.provisioning(_meshManagerApi, BleMeshManager(), device, deviceUUID, events: provisioningEvent)
          // limit is 1 min
          // .timeout(const Duration(minutes: 1))
          ;

      unawaited(provisionedMeshNodeF.then((node) async {
        Navigator.of(context).pop();
        Get.snackbar("Ghép nối thiết bị thành công", "Bắt đầu chuyển sang trang cấu hình ${device.name}",
            icon: const Icon(Icons.done, color: Colors.green),
            backgroundColor: Colors.white,
            snackPosition: SnackPosition.TOP,
            snackStyle: SnackStyle.FLOATING,
            isDismissible: true);
        await Future.delayed(
          const Duration(milliseconds: 1000),
          () => Navigator.of(context).pop(),
        )
            // .whenComplete(
            //   () => Navigator.push(
            //     context,
            //     MaterialPageRoute<void>(
            //       builder: (BuildContext context) => DeviceControllModule(
            //         nodeData: node,
            //         meshManagerApi: widget.nrfMesh.meshManagerApi,
            //         device: device,
            //       ),
            //     ),
            //   ),
            // )
            ;
      }).catchError((_) {
        Navigator.of(context).pop();
        Get.snackbar(
          "Ghép nối thất bại",
          _.toString(),
          icon: const Icon(Icons.warning, color: Colors.yellowAccent),
          backgroundColor: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        widget.startScan([]);
      }));
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => ProvisioningDialog(provisioningEvent: provisioningEvent),
      );
    } catch (e) {
      debugPrint('$e');
      Get.snackbar(
        "Lỗi",
        e.toString(),
        icon: const Icon(Icons.error, color: Colors.redAccent),
        backgroundColor: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppBar(
          title: "Quét",
          centerTitle: false,
          subTitle: "Dò tìm các thiết bị chưa ghép nối",
          leading: GestureDetector(onTap: () => Get.back(), child: const Icon(CupertinoIcons.back)),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                onChanged: (value) => searchUnprovisioned(value),
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
                ?
                // check nếu list thiết bị rỗng thì...
                //else thì hiện ra
                widget.scannerState.discoveredDevices.isEmpty
                    ? const NoFoundScreen(isScanScreen: true)
                    : Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 100),
                          // shrinkWrap: true,
                          itemCount: widget.scannerState.discoveredDevices.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                                onTap: () => provisionDevice(widget.scannerState.discoveredDevices.elementAt(index)),
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
                            onTap: () => provisionDevice(listData.elementAt(index)),
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

/// events
// meshnetwork dialog
class ProvisioningDialog extends StatelessWidget {
  final ProvisioningEvent provisioningEvent;

  const ProvisioningDialog({Key? key, required this.provisioningEvent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const SpinKitRotatingCircle(
                    color: Colors.blueAccent,
                    size: 30.0,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Đang kết nối ...",
                    style: TextStyles.defaultStyle.semibold,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: [
                      ProvisioningState(
                        text: 'onProvisioningCapabilities',
                        stream: provisioningEvent.onProvisioningCapabilities.map((event) => true),
                      ),
                      ProvisioningState(
                        text: 'onProvisioning',
                        stream: provisioningEvent.onProvisioning.map((event) => true),
                      ),
                      ProvisioningState(
                        text: 'onProvisioningReconnect',
                        stream: provisioningEvent.onProvisioningReconnect.map((event) => true),
                      ),
                      ProvisioningState(
                        text: 'onConfigCompositionDataStatus',
                        stream: provisioningEvent.onConfigCompositionDataStatus.map((event) => true),
                      ),
                      ProvisioningState(
                        text: 'onConfigAppKeyStatus',
                        stream: provisioningEvent.onConfigAppKeyStatus.map((event) => true),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// meshnetwork state
class ProvisioningState extends StatelessWidget {
  final Stream<bool> stream;
  final String text;

  const ProvisioningState({Key? key, required this.stream, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: stream,
      builder: (context, snapshot) {
        return Row(
          children: [
            Text(
              text,
              style: TextStyles.defaultStyle,
            ),
            const Spacer(),
            Checkbox(
              value: snapshot.data,
              onChanged: null,
            ),
          ],
        );
      },
    );
  }
}
