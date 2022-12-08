import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import '../../../../config/text_style.dart';
import 'element_data.dart';

class ProvisionedNodeItems extends StatefulWidget {
  final ProvisionedMeshNode node;
  final String testKey;
  const ProvisionedNodeItems({Key? key, required this.node, required this.testKey}) : super(key: key);

  @override
  State<ProvisionedNodeItems> createState() => _ProvisionedNodeItemsState();
}

class _ProvisionedNodeItemsState extends State<ProvisionedNodeItems> {
  String _name = 'loading...';
  List<ElementData> _elements = [];

  @override
  void initState() {
    super.initState();
    widget.node.elements.then((value) => setState(() => _elements = value));
    widget.node.name.then((value) => setState(() => _name = value.toString()));
  }

  @override
  void didUpdateWidget(covariant ProvisionedNodeItems oldWidget) {
    super.didUpdateWidget(oldWidget);
    // widget.node.elements.then((value) => setState(() => _elements = value));
    widget.node.name.then((value) => setState(() => _name = value.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key(widget.testKey),
      margin: const EdgeInsets.only(right: 10, left: 10, top: 5, bottom: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Image.asset(
          "assets/icons/paired_node.png",
          height: 40,
          width: 40,
        ),
        title: Text(
          _name,
          style: TextStyles.defaultStyle.medium,
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(widget.node.uuid, style: TextStyles.defaultStyle, maxLines: 1),
            // ..._elements.map((e) => ElementNodeData(elmentData: e)),
          ],
        ),
      ),
    );
  }
}
