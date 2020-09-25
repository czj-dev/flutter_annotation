import 'package:source_gen/source_gen.dart';
import 'package:build/build.dart';
import 'package:json_serializable_map/src/mapper_generator.dart';

Builder parserBuilder(BuilderOptions options) => LibraryBuilder(JsonSerializableMapParser(),
    generatedExtension: '.internal_invalid.dart');

Builder writeBuilder(BuilderOptions options) =>
    LibraryBuilder(JsonSerializableMapGenerator(),
        generatedExtension: '.internal.dart');