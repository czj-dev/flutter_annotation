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
  
  
  String serializableOut<T>(dynamic instance) {
    var data = toJson(T.toString(), instance);
    if(data==null) {
      data = json.encode(instance);
    }
    return data;
  }


  Object fromJson(String serializableKey,Map<String,dynamic> json) {
    {{{instanceFromJson}}}
  }

  String toJson(String serializableKey,dynamic instance) {
    {{{instanceToJson}}}
  }
}
""";
