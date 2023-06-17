import 'package:flutter/material.dart';

class MyDropDownMenu extends StatefulWidget {
  final String dropdownValue;
  final Function(String? value) onChange;
  final List<String> items;
  const MyDropDownMenu(
      {super.key,
      required this.dropdownValue,
      required this.onChange,
      required this.items});

  @override
  State<MyDropDownMenu> createState() => _MyDropDownMenuState();
}

class _MyDropDownMenuState extends State<MyDropDownMenu> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.dropdownValue,
      items: widget.items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        widget.onChange(newValue);
      },
    );
  }
}
