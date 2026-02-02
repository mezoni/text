import 'dart:collection';

import 'package:simple_sparse_list/simple_sparse_list.dart';

class Line {
  /// Unicode characters.
  final List<int> characters;

  /// Line number.
  final int number;

  /// Start position.
  final int start;

  Line(this.characters, this.number, this.start);

  /// End position.
  int get end => start + length;

  /// Line length.
  int get length => characters.length;
}

class Location {
  /// Column number.
  final int column;

  /// Line number.
  final int line;

  Location(this.line, this.column);

  @override
  String toString() => '$line:$column';
}

class Text {
  late List<int> _characters;

  late SparseList<Line> _lines;

  Text(String text) {
    _initialize(text);
  }

  /// Unicode characters.
  List<int> get characters => UnmodifiableListView<int>(_characters);

  /// Number of Unicode characters.
  int get length => _characters.length;

  /// Number of lines.
  int get lineCount => _lines.getGroups().length;

  /// Returns an Unicode character at the specified [position].
  ///
  /// Example:
  ///     text.characterAt(0);
  int characterAt(int position) {
    return _characters[position];
  }

  /// Returns the lines at specified [index].
  ///
  /// Example:
  ///     var lineNumber = 1;
  ///     text.line(lineNumber - 1);
  Line line(int index) {
    return _lines.getGroups()[index].$3;
  }

  /// Returns the line at specified character [position].
  Line? lineAt(int position) {
    return _lines[position];
  }

  /// Returns the collection of text lines.
  ///
  /// Example:
  ///     var lines = text.lines;
  Iterable<Line> lines() {
    return _lines.getGroups().map((group) => group.$3);
  }

  /// Returns the location at specified character [position].
  Location locationAt(int position) {
    final line = lineAt(position)!;
    return Location(line.number, position - line.start + 1);
  }

  /// Returns the character position at specified [location].
  int position(Location location) {
    return line(location.line - 1).start + location.column - 1;
  }

  void _initialize(String text) {
    final length = text.length;
    _characters = List.filled(length, 0, growable: true);
    final groups = <(int, int, Line)>[];
    var lineNumber = 1;
    var column = 1;
    var codePoints = <int>[];
    var start = 0;
    if (length == 0) {
      codePoints = UnmodifiableListView<int>(codePoints);
      const end = 0;
      final line = Line(codePoints, lineNumber, start);
      final group = (start, end, line);
      groups.add(group);
      _lines = SparseList(groups, Line(const [], 0, 0));
      return;
    }

    var c = -1;
    var i = 0;
    var pos = 0;
    for (; i < length; pos++) {
      c = text.codeUnitAt(i);
      i++;
      if ((c & 0xFC00) == 0xD800 && i < length) {
        final c2 = text.codeUnitAt(i);
        if ((c2 & 0xFC00) == 0xDC00) {
          c = 0x10000 + ((c & 0x3FF) << 10) + (c2 & 0x3FF);
          _characters[pos] = c;
          codePoints.add(c);
          i++;
        } else {
          _characters[pos] = c;
          codePoints.add(c);
        }
      } else {
        _characters[pos] = c;
        codePoints.add(c);
      }

      if (c == 13) {
        if (i < length) {
          c = text.codeUnitAt(i);
          if (c == 10) {
            _characters[++pos] = c;
            codePoints.add(c);
            i++;
          }
        }

        codePoints = UnmodifiableListView<int>(codePoints);
        final end = i - 1;
        final line = Line(codePoints, lineNumber, start);
        final group = (start, end, line);
        groups.add(group);
        lineNumber++;
        column = 1;
        start = i;
        codePoints = <int>[];
      } else if (c == 10) {
        codePoints = UnmodifiableListView<int>(codePoints);
        final end = i - 1;
        final line = Line(codePoints, lineNumber, start);
        final group = (start, end, line);
        groups.add(group);
        codePoints = <int>[];
        lineNumber++;
        column = 1;
        start = i;
      } else {
        column++;
      }
    }

    if (column != 1) {
      codePoints = UnmodifiableListView<int>(codePoints);
      final line = Line(codePoints, lineNumber, start);
      final group = (start, i, line);
      groups.add(group);
    }

    _characters.length = i;
    _lines = SparseList(groups, Line(const [], 0, 0));
  }
}
