const String clazzTpl = """
import 'dart:convert';
{{#refs}}
import '{{{path}}}';
{{/refs}}
class JsonSerializableMapper {
  factory JsonSerializableMapper() {
    return JsonSerializableMapper();
  }

  T serializableIn<T>(Map<String, dynamic> data) {
    var object = nestListFromJson(T.toString(), data);
    if (object != null) {
      return object as T;
    }
    throw new FormatException(
        "this data not find  serializable object, please implements @JsonSerializable");
  }

  Map<String, dynamic> serializableOut<T>(Object instance) {
    var data = nestListToJson<T>(T.toString(), instance);
    return data;
  }

  Object nestListFromJson<T>(String serializableKey, Object json) {
    // 如果传递进来泛型为嵌套泛型的话,需要甄别一下
    // 如果实体需要自己在 fromJson 里使用[ClassParserMapper.serializableIn<T>(json['data'])] 解析
    // 如果是 List 则循环解析输出
    if (json is List && json != null) {
      List<String> split = serializableKey.replaceAll(">", "").split("<");
      Object data;
      if (split[0] == 'List') {
        data = [];
        var list = json;
        list.forEach((element) {
          split.remove(0);
          (data as List)
              .add(nestListFromJson<T>(listToGeneric(split), element));
        });
      } else {
        throw new FormatException('generic not match json structure');
      }
      return data;
    }
    return fromJson<T>(serializableKey, json);
  }

  Map<String, dynamic> nestListToJson<T>(
      String serializableKey, Object instance) {
    // 如果传递进来泛型为嵌套泛型的话,需要甄别一下
    // 如果实体需要自己在 toJson 里使用[ClassParserMapper.serializableOut<T>(instance] 解析
    // 如果是 List 则循环解析输出
    if (instance is List && instance != null) {
      List<String> split = serializableKey.replaceAll(">", "").split("<");
      Object data;
      if (split[0] == 'List') {
        data = [];
        var list = instance;
        list.forEach((element) {
          split.remove(0);
          (data as List).add(nestListToJson<T>(listToGeneric(split), element));
        });
      } else {
        throw new FormatException('generic not match json structure');
      }
      return data;
    }
    return toJson<T>(serializableKey, instance);
  }

  // List 的长度一定是大于等于一的
  String listToGeneric(List<String> generics) {
    var generic = generics[0];
    if (generics.length > 1) {
      generics.removeAt(0);
      generics.forEach((element) {
        generic += '<';
        generic += element;
      });
      generics.forEach((element) {
        generic += '>';
      });
    }
    return generic;
  }

  Object fromJson<T>(String serializableKey,Map<String,dynamic> json) {
    {{{instanceFromJson}}}
  }

  Map<String, dynamic> toJson<T>(String serializableKey,dynamic instance) {
    {{{instanceToJson}}}
  }
}
""";
