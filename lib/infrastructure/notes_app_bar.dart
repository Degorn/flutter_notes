import 'package:flutter/material.dart';

class NotesAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function onEditButtonPressed;
  final Function(String query) onSearchQueryChanged;
  final bool isSelectModeEnabled;
  final GlobalKey<ScaffoldState> scaffoldKey;

  NotesAppBar(
      {@required this.onEditButtonPressed,
      this.onSearchQueryChanged,
      this.isSelectModeEnabled,
      this.scaffoldKey});

  @override
  _NotesAppBarState createState() => _NotesAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(60.0);
}

class _NotesAppBarState extends State<NotesAppBar> {
  var searchQueryController = TextEditingController();
  var isSearching = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: buildAppBarLeading(),
      title: buildAppBarTitle(),
      actions: buildActions(),
    );
  }

  Widget buildAppBarLeading() => isSearching
      ? const BackButton()
      : IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => widget.scaffoldKey.currentState.openDrawer(),
        );

  Widget buildAppBarTitle() {
    if (isSearching) {
      return buildSearchField();
    }

    if (widget.isSelectModeEnabled) {
      return Text("Select");
    }

    return Text("Notes");
  }

  List<Widget> buildActions() {
    var actions = <Widget>[
      IconButton(
        icon: Icon(Icons.edit),
        onPressed: onEditButtonPressed,
      ),
    ];

    if (isSearching) {
      actions.add(
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            if (searchQueryController == null ||
                searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            clearSearchQuery();
          },
        ),
      );
    } else {
      actions.add(
        IconButton(
          icon: Icon(Icons.search),
          onPressed: startSearch,
        ),
      );
    }

    return actions;
  }

  void onEditButtonPressed() {
    widget.onEditButtonPressed();
  }

  void startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: stopSearching));

    setState(() {
      isSearching = true;
    });
  }

  void stopSearching() {
    clearSearchQuery();

    setState(() {
      isSearching = false;
    });
  }

  void clearSearchQuery() {
    setState(() {
      searchQueryController.clear();
      updateSearchQuery("");
    });
  }

  Widget buildSearchField() {
    return TextField(
      controller: searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Search...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  void updateSearchQuery(String newQuery) {
    widget.onSearchQueryChanged(newQuery);
  }
}
