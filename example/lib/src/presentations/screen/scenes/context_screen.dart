import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../config/palettes.dart';
import '../../../config/text_style.dart';

class SceneScreen extends StatefulWidget {
  const SceneScreen({Key? key}) : super(key: key);

  @override
  State<SceneScreen> createState() => _SceneScreenState();
}

class _SceneScreenState extends State<SceneScreen> {
  @override
  Widget build(BuildContext context) {
    /// build appbar
    void appBarActionOnTapped() {
      print("Appbar action tapped");
    }

    PreferredSizeWidget buildAppBar() {
      return AppBar(
        title: Text(
          "Mesh",
          style: TextStyles.defaultStyle.fontHeader.whiteTextColor,
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: Palettes.gradientAppBar),
        ),
        centerTitle: true,
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
      return const Center(child: Text("Tính năng đang được phát triển"));
    }

    /// build floating btn
    void floatingActionBtnOnTapped() {
      print("Tapped");
    }

    Widget buildFloatingActionBtn() {
      return FloatingActionButton.extended(
        label: const Text('Thêm ngữ cảnh'),
        icon: const Icon(CupertinoIcons.add),
        onPressed: () => floatingActionBtnOnTapped(),
      );
    }

    return SafeArea(
        child: Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
      floatingActionButton: buildFloatingActionBtn(),
    ));
  }
}
