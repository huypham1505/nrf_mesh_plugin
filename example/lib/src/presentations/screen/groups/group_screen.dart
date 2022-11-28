import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import '../../../config/palettes.dart';
import '../../../config/text_style.dart';
import 'group_detail.dart';

class GroupScreen extends StatefulWidget {
  final IMeshNetwork meshNetwork;
  final MeshManagerApi meshManagerApi;
  const GroupScreen({
    Key? key,
    required this.meshNetwork,
    required this.meshManagerApi,
  }) : super(key: key);

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  List<GroupData> _groups = [];
  List<GroupData> _searchGroups = [];
  late String inputSearch = "";
  final TextEditingController txtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.meshNetwork.groups.then((value) => setState(() => _groups = value.reversed.toList()));
  }

  @override
  void didUpdateWidget(covariant GroupScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.meshNetwork.groups.then((value) => setState(() => _groups = value.reversed.toList()));
  }

  @override
  void dispose() {
    super.dispose();
    txtController;
  }

// hàm fliter input search
  void searchData(String input) {
    inputSearch = input;
    if (inputSearch.isEmpty) {
      _searchGroups = _groups;
    } else {
      final data = _groups
          .where((element) =>
              // element.name.contains(input.toLowerCase()) ||
              element.name.toLowerCase().contains(inputSearch.toLowerCase()) ||
              element.address.toRadixString(16).contains(inputSearch.toLowerCase()))
          .toList();
      setState(() {
        _searchGroups = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    /// build appbar
    void appBarActionOnTapped() {}

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
      return Column(children: [
        Container(
          height: 50,
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 5),
          child: TextField(
              controller: txtController,
              onChanged: (value) => searchData(value),
              onSubmitted: (value) {
                setState(() {
                  value;
                });
              },
              style: TextStyles.defaultStyle.italic,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.groups_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  labelText: "Tìm kiếm nhóm....")),
        ),
        // hiển thị tổng số nhóm
        Text(
          inputSearch == "" ? 'Tổng số nhóm (${_groups.length})' : 'Tổng số node (${_searchGroups.length})',
          style: TextStyles.defaultStyle.bold,
        ),
        _groups.isEmpty
            ? Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          CupertinoIcons.antenna_radiowaves_left_right,
                          size: 30,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Không có nhóm nào được thêm",
                          style: TextStyles.defaultStyle.bold.blueTextColor,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            :
            // Check input trỗng thì hiển thị danh sách group
            //else hiện thị danh sách search
            inputSearch == ""
                ? Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _groups.length,
                      itemBuilder: (context, index) => GestureDetector(
                        // xoá nhóm
                        onLongPress: () {
                          Get.bottomSheet(
                            SizedBox(
                              height: 150,
                              child: Column(
                                children: [
                                  const SizedBox(height: 20),
                                  Text(
                                    'Bạn muốn ?',
                                    style: TextStyles.defaultStyle.fontHeader.redTextColor.bold,
                                  ),
                                  TextButton(
                                      onPressed: () async {
                                        await widget.meshManagerApi.meshNetwork!.removeGroup(_groups[index].address);
                                        Get.back();
                                        setState(() {});
                                        Get.snackbar(
                                          "Cập nhật",
                                          "Xoá nhóm ${_groups[index].name} thành công",
                                          icon: const Icon(Icons.done, color: Colors.green),
                                          backgroundColor: Colors.white,
                                          snackPosition: SnackPosition.TOP,
                                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                                          duration: const Duration(seconds: 2),
                                          isDismissible: true,
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.delete,
                                            color: Palettes.p7,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Xoá nhóm',
                                            style: TextStyles.defaultStyle.redTextColor,
                                          ),
                                        ],
                                      )),
                                  TextButton(
                                      onPressed: () {},
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.auto_fix_high_sharp,
                                            color: Palettes.p8,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Chỉnh sửa tên nhóm',
                                            style: TextStyles.defaultStyle.blueTextColor,
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            backgroundColor: Colors.white,
                            elevation: 3,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                          );
                        },
                        // chuyển đến trang cấu hình nhóm
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) {
                            return GroupDetailScreen(groupData: _groups[index]);
                          }));
                        },
                        // hiện thị thông tin name,địa chỉ nhóm
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          decoration:
                              BoxDecoration(gradient: Palettes.gradientBoxCus, borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Tên: ${_groups[index].name}',
                                  style: TextStyles.defaultStyle.whiteTextColor.bold.medium,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Địa chỉ: 0x${_groups[index].address.toRadixString(16)}',
                                  style: TextStyles.defaultStyle.whiteTextColor.medium,
                                ),
                                // const SizedBox(
                                //   height: 5,
                                // ),
                                // Text(
                                //   _groups[index].parentAddress.toString(),
                                //   style: TextStyles.defaultStyle.whiteTextColor.medium,
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _searchGroups.length,
                      itemBuilder: (context, index) => GestureDetector(
                        // xoá nhóm
                        onLongPress: () {
                          Get.bottomSheet(
                            SizedBox(
                              height: 150,
                              child: Column(
                                children: [
                                  const SizedBox(height: 20),
                                  Text(
                                    'Bạn muốn ?',
                                    style: TextStyles.defaultStyle.fontHeader.redTextColor.bold,
                                  ),
                                  TextButton(
                                      onPressed: () async {
                                        await widget.meshManagerApi.meshNetwork!
                                            .removeGroup(_searchGroups[index].address);
                                        Get.back();
                                        setState(() {});
                                        Get.snackbar(
                                          "Cập nhật",
                                          "Xoá nhóm ${_searchGroups[index].name} thành công",
                                          icon: const Icon(Icons.done, color: Colors.green),
                                          backgroundColor: Colors.white,
                                          snackPosition: SnackPosition.TOP,
                                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                                          duration: const Duration(seconds: 2),
                                          isDismissible: true,
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.delete,
                                            color: Palettes.p7,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Xoá nhóm',
                                            style: TextStyles.defaultStyle.redTextColor,
                                          ),
                                        ],
                                      )),
                                  TextButton(
                                      onPressed: () {},
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.auto_fix_high_sharp,
                                            color: Palettes.p8,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Chỉnh sửa tên nhóm',
                                            style: TextStyles.defaultStyle.blueTextColor,
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            backgroundColor: Colors.white,
                            elevation: 3,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                          );
                        },
                        // chuyển đến trang cấu hình nhóm
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) {
                            return GroupDetailScreen(groupData: _searchGroups[index]);
                          }));
                        },
                        // hiện thị thông tin name,địa chỉ nhóm
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          decoration:
                              BoxDecoration(gradient: Palettes.gradientBoxCus, borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Tên: ${_searchGroups[index].name}',
                                  style: TextStyles.defaultStyle.whiteTextColor.bold.medium,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Địa chỉ: 0x${_searchGroups[index].address.toRadixString(16)}',
                                  style: TextStyles.defaultStyle.whiteTextColor.medium,
                                ),
                                // const SizedBox(
                                //   height: 5,
                                // ),
                                // Text(
                                //   _groups[index].parentAddress.toString(),
                                //   style: TextStyles.defaultStyle.whiteTextColor.medium,
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
      ]);
    }

    /// build floating btn
    /// thêm nhóm mới
    Widget buildFloatingActionBtn() {
      return FloatingActionButton.extended(
        label: const Text('Thêm nhóm'),
        icon: const Icon(CupertinoIcons.add),
        onPressed: () async {
          final groupName = await showDialog<String>(
              context: context,
              builder: (c) {
                String? groupName;
                return AlertDialog(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  title: Text(
                    "Tạo nhóm",
                    style: TextStyles.defaultStyle.bold.fontHeader.redTextColor,
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        autofocus: true,
                        // controller: textGroupName,
                        style: TextStyles.defaultStyle,
                        decoration: InputDecoration(
                          labelText: "Nhập tên nhóm mới",
                          prefixIcon: const Icon(Icons.group_work_sharp),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onChanged: (textGroupName) => groupName = textGroupName,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        readOnly: true,
                        enableInteractiveSelection: false,
                        style: TextStyles.defaultStyle,
                        decoration: InputDecoration(
                          hintText: _groups.length < 10
                              ? '0xC00${_groups.length}'
                              : _groups.length > 100
                                  ? '0xC${_groups.length}'
                                  : '0xC0${_groups.length}',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        // onChanged: (textGroupName) =>
                        //     groupName = textGroupName,
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(c, groupName);
                      },
                      child: Text(
                        'OK',
                        style: TextStyles.customStyle,
                      ),
                    ),
                  ],
                );
              });
          if (groupName != null && groupName.isNotEmpty) {
            try {
              await widget.meshManagerApi.meshNetwork!.addGroupWithName(groupName);
              Get.snackbar(
                "Thông báo",
                "Tạo nhóm $groupName thành công",
                icon: const Icon(Icons.done, color: Colors.green),
                backgroundColor: Colors.white,
                snackPosition: SnackPosition.TOP,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                duration: const Duration(seconds: 2),
                isDismissible: true,
              );
              // widget.meshNetwork.groups.then((value) => setState(() => _groups = value.reversed.toList()));
            } on PlatformException catch (e) {
              debugPrint(e.toString());
              Get.snackbar(
                "Lỗi",
                'erorr: ${e.message}',
                icon: const Icon(Icons.error_rounded, color: Colors.yellowAccent),
                backgroundColor: Colors.white,
                snackPosition: SnackPosition.TOP,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                duration: const Duration(seconds: 2),
                isDismissible: true,
              );
            } catch (e) {
              debugPrint(e.toString());
              Get.snackbar(
                "Lỗi",
                'erorr: ${e.toString()}',
                icon: const Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
                backgroundColor: Colors.white70,
                snackPosition: SnackPosition.TOP,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                duration: const Duration(seconds: 2),
                isDismissible: true,
              );
            }
          } else {
            Get.snackbar(
              "Thông báo",
              'Bạn chưa đặt tên nhóm',
              icon: const Icon(Icons.format_shapes_outlined, color: Colors.blueAccent),
              backgroundColor: Colors.white,
              snackPosition: SnackPosition.TOP,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              duration: const Duration(seconds: 2),
              isDismissible: true,
            );
          }
        },
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
