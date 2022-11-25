import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import '../../../../config/palettes.dart';
import '../../../../config/text_style.dart';
import '../../../widget/no_found_screen.dart';
import '../details/product1/radar_detail_screen.dart';
import '../widget/provisioned_node.dart';
import 'scanning_provisioned_screen.dart';
import 'scanning_unprovision_screen.dart';

class DeviceScreen extends StatefulWidget {
  final IMeshNetwork meshNetwork;
  final NordicNrfMesh nrfMesh;
  const DeviceScreen({
    Key? key,
    required this.meshNetwork,
    required this.nrfMesh,
  }) : super(key: key);

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  List<ProvisionedMeshNode> _nodes = [];
  List<ProvisionedMeshNode> _searchNodes = [];
  late String inputSearch = "";
  late String _name = "";

  @override
  void initState() {
    super.initState();
    widget.meshNetwork.nodes.then((value) => setState(() => _nodes = value.reversed.toList()));
  }

  @override
  void didUpdateWidget(covariant DeviceScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.meshNetwork.nodes.then((value) => setState(() => _nodes = value.reversed.toList()));
  }

// hàm search thiết bị
  void searchProvisioned(String input) {
    inputSearch = input;
    if (inputSearch.isEmpty) {
      _searchNodes = _nodes;
    } else {
      final data = _nodes.where((element) =>
          //   element.name.contains(input.toLowerCase()) ||
          element.uuid.toLowerCase().contains(inputSearch.toLowerCase())).toList();
      setState(() {
        _searchNodes = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    /// build appbar
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
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) {
                return ProvisionedDeviceListScreen(nrfMesh: widget.nrfMesh);
              }));
            },
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
      return Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          // search thiết bị đã pair
          Container(
            margin: const EdgeInsets.all(10),
            child: TextField(
                onSubmitted: (value) => setState(() {
                      value;
                    }),
                onChanged: (value) => searchProvisioned(value),
                style: TextStyles.defaultStyle.italic,
                decoration: InputDecoration(
                    prefixIcon: const Icon(CupertinoIcons.waveform),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    labelText: "Tìm kiếm thiết bị")),
          ),

          Text(
            inputSearch == "" ? 'Tổng số node (${_nodes.length})' : 'Tổng số node (${_searchNodes.length})',
            style: TextStyles.defaultStyle.bold,
          ),
          _nodes.isEmpty
              ? const NoFoundScreen(isScanScreen: false)
              :
              // nếu inputsearch emty thì hiển thị danh sách node
              // else hiển thị danh sách search node
              inputSearch == ""
                  ? Expanded(
                      child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: _nodes.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                            // chuyển sang trang cấu hình
                            onTap: () => Navigator.push(context,
                                MaterialPageRoute<void>(builder: (BuildContext context) => const RadarDetailScreen())),
                            child: ProvisionedNodeItems(
                                node: _nodes[index], testKey: 'node-${_nodes.indexOf(_nodes[index])}'));
                      },
                    ))
                  : Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 100),
                        // shrinkWrap: true,
                        itemCount: _searchNodes.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                              // chuyển sang trang cấu hình
                              onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) => const RadarDetailScreen(),
                                    ),
                                  ),
                              child: ProvisionedNodeItems(
                                  node: _searchNodes[index],
                                  testKey: 'node-${_searchNodes.indexOf(_searchNodes[index])}'));
                        },
                      ),
                    ),
        ],
      );
    }

    /// build floating btn
    /// chuyển qua trang scan thiết bị
    void floatingActionBtnOnTapped() {
      Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) {
        return UnProvisionedDeviceListScreen(
          nrfMesh: widget.nrfMesh,
        );
      })).then((value) {
        setState(() {
          widget.meshNetwork.nodes.then((value) => setState(() => _nodes = value));
        });
      });
    }

    Widget buildFloatingActionBtn() {
      return FloatingActionButton.extended(
        label: const Text('Thêm thiết bị'),
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
