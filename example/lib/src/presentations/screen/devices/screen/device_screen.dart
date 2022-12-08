import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import '../../../../config/text_style.dart';
import '../../../widget/app_bar_main.dart';
import '../../../widget/no_found_screen.dart';
import '../details/product1/radar_detail_screen.dart';
import '../widget/provisioned_node.dart';
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
  Widget build(BuildContext context) => Scaffold(
      appBar: CustomAppBarMain(
        centerTitle: true,
        nrfMesh: widget.nrfMesh,
        title: "Thiết bị",
      ),
      body: Column(
        children: [
          // search thiết bị đã pair
          Container(
            height: 50,
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 5),
            child: TextField(
                onSubmitted: (value) => setState(() {
                      value;
                    }),
                onChanged: (value) => searchProvisioned(value),
                style: TextStyles.defaultStyle.italic,
                decoration: InputDecoration(
                    prefixIcon: const Icon(CupertinoIcons.circle_grid_hex_fill),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    labelText: "Tìm kiếm thiết bị....")),
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
                      child: RefreshIndicator(
                        onRefresh: () {
                          return Future.delayed(
                            const Duration(seconds: 3),
                            () {
                              setState(() {
                                // widget.meshNetwork.nodes.then((value) => setState(() => _nodes = value));
                              });
                            },
                          );
                        },
                        child: ListView.builder(
                          // shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 100),
                          itemCount: _nodes.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              // chuyển sang trang cấu hình
                              onTap: () {},
                              child: ProvisionedNodeItems(
                                node: _nodes[index],
                                testKey: 'node-${_nodes.indexOf(_nodes[index])}',
                              ),
                            );
                          },
                        ),
                      ),
                    )
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
      ),
      // floating btn
      floatingActionButton: FloatingActionButton.extended(
          label: const Text('Thêm thiết bị'),
          icon: const Icon(CupertinoIcons.add),
          onPressed: () => Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) {
                return UnProvisionedDeviceListScreen(
                  nrfMesh: widget.nrfMesh,
                );
              })).then((value) {
                setState(() {
                  // widget.meshNetwork.nodes.then((value) => setState(() => _nodes = value));
                });
              })));
}
