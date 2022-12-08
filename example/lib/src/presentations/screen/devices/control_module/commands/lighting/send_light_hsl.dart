import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

class SendLightHsl extends StatefulWidget {
  final MeshManagerApi meshManagerApi;
  final int sequence;

  const SendLightHsl({Key? key, required this.meshManagerApi, required this.sequence}) : super(key: key);

  @override
  State<SendLightHsl> createState() => _SendLightHslState();
}

class _SendLightHslState extends State<SendLightHsl> {
  int? selectedElementAddress;

  int? selectedLightness;
  int? selectedHue;
  int? selectedSaturation;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: const ValueKey('module-send-generic-level-form'),
      title: const Text('Send light HSL'),
      children: <Widget>[
        TextField(
          key: const ValueKey('module-send-generic-level-address'),
          decoration: const InputDecoration(hintText: 'Element Address'),
          onChanged: (text) {
            selectedElementAddress = int.parse(text);
          },
        ),
        TextField(
          key: const ValueKey('module-send-light-hsl-lightness'),
          decoration: const InputDecoration(hintText: 'Lightness Value'),
          onChanged: (text) {
            setState(() {
              selectedLightness = int.tryParse(text);
            });
          },
        ),
        TextField(
          key: const ValueKey('module-send-light-hsl-hue'),
          decoration: const InputDecoration(hintText: 'Hue Value'),
          onChanged: (text) {
            setState(() {
              selectedHue = int.tryParse(text);
            });
          },
        ),
        TextField(
          key: const ValueKey('module-send-light-hsl-saturation'),
          decoration: const InputDecoration(hintText: 'Saturation Value'),
          onChanged: (text) {
            setState(() {
              selectedSaturation = int.tryParse(text);
            });
          },
        ),
        TextButton(
          onPressed: selectedHue != null && selectedLightness != null && selectedSaturation != null
              ? () async {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  debugPrint(
                      'send Hue:$selectedHue Lightness:$selectedLightness Saturation:$selectedSaturation  to $selectedElementAddress');
                  try {
                    await widget.meshManagerApi
                        .sendLightHsl(
                          selectedElementAddress!,
                          selectedLightness!,
                          selectedHue!,
                          selectedSaturation!,
                          widget.sequence,
                        )
                        .timeout(const Duration(seconds: 40));
                    scaffoldMessenger.showSnackBar(const SnackBar(content: Text('OK')));
                  } on TimeoutException catch (_) {
                    scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Board didn\'t respond')));
                  } on PlatformException catch (e) {
                    scaffoldMessenger.showSnackBar(SnackBar(content: Text('${e.message}')));
                  } catch (e) {
                    scaffoldMessenger.showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                }
              : null,
          child: const Text('Send hsl'),
        )
      ],
    );
  }
}
