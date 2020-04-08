import 'package:flutter/material.dart';
import 'package:notes/infrastructure/color_picker_item.dart';

class ColorPalette extends StatelessWidget {
  final List<ColorPickerItem> colorPalette;

  ColorPalette({this.colorPalette});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: colorPalette,
    );
  }
}
