import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

import '../../../../../../config/text_style.dart';
import '../../../screen/details/provisioner/provisioner_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../config/palettes.dart';

class ProvisionerScreen extends StatefulWidget {
  final List<Provisioner> provisioners;
  final MeshManagerApi meshManagerApi;
  const ProvisionerScreen({
    Key? key,
    required this.provisioners,
    required this.meshManagerApi,
  }) : super(key: key);

  @override
  State<ProvisionerScreen> createState() => _ProvisionerScreenState();
}

class _ProvisionerScreenState extends State<ProvisionerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Provisioner",
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
          final meshNetwork = widget.meshManagerApi.meshNetwork;
          await meshNetwork!.addProvisioner(0x0888, 0x02F6, 0x0888, 5);
          setState(() {});
        },
      ),
    );
  }
}
