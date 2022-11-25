import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../config/palettes.dart';
import '../../../../config/text_style.dart';

class ExportScreen extends StatefulWidget {
  final MeshManagerApi meshManagerApi;
  const ExportScreen({Key? key, required this.meshManagerApi}) : super(key: key);

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  late bool _permissionReady;
  late TargetPlatform? platform;
  final String fileName = "nRF_MeshNetwork.json";
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }
  }

  Future<bool> _checkPermission() async {
    if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    /// build appbar
    PreferredSizeWidget buildAppBar() {
      return AppBar(
        title: Text(
          "Xuất dữ liệu",
          style: TextStyles.defaultStyle.fontHeader.whiteTextColor,
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: Palettes.gradientAppBar),
        ),
        centerTitle: false,
      );
    }

    Widget buildBody() {
      return Column(
        children: [
          const ListTile(
            leading: Icon(
              Icons.folder,
            ),
            title: Text("Cấu hình"),
          ),
          ListTile(
            title: const Text("Xuất tất cả dữ liệu"),
            trailing: Switch(
              value: true,
              onChanged: (value) {
                setState(() {
                  value;
                });
                debugPrint(value.toString());
              },
            ),
          ),
        ],
      );
    }

    /// build floating btn
    /// Xuất file json
    void floatingActionBtnOnTapped() async {
      final stringJsonData = await widget.meshManagerApi.exportMeshNetwork();
      _permissionReady = await _checkPermission();
      if (_permissionReady) {
        final stringJsonData = await widget.meshManagerApi.exportMeshNetwork();
        final filePath = await FilePicker.platform.getDirectoryPath();
        File string = File('$filePath/$fileName');
        // await string.create(recursive: true);
        // Uint8List bytes = await string.readAsBytes();
        // await string.writeAsBytes(bytes);
        // string.writeAsString(stringJsonData!);
        debugPrint(stringJsonData.toString());
        debugPrint(string.toString());
        debugPrint("Downloading");
        try {
          debugPrint("Download Completed.");
        } catch (e) {
          debugPrint("Download Failed.\n\n$e");
        }
      }
    }

    Widget buildFloatingActionBtn() {
      return FloatingActionButton.extended(
        backgroundColor: Palettes.p7,
        label: Row(
          children: [
            Text(
              'Xuất dữ liệu (file json)',
              style: TextStyles.defaultStyle.whiteTextColor.bold,
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.output,
            )
          ],
        ),
        onPressed: () => floatingActionBtnOnTapped(),
      );
    }

    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
      floatingActionButton: buildFloatingActionBtn(),
    );
  }
}
