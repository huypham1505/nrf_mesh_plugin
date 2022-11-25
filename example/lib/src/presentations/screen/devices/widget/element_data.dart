import 'package:flutter/material.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

class ElementNodeData extends StatelessWidget {
  final ElementData elmentData;
  const ElementNodeData({Key? key, required this.elmentData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tên: ${elmentData.name}'),
        Text('Address: ${elmentData.address}'),
        Text('Models: ${elmentData.models.length}'),
        // ...elmentData.models.map((e) => ModelNode(e)),
      ],
    );
  }
}
