import 'dart:async';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import '../../../../presentations/widget/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';
import '../../../../config/text_style.dart';

class DeviceControllModule extends StatefulWidget {
  final DiscoveredDevice device;
  final ProvisionedMeshNode nodeData;
  final MeshManagerApi meshManagerApi;

  const DeviceControllModule({
    Key? key,
    required this.device,
    required this.meshManagerApi,
    required this.nodeData,
  }) : super(key: key);

  @override
  State<DeviceControllModule> createState() => _DeviceControllModuleState();
}

class _DeviceControllModuleState extends State<DeviceControllModule> {
  final bleMeshManager = BleMeshManager();

  late String nodeName = 'Loading';
  bool isLoading = true;
  late List<ProvisionedMeshNode> nodes;
  List<ElementData> _elements = [];

  // auto set blind appkey
  Future<void> _init() async {
    bleMeshManager.callbacks = DoozProvisionedBleMeshManagerCallbacks(widget.meshManagerApi, bleMeshManager);
    await bleMeshManager.connect(widget.device);
    // get nodes (ignore first node which is the default provisioner)
    nodes = (await widget.meshManagerApi.meshNetwork!.nodes).skip(1).toList();
    // will bind app keys (needed to be able to configure node)
    for (final node in nodes) {
      final elements = await node.elements;
      for (final element in elements) {
        // elementData = element;
        debugPrint('Element data cua thiet bi: ${element.address.toString()}');
        for (final model in element.models) {
          if (model.boundAppKey.isEmpty) {
            if (element == elements.first && model == element.models.first) {
              continue;
            }
            final unicast = await node.unicastAddress;
            debugPrint('need to bind app key');
            await widget.meshManagerApi.sendConfigModelAppBind(
              unicast,
              element.address,
              model.modelId,
            );
          }
        }
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  void _deinit() async {
    await bleMeshManager.disconnect();
    await bleMeshManager.callbacks!.dispose();
  }

  @override
  void initState() {
    super.initState();
    _init();
    widget.nodeData.name.then((value) => setState(() => nodeName = value));
    widget.nodeData.elements.then((value) => setState(() => _elements = value));
  }

  @override
  void dispose() {
    _deinit();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// build boody
    Widget buildBody() {
      return SettingsList(
        physics: const BouncingScrollPhysics(),
        sections: [
          SettingsSection(
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                onPressed: (context) {},
                leading: const Icon(Icons.label),
                title: Text('Tên', style: TextStyles.defaultStyle.semibold),
                value: Text(nodeName, style: TextStyles.defaultStyle),
              ),
            ],
          ),
          SettingsSection(
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.list_alt_rounded),
                title: Text('Elements', style: TextStyles.defaultStyle.semibold),
                value: ListView.builder(
                  itemBuilder: (context, index) =>
                      Text(_elements[index].address.toString(), style: TextStyles.defaultStyle),
                ),
              ),
            ],
          ),
          SettingsSection(
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.key_sharp),
                title: Text('Network Keys', style: TextStyles.defaultStyle.semibold),
                value: Text('1', style: TextStyles.defaultStyle),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.key_rounded),
                title: Text('Application Keys', style: TextStyles.defaultStyle.semibold),
                value: Text('0', style: TextStyles.defaultStyle),
              ),
            ],
          ),
        ],
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: "Cấu hình thiết bị",
        centerTitle: false,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(CupertinoIcons.back),
        ),
      ),
      body: buildBody(),
    );
  }
}

class DoozProvisionedBleMeshManagerCallbacks extends BleMeshManagerCallbacks {
  final MeshManagerApi meshManagerApi;
  final BleMeshManager bleMeshManager;

  late StreamSubscription<ConnectionStateUpdate> onDeviceConnectingSubscription;
  late StreamSubscription<ConnectionStateUpdate> onDeviceConnectedSubscription;
  late StreamSubscription<BleManagerCallbacksDiscoveredServices> onServicesDiscoveredSubscription;
  late StreamSubscription<DiscoveredDevice> onDeviceReadySubscription;
  late StreamSubscription<BleMeshManagerCallbacksDataReceived> onDataReceivedSubscription;
  late StreamSubscription<BleMeshManagerCallbacksDataSent> onDataSentSubscription;
  late StreamSubscription<ConnectionStateUpdate> onDeviceDisconnectingSubscription;
  late StreamSubscription<ConnectionStateUpdate> onDeviceDisconnectedSubscription;
  late StreamSubscription<List<int>> onMeshPduCreatedSubscription;

  DoozProvisionedBleMeshManagerCallbacks(this.meshManagerApi, this.bleMeshManager) {
    onDeviceConnectingSubscription = onDeviceConnecting.listen((event) {
      debugPrint('onDeviceConnecting $event');
    });
    onDeviceConnectedSubscription = onDeviceConnected.listen((event) {
      debugPrint('onDeviceConnected $event');
    });

    onServicesDiscoveredSubscription = onServicesDiscovered.listen((event) {
      debugPrint('onServicesDiscovered');
    });

    onDeviceReadySubscription = onDeviceReady.listen((event) async {
      debugPrint('onDeviceReady ${event.id}');
    });

    onDataReceivedSubscription = onDataReceived.listen((event) async {
      debugPrint('onDataReceived ${event.device.id} ${event.pdu} ${event.mtu}');
      await meshManagerApi.handleNotifications(event.mtu, event.pdu);
    });
    onDataSentSubscription = onDataSent.listen((event) async {
      debugPrint('onDataSent ${event.device.id} ${event.pdu} ${event.mtu}');
      await meshManagerApi.handleWriteCallbacks(event.mtu, event.pdu);
    });

    onDeviceDisconnectingSubscription = onDeviceDisconnecting.listen((event) {
      debugPrint('onDeviceDisconnecting $event');
    });
    onDeviceDisconnectedSubscription = onDeviceDisconnected.listen((event) {
      debugPrint('onDeviceDisconnected $event');
    });

    onMeshPduCreatedSubscription = meshManagerApi.onMeshPduCreated.listen((event) async {
      debugPrint('onMeshPduCreated $event');
      await bleMeshManager.sendPdu(event);
    });
  }

  @override
  Future<void> dispose() => Future.wait([
        onDeviceConnectingSubscription.cancel(),
        onDeviceConnectedSubscription.cancel(),
        onServicesDiscoveredSubscription.cancel(),
        onDeviceReadySubscription.cancel(),
        onDataReceivedSubscription.cancel(),
        onDataSentSubscription.cancel(),
        onDeviceDisconnectingSubscription.cancel(),
        onDeviceDisconnectedSubscription.cancel(),
        onMeshPduCreatedSubscription.cancel(),
        super.dispose(),
      ]);

  @override
  Future<void> sendMtuToMeshManagerApi(int mtu) => meshManagerApi.setMtu(mtu);
}
