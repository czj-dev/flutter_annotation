import 'package:json_serializable_map/src/annotation_parser.dart';
import 'package:json_serializable_map/src/tpl.dart';
import 'package:mustache4dart/mustache4dart.dart';
import 'package:analyzer/dart/element/element.dart';

class MapWriter {
  final AnnotationParser annotationParser;

  MapWriter(this.annotationParser);

  String createFromJson() {
    final StringBuffer buffer = StringBuffer();
    buffer.writeln('switch (serializableKey) {');
    annotationParser.classMap.forEach((String name, dynamic object) {
      createElementFromJson(buffer, name, object);
    });
    buffer..writeln('default:return null;')..writeln('}');
    return buffer.toString();
  }

  void createElementFromJson(StringBuffer buffer, String name, dynamic value) {
    buffer.writeln('case "$name": return $name.fromJson(json);');
  }

  String createToJson() {
    final StringBuffer buffer = StringBuffer();
    buffer.writeln('switch (serializableKey) {');
    annotationParser.classMap.forEach((String name, dynamic object) {
      createElementToJson(buffer, name);
    });
    buffer..writeln('default:return null;')..writeln('}');
    return buffer.toString();
  }

  void createElementToJson(StringBuffer buffer, String name) {
    buffer.writeln('case "$name": return (instance as $name).toJson();');
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
