import 'package:flutter/material.dart';
import 'package:skg_refactoring/app/utils/hex_color.dart';

class CustomDropDown extends StatelessWidget {
  final String? label;
  final String? hintText;
  final String? errorMessage;
  final dynamic value;
  final Function(dynamic v)? onChangedF;
  final List<DropdownMenuItem> childrens;
  final bool isExpanded;

  const CustomDropDown({
    Key? key,
    this.label,
    required this.onChangedF,
    required this.childrens,
    this.hintText = '',
    this.errorMessage,
    this.value,
    this.isExpanded = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      menuMaxHeight: 300,
      value: value,
      hint: Text(
        hintText!,
        style: TextStyle(
            color: HexColor("#E6EFFD"),
            fontWeight: FontWeight.normal,
            fontSize: 16.0),
      ),
      icon: const Icon(Icons.keyboard_arrow_down_sharp),
      iconSize: 25,
      iconDisabledColor: HexColor("#9FDF20"),
      iconEnabledColor: HexColor("#9FDF20"),
      dropdownColor: HexColor("#1C2333"),
      decoration: InputDecoration(
        hintStyle: TextStyle(fontSize: 16.0, color: HexColor("#E6EFFD")),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: HexColor("#E6EFFD"))),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: HexColor("#E6EFFD"))),
      ),
      isExpanded: isExpanded,
      elevation: 2,
      onChanged: onChangedF,
      items: [
        DropdownMenuItem(
          value: "--empty--",
          child: Text(
            label ?? "",
            style: TextStyle(color: HexColor("#E6EFFD")),
          ),
        ),
        ...childrens,
      ],
      style: TextStyle(
          color: HexColor("#E6EFFD"),
          fontWeight: FontWeight.normal,
          fontSize: 16.0),
    );
  }
}
