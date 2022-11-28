import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

import '../../../../../../config/palettes.dart';
import '../../../../../../config/text_style.dart';
import '../provisioner/provisioner_detail.dart';

class AppkeyScreen extends StatefulWidget {
  final List<Provisioner> provisioners;
  final MeshManagerApi meshManagerApi;
  const AppkeyScreen({Key? key, required this.provisioners, required this.meshManagerApi}) : super(key: key);

  @override
  State<AppkeyScreen> createState() => _AppkeyScreenState();
}

class _AppkeyScreenState extends State<AppkeyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "NetKeys",
          style: TextStyles.defaultStyle.fontHeader.whiteTextColor,
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: Palettes.gradientAppBar),
        ),
        centerTitle: false,
      ),
      body: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 100),
        itemCount: widget.provisioners.length,
        itemBuilder: (context, index) {
          return InkWell(
              // chuyển sang trang cấu hình
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => ProvisionerDetail(
                        provisioner: widget.provisioners[index],
                      ),
                    ),
                  ),
              child: ListTile(
                leading: widget.provisioners[index].lastSelected == true
                    ? const Icon(
                        Icons.key_rounded,
                        color: Palettes.p7,
                      )
                    : null,
                // leading: const Icon(Icons.language_rounded),
                subtitle: Text(
                  '0x${widget.provisioners[index].provisionerAddress.toRadixString(16).padLeft(4, "0")}',
                  style: TextStyles.defaultStyle.regular,
                ),
                title: Text(
                  widget.provisioners[index].provisionerName,
                  style: TextStyles.defaultStyle.fontTitle,
                ),
              ));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Thêm Provisioner mới'),
        icon: const Icon(CupertinoIcons.add),
        onPressed: () async {
          // final iMeshNet = widget.meshManagerApi.meshNetwork;
          // iMeshNet!.addProvisioner(0x0002, 123456, 123456, 123, name: "HungNguyen");
          // setState(() {});
        },
      ),
    );
  }
}
