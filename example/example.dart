import 'package:text/text.dart';

void main() {
  final text = Text(string);
  var position = text.length ~/ 2;
  // Get the line by the character position
  var line = text.lineAt(position)!;
  print('#${line.number}: ${toStr(line.characters)}');

  // Get the location by the character position
  var location = text.locationAt(position);
  print('pos: $position => loc: ${location.line}:${location.column}');

  // Get the character position by the location
  position = text.position(location);
  print('loc: ${location.line}:${location.column} => pos: $position');

  // Get the line by index (line.number - 1)
  final line2 = text.line(line.number - 1);
  print('#${line.number} = #${line2.number}');

  // Search the Unicode character and display it location and string
  const char = 65504; // ￠
  position = text.characters.indexOf(char);
  location = text.locationAt(position);
  line = text.lineAt(position)!;
  print('${toStr([char])} found at pos: $position');
  print('${toStr([char])} found at loc: ${location.line}:${location.column}');
  print('${toStr([char])} found in line: ${toStr(line.characters)}');
}

String toStr(List<int> characters) => String.fromCharCodes(characters);

String string = '''
1. Line 1
2. Line 2
3. Line 3
4. Line 4
5. Line 5 🚀￠
''';
