import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../../../config/palettes.dart';
import '../../../../config/text_style.dart';

class ProvisioningDeviceScreen extends StatefulWidget {
  final DiscoveredDevice device;

  const ProvisioningDeviceScreen({Key? key, required this.device}) : super(key: key);

  @override
  State<ProvisioningDeviceScreen> createState() => _ProvisioningDeviceScreenState();
}

class _ProvisioningDeviceScreenState extends State<ProvisioningDeviceScreen> {
  @override
  Widget build(BuildContext context) {
    /// build appbar
    PreferredSizeWidget buildAppBar() {
      return AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "",
              style: TextStyles.defaultStyle.fontHeader.whiteTextColor,
            ),
            Text(
              "",
              style: TextStyles.defaultStyle.whiteTextColor,
            )
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: Palettes.gradientAppBar),
        ),
      );
    }

    /// build body
    Widget buildBody() {
      return SettingsList(
        physics: const BouncingScrollPhysics(),
        sections: [
          SettingsSection(
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Image.asset(
                  "assets/icons/mesh_name.png",
                  height: 30,
                  width: 30,
                ),
                title: Text('Tên', style: TextStyles.defaultStyle.semibold),
                value: Text(widget.device.name, style: TextStyles.defaultStyle),
              ),
              SettingsTile.navigation(
                leading: Image.asset(
                  "assets/icons/provisioner.png",
                  height: 30,
                  width: 30,
                ),
                title: Text('Provisioner', style: TextStyles.defaultStyle.semibold),
                // value: Text(widget.device., style: TextStyles.defaultStyle),
              ),
              SettingsTile.navigation(
                leading: Image.asset(
                  "assets/icons/network_key.png",
                  height: 30,
                  width: 30,
                ),
                title: Text('Network Keys', style: TextStyles.defaultStyle.semibold),
                value: Text("", style: TextStyles.defaultStyle),
              ),
              SettingsTile.navigation(
                leading: Image.asset(
                  "assets/icons/app_key.png",
                  height: 30,
                  width: 30,
                ),
                title: Text('App Keys', style: TextStyles.defaultStyle.semibold),
                value: Text('3', style: TextStyles.defaultStyle),
              ),
              SettingsTile.navigation(
                leading: Image.asset(
                  "assets/icons/scene.png",
                  height: 30,
                  width: 30,
                ),
                title: Text('Ngữ cảnh', style: TextStyles.defaultStyle.semibold),
                value: Text('0', style: TextStyles.defaultStyle),
              ),
              SettingsTile.switchTile(
                onToggle: (value) {},
                initialValue: false,
                leading: Image.asset(
                  "assets/icons/mode.png",
                  height: 30,
                  width: 30,
                ),
                title: Text('Chế độ kiểm tra IV', style: TextStyles.defaultStyle.semibold),
              ),
              // SettingsTile.navigation(
              //   leading: Image.asset(
              //     "assets/icons/version.png",
              //     height: 30,
              //     width: 30,
              //   ),
              //   title: Text('Apollo Smart', style: TextStyles.defaultStyle.semibold),
              //   value: Text('Thiết bị online', style: TextStyles.defaultStyle),
              // ),
              SettingsTile.navigation(
                leading: Image.asset(
                  "assets/icons/hourglass.png",
                  height: 30,
                  width: 30,
                ),
                title: Text('Chỉnh sửa lần cuối', style: TextStyles.defaultStyle.semibold),
                // value: Text(lastReset, style: TextStyles.defaultStyle),
              ),
            ],
          ),
          SettingsSection(
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Image.asset(
                  "assets/icons/information.png",
                  height: 30,
                  width: 30,
                ),
                title: Text('Thông tim phiên bản', style: TextStyles.defaultStyle.semibold),
              ),
              SettingsTile.navigation(
                leading: Image.asset(
                  "assets/icons/version.png",
                  height: 30,
                  width: 30,
                ),
                title: Text('Phiên bản phần mềm', style: TextStyles.defaultStyle.semibold),
                value: Text('1.0.0', style: TextStyles.defaultStyle),
              ),
            ],
          ),
        ],
      );
    }

    return Scaffold(
      appBar: buildAppBar(),
      body: Container(),
    );
  }
}
