import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:settings_ui/settings_ui.dart';
import '../../../../config/palettes.dart';
import '../../../../config/text_style.dart';
import 'export_screen.dart';

class SettingScreen extends StatefulWidget {
  final IMeshNetwork meshNetwork;
  final MeshManagerApi meshManagerApi;
  const SettingScreen({
    Key? key,
    required this.meshNetwork,
    required this.meshManagerApi,
  }) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late String name = "loading...";
  late String netKeyName = "loading...";
  late String provisioner = "loading...";
  late String scences = "loading...";
  late String lastReset = "loading...";
  late String version = "loading...";
  late List<Provisioner> provisioners = [];

  Future<String> getMeshNetName() async {
    final name = await widget.meshNetwork.name;
    return name;
  }

  final titleProvider = Provider((_) => 'Cài đặt');

  @override
  void initState() {
    super.initState();
    widget.meshNetwork.name.then((value) => setState(() => name = value));
    widget.meshNetwork.provisioners.then((value) => setState(() => provisioners = value));
    getNetKey();
    getDataFormJsonData();
  }

  Future getDataFormJsonData() async {
    final data = await widget.meshManagerApi.exportMeshNetwork();
    final jsonData = jsonDecode(data!);
    debugPrint(jsonData['appKeys'].toString());
  }

  Future getNetKey() async {
    final dataNetKey = await widget.meshNetwork.getNetKey(0);
    debugPrint(dataNetKey!.meshUuid);
    debugPrint(dataNetKey.identityKey.toString());
    debugPrint(dataNetKey.oldNetKeyBytes.toString());
    debugPrint(dataNetKey.oldIdentityKey.toString());
    debugPrint(dataNetKey.netKeyBytes.toString());
    debugPrint(dataNetKey.netKeyIndex.toString());
    netKeyName = dataNetKey.name;
  }

  @override
  void didUpdateWidget(covariant SettingScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.meshNetwork.name.then((value) => setState(() => name = value));
    widget.meshNetwork.provisioners.then((value) => setState(() => provisioners = value));
  }

  @override
  Widget build(BuildContext context) {
    /// build appbar
    PreferredSizeWidget buildAppBar() {
      return AppBar(
        title: Consumer(
          builder: (context, ref, child) {
            return Text(ref.watch(titleProvider));
          },
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: Palettes.gradientAppBar),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              /// Xuất dữ liệu (file json)
              PopupMenuItem(
                onTap: () {
                  // chuyển sang trang xuất dữ file json
                  Future.delayed(
                      const Duration(milliseconds: 0),
                      () => Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) {
                            return ExportScreen(
                              meshManagerApi: widget.meshManagerApi,
                            );
                          })));
                },
                child: const Text("Xuất dữ liệu json"),
              ),

              // Nhập dữ liệu json
              PopupMenuItem(
                onTap: () async {
                  Future.delayed(
                    const Duration(seconds: 0),
                    () => Get.dialog(
                      AlertDialog(
                        title: Text('Nhập dữ liệu mới', style: TextStyles.defaultStyle.bold),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Điều này sẽ xoá tất cả dữ liệu liên quan trên hệ thống và bạn không thể hồi phục',
                                style: TextStyles.defaultStyle),
                            const SizedBox(height: 5),
                            Text('Note: Bạn có thể xuất dữ liệu cũ trước khi nhập dữ liệu mới',
                                style: TextStyles.defaultStyle.italic),
                            const SizedBox(height: 5),
                            Text('Bạn có chắc chắn muốn tiếp tục', style: TextStyles.defaultStyle),
                          ],
                        ),
                        actions: [
                          TextButton(
                            child: Text(
                              "Huỷ",
                              style: TextStyles.defaultStyle.redTextColor,
                            ),
                            onPressed: () => Get.back(),
                          ),
                          TextButton(
                            onPressed: () async {
                              Future.delayed(const Duration(seconds: 0), (() async {
                                Get.back();
                                final filePath = await FilePicker.platform.pickFiles(type: FileType.any);
                                if (filePath == null) return;
                                final file = File(filePath.paths.first!);
                                final json = await file.readAsString();
                                await widget.meshManagerApi.importMeshNetworkJson(json);
                              })).whenComplete(() {
                                Get.snackbar(
                                  "Dữ liệu",
                                  'Nhập dữ liệu mới vào hệ thống thành công',
                                  icon: const Icon(Icons.restart_alt_rounded, color: Colors.greenAccent),
                                  backgroundColor: Colors.white,
                                  snackPosition: SnackPosition.TOP,
                                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                                  duration: const Duration(seconds: 2),
                                  isDismissible: true,
                                );
                              });
                            },
                            child: Text(
                              "Ok",
                              style: TextStyles.defaultStyle.blueTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: const Text("Nhập dữ liệu json"),
              ),

              // Đặt lại hệ thống
              PopupMenuItem(
                onTap: () {
                  Future.delayed(
                    const Duration(seconds: 0),
                    () => Get.dialog(
                      AlertDialog(
                        title: const Text('Đặt lại hệ thống'),
                        content: const Text(
                            'Điều này sẽ xoá tất cả dữ liệu liên quan trên hệ thống và bạn không thể hồi phục \n Bạn có chắc chắn muốn tiếp tục'),
                        actions: [
                          TextButton(
                            child: Text(
                              "Không",
                              style: TextStyles.defaultStyle.redTextColor,
                            ),
                            onPressed: () => Get.back(),
                          ),
                          TextButton(
                            onPressed: (() {
                              Future.delayed(
                                const Duration(milliseconds: 500),
                                widget.meshManagerApi.resetMeshNetwork,
                              ).whenComplete(() async {
                                Get.back();
                                Get.snackbar(
                                  "Dữ liệu",
                                  'Đặt lại hệ thống thành công',
                                  icon: const Icon(Icons.restart_alt_rounded, color: Colors.greenAccent),
                                  backgroundColor: Colors.white,
                                  snackPosition: SnackPosition.TOP,
                                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                                  duration: const Duration(seconds: 2),
                                  isDismissible: true,
                                );
                              });
                            }),
                            child: Text(
                              "Có",
                              style: TextStyles.defaultStyle.blueTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: const Text("Đặt lại hệ thống"),
              ),
            ],
            offset: const Offset(0, 50),
            color: Colors.white,
            elevation: 2,
          ),
        ],
      );
    }

    /// build boody
    Widget buildBody() {
      return SettingsList(
        physics: const BouncingScrollPhysics(),
        sections: [
          SettingsSection(
            tiles: <SettingsTile>[
              // hện tên mesh network
              SettingsTile.navigation(
                title: Text('Tên', style: TextStyles.defaultStyle.semibold),
                value: Text(name, style: TextStyles.defaultStyle),
              ),

              // hiện tổng số provisioner
              SettingsTile.navigation(
                title: Text('Provisioner', style: TextStyles.defaultStyle.semibold),
                value: Text(provisioners.length.toString(), style: TextStyles.defaultStyle),
              ),

              // hiện tổng số netkey
              SettingsTile.navigation(
                title: Text('Network Keys', style: TextStyles.defaultStyle.semibold),
                value: Text("1", style: TextStyles.defaultStyle),
              ),

              // hiện tổng số appkey
              SettingsTile.navigation(
                title: Text('App Keys', style: TextStyles.defaultStyle.semibold),
                value: Text('3', style: TextStyles.defaultStyle),
              ),
              // SettingsTile.navigation(
              //   title: Text('Ngữ cảnh', style: TextStyles.defaultStyle.semibold),
              //   value: Text('0', style: TextStyles.defaultStyle),
              // ),
              // SettingsTile.switchTile(
              //   onToggle: (value) {},
              //   initialValue: false,
              //   title: Text('Chế độ kiểm tra IV', style: TextStyles.defaultStyle.semibold),
              // ),
              // SettingsTile.navigation(
              //   title: Text('Chỉnh sửa lần cuối', style: TextStyles.defaultStyle.semibold),
              //   value: Text(lastReset, style: TextStyles.defaultStyle),
              // ),
            ],
          ),
          // SettingsSection(
          //   tiles: <SettingsTile>[
          //     SettingsTile.navigation(
          //       title: Text('Thông tim phiên bản', style: TextStyles.defaultStyle.semibold),
          //     ),
          //     SettingsTile.navigation(
          //       title: Text('Phiên bản phần mềm', style: TextStyles.defaultStyle.semibold),
          //       value: Text('1.0.0', style: TextStyles.defaultStyle),
          //     ),
          //   ],
          // ),
        ],
      );
    }

    return SafeArea(
        child: Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
    ));
  }
}
