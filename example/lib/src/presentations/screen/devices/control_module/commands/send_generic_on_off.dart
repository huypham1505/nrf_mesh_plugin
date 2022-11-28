import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

class SendGenericOnOff extends StatefulWidget {
  final MeshManagerApi meshManagerApi;

  const SendGenericOnOff({
    Key? key,
    required this.meshManagerApi,
  }) : super(key: key);

  @override
  State<SendGenericOnOff> createState() => _SendGenericOnOffState();
}

class _SendGenericOnOffState extends State<SendGenericOnOff> {
  // final ele = widget.elementData.address;
  int? selectedElementAddress;
  // @override
  // void initState() {
  //   super.initState();
  //   selectedElementAddress = widget.elementData.address;
  //   debugPrint('Element la: $selectedElementAddress');
  // }

  bool onOff = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: const ValueKey('module-send-generic-on-off-form'),
      title: const Text('Send a generic On Off set'),
      children: <Widget>[
        TextField(
          key: const ValueKey('module-send-generic-on-off-address'),
          decoration: const InputDecoration(hintText: 'Element Address'),
          onChanged: (text) {
            setState(() {
              selectedElementAddress = int.tryParse(text);
            });
          },
        ),
        Switch(
            value: onOff,
            onChanged: (value) {
              setState(() {
                onOff = value;
              });
            }),
        TextButton(
          onPressed: selectedElementAddress != null
              ? () async {
                  debugPrint('send level $onOff to $selectedElementAddress');
                  final provisionerUuid = await widget.meshManagerApi.meshNetwork!.selectedProvisionerUuid();
                  final nodes = await widget.meshManagerApi.meshNetwork!.nodes;
                  try {
                    final provisionedNode = nodes.firstWhere((element) => element.uuid == provisionerUuid);
                    final sequenceNumber = await widget.meshManagerApi.getSequenceNumber(provisionedNode);
                    await widget.meshManagerApi
                        .sendGenericOnOffSet(selectedElementAddress!, onOff, sequenceNumber)
                        .timeout(const Duration(seconds: 20));
                    // scaffoldMessenger.showSnackBar(const SnackBar(content: Text('OK')));
                  } on TimeoutException catch (_) {
                    // scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Board didn\'t respond')));
                    Get.snackbar(
                      "Lỗi",
                      "Không nhận phản hồi từ thiết bị",
                      icon: const Icon(Icons.label_important, color: Colors.yellow),
                      backgroundColor: Colors.white,
                      snackPosition: SnackPosition.TOP,
                      snackStyle: SnackStyle.FLOATING,
                      isDismissible: true,
                    );
                  } on StateError catch (_) {
                    // scaffoldMessenger.showSnackBar(SnackBar(content: Text('No provisioner found with this uuid : $provisionerUuid')));
                    Get.snackbar(
                      "Lỗi",
                      "Không tìm thấy provisioner với $provisionerUuid",
                      icon: const Icon(Icons.error, color: Colors.yellow),
                      backgroundColor: Colors.white,
                      snackPosition: SnackPosition.TOP,
                      snackStyle: SnackStyle.FLOATING,
                      isDismissible: true,
                    );
                  } on PlatformException catch (e) {
                    Get.snackbar(
                      "Lỗi",
                      e.toString(),
                      icon: const Icon(Icons.not_interested, color: Colors.yellow),
                      backgroundColor: Colors.white,
                      snackPosition: SnackPosition.TOP,
                      snackStyle: SnackStyle.FLOATING,
                      isDismissible: true,
                    );
                    // scaffoldMessenger.showSnackBar(SnackBar(content: Text('${e.message}')));
                  } catch (e) {
                    // scaffoldMessenger.showSnackBar(SnackBar(content: Text(e.toString())));
                    Get.snackbar(
                      "Lỗi",
                      e.toString(),
                      icon: const Icon(Icons.device_unknown, color: Colors.yellow),
                      backgroundColor: Colors.white,
                      snackPosition: SnackPosition.TOP,
                      snackStyle: SnackStyle.FLOATING,
                      isDismissible: true,
                    );
                  }
                }
              : null,
          child: const Text('Send on off'),
        )
      ],
    );
  }
}
