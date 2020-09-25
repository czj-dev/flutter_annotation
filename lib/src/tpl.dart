const String clazzTpl = """
import 'dart:convert';
{{#refs}}
import '{{{path}}}';
{{/refs}}
class \$JsonSerializableMapper {
  \$JsonSerializableMapper();

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
    {{{instanceFromJson}}}
  }

  Map<String, dynamic> toJson(String serializableKey,dynamic instance) {
    {{{instanceToJson}}}
  }
}
""";
