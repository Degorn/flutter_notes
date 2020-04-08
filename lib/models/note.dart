const String columnId = 'id';
const String columnTitle = 'title';
const String columnContent = 'content';
const String columnColors = 'colors';

class Note {
  final int id;
  final String title;
  final String content;
  final List<int> colors;

  Note({this.id, this.title, this.content, this.colors});

  Note.fromMap(Map<String, dynamic> note)
      : id = note[columnId],
        title = note[columnTitle],
        content = note[columnContent],
        colors = note[columnColors] != "" ? (note[columnColors] as String)?.split(', ')?.map(int.parse)?.toList() : List<int>();

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTitle: title,
      columnContent: content,
      columnColors: colors.join(', '),
    };

    if (id != null) {
      map[columnId] = id;
    }

    return map;
  }
}
