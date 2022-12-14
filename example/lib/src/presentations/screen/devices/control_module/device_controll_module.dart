import 'dart:async';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import '../../../../presentations/widget/app_bar.dart';
import 'package:flutter/material.dart';
import '../../../../config/text_style.dart';
import '../widget/element_data.dart';
import 'commands/generic/send_generic_level_get.dart';
import 'commands/generic/send_generic_on_off_set.dart';
import 'commands/lighting/send_light_hsl.dart';
import 'commands/pub-sub/send_config_model_publication_add.dart';
import 'commands/pub-sub/send_config_model_subscription_add.dart';
import 'commands/send_deprovisioning.dart';

class DeviceControllModule extends StatefulWidget {
  final ProvisionedMeshNode nodeData;
  final MeshManagerApi meshManagerApi;

  const DeviceControllModule({
    Key? key,
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
  int uniCast = 0;
  int ttl = 0;
  String deviceKey = "";
  late int intSeq = 0;

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
    widget.nodeData.unicastAddress.then((value) => setState(() => uniCast = value));
  }

  @override
  void dispose() {
    _deinit();
    super.dispose();
  }

  @override
  void didUpdateWidget(DeviceControllModule oldWidget) {
    super.didUpdateWidget(oldWidget);
    _init();
    widget.nodeData.name.then((value) => setState(() => nodeName = value));
    widget.nodeData.elements.then((value) => setState(() => _elements = value));
    widget.nodeData.unicastAddress.then((value) => setState(() => uniCast = value));
  }

  // auto set blind appkey
  Future<void> _init() async {
    intSeq = await widget.meshManagerApi.getSequenceNumber(widget.nodeData);
    await widget.meshManagerApi.sendConfigCompositionDataGet(uniCast);
  }

  @override
  Widget build(BuildContext context) {
    /// build boody
    Widget buildBody() {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(nodeName, style: TextStyles.defaultStyle),
            Text(widget.nodeData.uuid, style: TextStyles.defaultStyle),
            Text(_elements.length.toString(), style: TextStyles.defaultStyle),
            Text(ttl.toString(), style: TextStyles.defaultStyle),
            Text(uniCast.toRadixString(16).padLeft(4, '0').toString(), style: TextStyles.defaultStyle),
            ..._elements.map(
              (e) => ElementNodeData(elmentData: e),
            ),
            SendGenericLevel(meshManagerApi: widget.meshManagerApi),
            SendGenericOnOffSet(meshManagerApi: widget.meshManagerApi),
            SendConfigModelPublicationAdd(widget.meshManagerApi),
            SendConfigModelSubscriptionAdd(widget.meshManagerApi),
            SendLightHsl(meshManagerApi: widget.meshManagerApi, sequence: intSeq),
            SendDeprovisioning(meshManagerApi: widget.meshManagerApi),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(title: nodeName, centerTitle: false),
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
