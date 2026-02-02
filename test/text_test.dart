import 'package:test/test.dart';
import 'package:text/text.dart';

void main() {
  test('Text', () {
    {
      final text = Text(string);
      expect(text.lineCount, 4, reason: 'Text.lineCount');
    }
    {
      final str = string.replaceAll('\n', '\r\n');
      final text = Text(str);
      expect(text.lineCount, 4, reason: 'Text.lineCount');
    }
    {
      final text = Text('');
      expect(text.lineCount, 1, reason: 'Text.lineCount');
    }
    {
      final text = Text('\r');
      expect(text.lineCount, 1, reason: 'Text.lineCount');
    }
    {
      final text = Text('\r ');
      expect(text.lineCount, 2, reason: 'Text.lineCount');
    }
    {
      final str = string.replaceAll('\n', '\r\n');
      final text = Text(str);
      final length = text.length;
      for (var position = 0; position < length; position++) {
        final line = text.lineAt(position)!;
        expect(position >= line.start, true, reason: 'Line.start');
        expect(position <= line.end, true, reason: 'Line.end');
      }
    }
    {
      final str = string.replaceAll('\n', '\r\n');
      final text = Text(str);
      final length = text.length;
      for (var position = 0; position < length; position++) {
        final line = text.lineAt(position)!;
        final location = text.locationAt(position);
        expect(location.line, line.number, reason: 'Line.locationAt');
        expect(
          location.column,
          position - line.start + 1,
          reason: 'Line.locationAt',
        );
      }
    }
    {
      final str = string.replaceAll('\n', '\r\n');
      final text = Text(str);
      final length = text.length;
      for (var position = 0; position < length; position++) {
        final location = text.locationAt(position);
        final position2 = text.position(location);
        expect(position2, position, reason: 'Line.position');
      }
    }
  });
}

String string = '''
П
h
🚀
a
''';
