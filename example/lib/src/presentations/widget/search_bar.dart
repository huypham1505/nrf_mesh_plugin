import 'package:flutter/material.dart';
import '../../config/text_style.dart';

class SearchBar extends StatefulWidget {
  final String labelText;
  final IconData iconData;
  const SearchBar({
    Key? key,
    required this.labelText,
    required this.iconData,
  }) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        style: TextStyles.defaultStyle.italic,
        decoration: InputDecoration(
          prefixIcon: Icon(widget.iconData),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          labelText: widget.labelText,
        ),
      ),
    );
  }
}
