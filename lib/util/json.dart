import 'dart:convert';

class JsonUtil {
  static String mapToJson(Map<String, dynamic> map) {
    // return map.isEmpty ? "{}" : map.toString();
    if (map.isEmpty) return '{}';

    try {
      return jsonEncode(map);
    } catch (_) {
      return '{}';
    }
  }

  static Map<String, dynamic> mapFromJson(String json) {
    try {
      return Map<String, dynamic>.from(jsonDecode(json));
    } catch (_) {
      return {};
    }
  }

  static String listToJson(List<dynamic> list) {
    if (list.isEmpty) return '[]';

    try {
      return jsonEncode(list);
    } catch (_) {
      return '[]';
    }
  }

  static List<dynamic> listFromJson(String json) {
    try {
      return List.from(jsonDecode(json));
    } catch (_) {
      return [];
    }
  }
}
