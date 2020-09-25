library json_serializable_map;

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:json_serializable_map/mapper.dart';
import 'package:json_serializable_map/src/map_writer.dart';
import 'package:source_gen/source_gen.dart';

import 'annotation_parser.dart';

class JsonSerializableMapParser
    extends GeneratorForAnnotation<JsonSerializable> {
  static AnnotationParser annotationParser;

  // 获取所有标记了 JsonSerializable 注解的类
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    annotationParser.parseRoute(element, annotation, buildStep);
    return null;
  }
}

class JsonSerializableMapGenerator
    extends GeneratorForAnnotation<SerializableMapper> {
  AnnotationParser parser() {
    return JsonSerializableMapParser.annotationParser;
  }

  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    return MapWriter(parser()).write();
  }
}
