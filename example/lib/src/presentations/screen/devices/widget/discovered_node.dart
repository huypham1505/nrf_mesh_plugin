import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

import '../../../../config/text_style.dart';

class DiscoveredNode extends StatelessWidget {
  final DiscoveredDevice device;
  const DiscoveredNode({
    Key? key,
    required this.device,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //** chuyển MAC thành UUID chỉ cho android */
    String digits(int val, int digits) {
      var hi = 1 << (digits * 4);
      return (hi | (val & (hi - 1))).toRadixString(16).substring(1);
    }

    String getDeviceUuid(List<int> serviceData) {
      var msb = 0;
      var lsb = 0;
      for (var i = 0; i < 8; i++) {
        msb = (msb << 8) | (serviceData[i] & 0xff);
      }
      for (var i = 8; i < 16; i++) {
        lsb = (lsb << 8) | (serviceData[i] & 0xff);
      }
      return '${digits(msb >> 32, 8)}-${digits(msb >> 16, 4)}-${digits(msb, 4)}-${digits(lsb >> 48, 4)}-${digits(lsb, 12)}';
    }

    //** chuyển dữ liệu rssi thành icon */
    Widget getRssiIcons(int rssi) {
      if (rssi == -100 && rssi <= -90) {
        return Image.asset("assets/icons/no-signal.png", height: 30, width: 30);
      }
      if (rssi <= -90 && rssi <= -80) {
        return Image.asset("assets/icons/no-signal.png", height: 30, width: 30);
      }
      if (rssi <= -80 && rssi <= -70) {
        return Image.asset("assets/icons/no-signal.png", height: 30, width: 30);
      }
      if (rssi <= -70 && rssi <= -60) {
        return Image.asset("assets/icons/signal-1.png", height: 30, width: 30);
      }
      if (rssi <= -60 && rssi <= -50) {
        return Image.asset("assets/icons/signal-2.png", height: 30, width: 30);
      }
      if (rssi <= -50 && rssi <= -40) {
        return Image.asset("assets/icons/signal-3.png", height: 30, width: 30);
      }
      if (rssi <= -40 && rssi <= -30) {
        return Image.asset("assets/icons/signal-3.png", height: 30, width: 30);
      }
      if (rssi <= -30 && rssi <= -20) {
        return Image.asset("assets/icons/signal-4.png", height: 30, width: 30);
      }
      if (rssi <= -20 && rssi <= -10) {
        return Image.asset("assets/icons/signal-4.png", height: 30, width: 30);
      }
      if (rssi <= -10 && rssi <= -0) {
        return Image.asset("assets/icons/signal-4.png", height: 30, width: 30);
      } else {
        return const CircularProgressIndicator();
      }
    }

    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
        child: ListTile(
          title: Text(device.name, style: TextStyles.defaultStyle.fontTitle.bold, maxLines: 1),
          subtitle: Platform.isAndroid
              ? AutoSizeText(Uuid.parse(getDeviceUuid(device.serviceData[meshProvisioningUuid]!.toList())).toString(),
                  style: TextStyles.defaultStyle, maxLines: 1)
              : AutoSizeText(device.id, style: TextStyles.defaultStyle, maxLines: 1),
          trailing: Column(children: [
            getRssiIcons(device.rssi),
            Text(device.rssi.toString(), style: TextStyles.defaultStyle.regular, maxLines: 1)
          ]),
        ));
  }
}
