import 'package:flutter/material.dart';
import 'package:notes/infrastructure/color_palette/color_palette.dart';
import 'package:notes/infrastructure/color_picker_item.dart';
import 'package:notes/infrastructure/note_color.dart';
import 'package:notes/infrastructure/note_list_tile.dart';
import 'package:notes/infrastructure/note_mode.dart';
import 'package:notes/infrastructure/notes_app_bar.dart';
import 'package:notes/infrastructure/providers/note_provider.dart';
import 'package:notes/models/note.dart';
import 'package:notes/views/note_view.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  final colorPalette = List<ColorPickerItem>();

  var isSelectModeEnabled = false;

  var selectedIndexes = new List<int>();
  var searchQuery = "";
  var colorsSelectedIndexes = new List<int>();

  @override
  Widget build(BuildContext context) {
    colorPalette.clear();
    noteColors.forEach(
      (index, color) => colorPalette.add(
        ColorPickerItem(
          colorIndex: index,
          selectedCallback: (isSelected) => onColorSelected(index, isSelected),
          isSelected: colorsSelectedIndexes.contains(index),
        ),
      ),
    );

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: NotesAppBar(
          onEditButtonPressed: switchSelectMode,
          onSearchQueryChanged: filterNotes,
          isSelectModeEnabled: isSelectModeEnabled,
          scaffoldKey: scaffoldKey,
        ),
        body: buildListView(context),
        floatingActionButton: buildFloatingActionButton(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        drawer: buildDrawer(),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Container(
            height: 48,
          ),
        ),
      ),
    );
  }

  Widget buildFloatingActionButton(BuildContext context) {
    if (!isSelectModeEnabled) {
      return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => navigateToNote(context, NoteMode.Adding),
      );
    }

    if (selectedIndexes.length > 0) {
      return FloatingActionButton(
        child: Icon(Icons.delete),
        onPressed: () => deleteSelectedNotes(),
      );
    }

    return Visibility(
      visible: false,
      child: Container(),
    );
  }

  Widget buildListView(BuildContext context) {
    return FutureBuilder(
      future: NoteProvider.getNoteList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var notes = snapshot.data
              .map((x) => Note.fromMap(x))
              .toList()
              .cast<Note>() as List<Note>;

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (contex, index) => buildItemList(notes, index),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget buildItemList(List<Note> notes, int index) {
    if ((notes[index].title.contains(searchQuery) ||
            notes[index].content.contains(searchQuery)) &&
        (colorsSelectedIndexes.isEmpty ||
            colorsSelectedIndexes
                .every((x) => notes[index].colors.contains(x)))) {
      return NoteListTile(
        note: notes[index],
        isSelectModeEnabled: isSelectModeEnabled,
        onSelectionChanged: (isSelected) {
          setState(() {
            if (isSelected) {
              selectedIndexes.add(notes[index].id);
            } else {
              selectedIndexes.removeWhere((x) => x == notes[index].id);
            }
          });
        },
        isSelected: selectedIndexes.contains(notes[index].id),
      );
    }

    return Container();
  }

  Widget buildDrawer() {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, top: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Select labels',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: <Widget>[
                ColorPalette(
                  colorPalette: colorPalette,
                ),
                Spacer(),
                IconButton(
                    icon: Icon(Icons.delete_sweep),
                    onPressed: () {
                      setState(() {
                        colorsSelectedIndexes.clear();
                      });
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }

  onColorSelected(int index, bool isSelected) {
    setState(() {
      if (isSelected) {
        colorsSelectedIndexes.add(index);
      } else {
        colorsSelectedIndexes.removeWhere((x) => x == index);
      }
    });
  }

  switchSelectMode() {
    setState(() {
      isSelectModeEnabled = !isSelectModeEnabled;

      if (!isSelectModeEnabled) {
        selectedIndexes.clear();
      }
    });
  }

  deleteSelectedNotes() {
    for (var index in selectedIndexes) {
      NoteProvider.deleteNote(index);
    }

    switchSelectMode();
  }

  filterNotes(String query) {
    setState(() {
      searchQuery = query;
    });
  }
}

navigateToNote(BuildContext context, NoteMode mode, [Note note]) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => NoteView(mode, note),
    ),
  );
}
