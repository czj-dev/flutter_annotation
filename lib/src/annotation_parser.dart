import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';

class AnnotationParser {
  Map<String, dynamic> classMap = {};
  List<String> importList = [];

  void parseRoute(
      ClassElement element, ConstantReader annotation, BuildStep buildStep) {
    print('start parseRoute for ${element.displayName}');
    if (element.isAbstract || element.isEnum) {
      return;
    }
    if (element.getMethod("fromJson") == null) {
      return;
    }
    if (element.getMethod("toJson") == null) {
      return;
    }
    classMap[element.displayName] = {"name": element.name};
    if (buildStep.inputId.path.contains('lib/')) {
      print(buildStep.inputId.path);
      importList.add(
          "package:${buildStep.inputId.package}/${buildStep.inputId.path.replaceFirst('lib/', '')}");
    } else {
      importList.add("${buildStep.inputId.path}");
    }
  }
}
