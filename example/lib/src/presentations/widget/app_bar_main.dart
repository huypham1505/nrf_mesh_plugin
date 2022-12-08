import 'package:flutter/material.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

import '../../config/palettes.dart';
import '../../config/text_style.dart';
import '../screen/devices/screen/scanning_provisioned_screen.dart';

class CustomAppBarMain extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final NordicNrfMesh nrfMesh;
  final bool isMainBar;
  final Widget leading;
  final String subTitle;
  const CustomAppBarMain({
    Key? key,
    required this.nrfMesh,
    required this.title,
    required this.centerTitle,
    this.isMainBar = true,
    this.leading = const SizedBox(),
    this.subTitle = "",
  }) : super(key: key);

  @override
  State<CustomAppBarMain> createState() => _CustomAppBarMainState();

  @override
  Size get preferredSize => const Size(double.maxFinite, 60);
}

class _CustomAppBarMainState extends State<CustomAppBarMain> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: widget.leading,
      title: widget.isMainBar == true
          ? Text(
              widget.title,
              style: TextStyles.defaultStyle.fontHeader.whiteTextColor.bold.textSpacing(1),
            )
          : Column(
              children: [
                Text(
                  widget.title,
                  style: TextStyles.defaultStyle.fontHeader.whiteTextColor.bold.textSpacing(1),
                ),
                Text(
                  widget.subTitle,
                  style: TextStyles.defaultStyle.whiteTextColor,
                )
              ],
            ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(gradient: Palettes.gradientAppBar),
      ),
      centerTitle: widget.centerTitle,
      actions: [
        widget.isMainBar == true
            ? TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) {
                    return ProvisionedDeviceListScreen(nrfMesh: widget.nrfMesh);
                  }));
                },
                child: Text("Kết nối", style: TextStyles.defaultStyle.bold.whiteTextColor))
            : const SizedBox()
      ],
    );
  }
}
