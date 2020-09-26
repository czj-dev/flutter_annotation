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
    buffer..writeln('default:return json;')..writeln('}');
    return buffer.toString();
  }

  void createElementFromJson(StringBuffer buffer, String name, dynamic value) {
    //如果类包含泛型,则在解析的时候增加泛型的传递
    String type = genericParser(value);
    buffer.writeln('case "$name": return $name$type.fromJson(json);');
  }

  String genericParser(value) {
    String type = '';
    if (value is Map<String, dynamic>) {
      bool generic = value['type'].toString().contains('<');
      type = generic ? '<T>' : '';
    }
    return type;
  }

  String createToJson() {
    final StringBuffer buffer = StringBuffer();
    buffer.writeln('switch (serializableKey) {');
    annotationParser.classMap.forEach((String name, dynamic object) {
      createElementToJson(buffer, name, object);
    });
    buffer..writeln('default:return instance;')..writeln('}');
    return buffer.toString();
  }

  void createElementToJson(StringBuffer buffer, String name, dynamic value) {
    //如果类包含泛型,则在解析的时候增加泛型的传递
    String type = genericParser(value);
    buffer.writeln('case "$name": return (instance as $name$type).toJson();');
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
