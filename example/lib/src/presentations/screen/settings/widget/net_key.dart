import 'package:flutter/material.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

import '../../../../config/palettes.dart';
import '../../../../config/text_style.dart';

class NetKey extends StatefulWidget {
  final NetworkKey netKey;
  const NetKey({Key? key, required this.netKey}) : super(key: key);

  @override
  State<NetKey> createState() => _NetKeyState();
}

class _NetKeyState extends State<NetKey> {
  @override
  void initState() {
    super.initState();
    debugPrint(widget.netKey.netKeyIndex.toString());
    debugPrint(widget.netKey.name.toString());
    debugPrint(widget.netKey.meshUuid.toString());
    debugPrint(widget.netKey.identityKey.toString());
    debugPrint(widget.netKey.netKeyBytes.toString());
    debugPrint(widget.netKey.oldIdentityKey.toString());
    debugPrint(widget.netKey.oldNetKeyBytes.toString());
    debugPrint(widget.netKey.phase.toString());
    debugPrint(widget.netKey.runtimeType.toString());
    debugPrint(widget.netKey.phaseDescription.toString());
  }

  @override
  Widget build(BuildContext context) {
    /// build appbar
    PreferredSizeWidget buildAppBar() {
      return AppBar(
        title: Text(
          "Quản lý NetWork Key",
          style: TextStyles.defaultStyle.fontHeader.whiteTextColor,
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: Palettes.gradientAppBar),
        ),
        centerTitle: false,
      );
    }

    /// build boody
    Widget buildBody() {
      return Column(
        children: [
          ListTile(
            title: Text(
              'Network Key ${widget.netKey.netKeyIndex}',
              style: TextStyles.defaultStyle.bold,
            ),
            // subtitle: Text(
            //   'Network Key ${widget.netKey.}',
            //   style: TextStyles.defaultStyle.bold,
            // ),
          ),
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
