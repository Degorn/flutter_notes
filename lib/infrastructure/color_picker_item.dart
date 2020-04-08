import 'package:flutter/material.dart';
import 'package:notes/infrastructure/note_color.dart';

class ColorPickerItem extends StatefulWidget {
  final int colorIndex;
  final Function(bool isSelected) selectedCallback;
  final bool isSelected;

  ColorPickerItem({this.colorIndex, this.selectedCallback, this.isSelected});

  @override
  _ColorPickerItemState createState() => _ColorPickerItemState();
}

class _ColorPickerItemState extends State<ColorPickerItem> {
  var isSelected = false;

  @override
  Widget build(BuildContext context) {
    isSelected = widget.isSelected;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            isSelected = !isSelected;
            widget.selectedCallback(isSelected);
          });
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: noteColors[widget.colorIndex],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: isSelected
                ? Icon(
                    Icons.check,
                    size: 32,
                    color: Colors.white,
                  )
                : Icon(
                    Icons.check_box_outline_blank,
                    size: 32,
                    color: noteColors[widget.colorIndex],
                  ),
          ),
        ),
      ),
    );
  }
}
