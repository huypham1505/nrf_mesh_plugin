import 'package:flutter/material.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import '../../../config/palettes.dart';
import '../../../config/text_style.dart';

class GroupDetailScreen extends StatefulWidget {
  final GroupData groupData;
  const GroupDetailScreen({
    Key? key,
    required this.groupData,
  }) : super(key: key);

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  @override
  Widget build(BuildContext context) {
    /// build appbar
    void appBarActionOnTapped() {}

    PreferredSizeWidget buildAppBar() {
      return AppBar(
        title: Column(
          children: [
            Text(
              widget.groupData.name,
              style: TextStyles.defaultStyle.fontHeader.whiteTextColor,
            ),
            Text(
              ' 0x${widget.groupData.address.toRadixString(16)}',
              style: TextStyles.defaultStyle.whiteTextColor.regular,
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: Palettes.gradientAppBar),
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () => appBarActionOnTapped(),
            child: Text(
              "Kết nối",
              style: TextStyles.defaultStyle.bold.whiteTextColor,
            ),
          )
        ],
      );
    }

    /// build boody
    Widget buildBody() {
      return const Center(
        child: Text("Tính năng đang phát triển"),
      );
    }

    return SafeArea(
        child: Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
    ));
  }
}
