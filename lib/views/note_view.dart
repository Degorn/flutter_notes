import 'package:flutter/material.dart';
import 'package:notes/infrastructure/color_palette/color_palette.dart';
import 'package:notes/infrastructure/color_picker_item.dart';
import 'package:notes/infrastructure/note_color.dart';
import 'package:notes/infrastructure/note_mode.dart';
import 'package:notes/infrastructure/providers/note_provider.dart';
import 'package:notes/models/note.dart';

class NoteView extends StatefulWidget {
  final NoteMode noteMode;
  final Note note;

  NoteView(this.noteMode, this.note);

  @override
  _NoteViewState createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  final colorPalette = List<ColorPickerItem>();

  List<int> colorsSelectedIndexes;

  @override
  void initState() {
    super.initState();

    colorsSelectedIndexes = widget.note?.colors ?? List<int>();

    noteColors.forEach((index, color) => {
          colorPalette.add(ColorPickerItem(
            colorIndex: index,
            selectedCallback: (isSelected) =>
                onColorSelected(index, isSelected),
            isSelected: colorsSelectedIndexes.contains(index),
          ))
        });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.noteMode == NoteMode.Editing) {
      titleController.text = widget.note.title;
      contentController.text = widget.note.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: buildAppBarTitle(),
        actions: <Widget>[
          FlatButton(
            child: Text('Save'),
            onPressed: () {
              final title = titleController.text;
              final content = contentController.text;
              final colorsIds = colorsSelectedIndexes;

              if (widget.noteMode == NoteMode.Adding) {
                NoteProvider.insertNote(Note(
                  title: title,
                  content: content,
                  colors: colorsIds,
                ));
              } else if (widget.noteMode == NoteMode.Editing) {
                NoteProvider.updateNote(Note(
                  id: widget.note.id,
                  title: title,
                  content: content,
                  colors: colorsIds,
                ));
              }

              Navigator.pop(context);
            },
          )
        ],
      ),
      body: buildNoteContent(),
    );
  }

  Widget buildNoteContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          SizedBox(
            height: 8.0,
          ),
          TextField(
            controller: contentController,
            decoration: InputDecoration(hintText: 'Content'),
          ),
          SizedBox(
            height: 24.0,
          ),
          buildColorSelectionPalette(),
        ],
      ),
    );
  }

  Widget buildColorSelectionPalette() {
    // return Row(
    //   children: colorPalette,
    // );

    return ColorPalette(
      colorPalette: colorPalette,
    );
  }

  Widget buildAppBarTitle() {
    return Text(widget.noteMode == NoteMode.Adding ? 'Add' : 'Edit');
  }

  onColorSelected(int index, bool isSelected) {
    if (isSelected) {
      colorsSelectedIndexes.add(index);
    } else {
      colorsSelectedIndexes.removeWhere((x) => x == index);
    }
  }
}
