import 'dart:convert';

class JsonUtil {
  static String mapToJson(Map<String, dynamic> map) {
    return map.isEmpty ? "{}" : map.toString();
  }

  static Map<String, dynamic> mapFromJson(String json) {
    try {
      return Map<String, dynamic>.from(jsonDecode(json));
    } catch (_) {
      return {};
    }
  }
}
