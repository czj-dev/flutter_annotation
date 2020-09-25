const String clazzTpl = """
import 'dart:convert';
{{#refs}}
import '{{{path}}}';
{{/refs}}
class JsonSerializableMapper {
  factory JsonSerializableMapper() {
    return JsonSerializableMapper();
  }

  T  serializableIn<T>(Map<String,dynamic> data) {
     var object = fromJson(T.toString(), data);
     if(object!=null) {
       return object as T;
     }
     throw new FormatException("this data not find  serializable object, please implements @JsonSerializable");
  }
  
  
  Map<String,dynamic> serializableOut<T>(Object instance) {
    var data = toJson(T.toString(), instance);
    return data;
  }


  Object fromJson(String serializableKey,Map<String,dynamic> json) {
   /*// 如果有嵌套泛型
    if (serializableKey.contains("<")) {
      List<String> split = serializableKey.replaceAll(">", "").split("<");
      //只需要处理容器,目前只处理 List
      Object data;
      if (split[0] == 'List') {
        data = [];
        var list = object as List;
        list.forEach((element) {
          (data as List).add(fromJson(split[1], object));
        });
      } else {
        // 如果第一个是实体那么就不需要, 需要自己在 fromJson 里使用 mapper 解析
        data = fromJson(split[0], object);
      }
      return data;
    }*/
    {{{instanceFromJson}}}
  }

  Map<String, dynamic> toJson(String serializableKey,dynamic instance) {
    {{{instanceToJson}}}
  }
}
""";
