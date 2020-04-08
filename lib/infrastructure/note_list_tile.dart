import 'package:flutter/material.dart';
import 'package:notes/infrastructure/note_color.dart';
import 'package:notes/models/note.dart';
import 'package:notes/views/note_list_view.dart';

import 'note_mode.dart';

class NoteListTile extends StatefulWidget {
  final Note note;
  final bool isSelectModeEnabled;
  final Function(bool isSelected) onSelectionChanged;
  final bool isSelected;

  const NoteListTile(
      {Key key, this.note, this.isSelectModeEnabled, this.onSelectionChanged, this.isSelected})
      : super(key: key);

  @override
  _NoteListTileState createState() => _NoteListTileState();
}

class _NoteListTileState extends State<NoteListTile> {
  bool isSelected = false;

  @override
  void initState() {
    super.initState();

    isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 80,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildCheckbox(),
            Expanded(
              flex: 5,
              child: buildListTile(),
            ),
            Expanded(
              flex: 3,
              child: buildColorLabels(),
            ),
            Expanded(
              flex: 2,
              child: buildEditButton(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListTile() {
    return Center(
      child: ListTile(
        title: Text(widget.note.title),
        subtitle: Text(
          widget.note.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget buildEditButton(BuildContext context) {
    return !widget.isSelectModeEnabled
        ? FlatButton(
            child: Text('Edit'),
            onPressed: () =>
                navigateToNote(context, NoteMode.Editing, widget.note),
          )
        : SizedBox();
  }

  Widget buildCheckbox() {
    return widget.isSelectModeEnabled
        ? Checkbox(
            value: isSelected,
            onChanged: (value) {
              setState(() {
                isSelected = value;
              });

              widget.onSelectionChanged(isSelected);
            },
          )
        : SizedBox();
  }

  Widget buildColorLabels() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.note.colors != null)
          for (var i = 0; i < widget.note.colors.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                width: 12,
                height: 36,
                color: noteColors[widget.note.colors[i]],
              ),
            ),
      ],
    );
  }
}
