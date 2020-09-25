import 'package:json_serializable_map/src/annotation_parser.dart';
import 'package:json_serializable_map/src/tpl.dart';
import 'package:mustache4dart/mustache4dart.dart';

class MapWriter {
  final AnnotationParser annotationParser;

  MapWriter(this.annotationParser);

  String createFromJson() {
    final StringBuffer buffer = StringBuffer();
    buffer.writeln('switch (serializableKey) {');
    annotationParser.classMap.forEach((String name, dynamic object) {
      buffer.writeln('case "$name": return $name.fromJson(json);');
    });
    buffer..writeln('default:return null;')..writeln('}');
    return buffer.toString();
  }

  String createToJson() {
    final StringBuffer buffer = StringBuffer();
    buffer.writeln('switch (serializableKey) {');
    annotationParser.classMap.forEach((String name, dynamic object) {
      buffer.writeln('case "$name": return $name.toJson(instance);');
    });
    buffer..writeln('default:return null;')..writeln('}');
    return buffer.toString();
  }

  List<Map<String, String>> importList() {
    final List<Map<String, String>> refs = <Map<String, String>>[];
    var function = (String path) {
      refs.add(<String, String>{'path': path});
    };
    annotationParser.importList.forEach(function);
    return refs;
  }

  String write() {
    return render(clazzTpl, <String, dynamic>{
      'refs': importList(),
      'instanceFromJson': createFromJson(),
      'instanceToJson': createToJson(),
    });
  }
}
