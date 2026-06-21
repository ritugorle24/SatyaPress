import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8000';

  static Future<List<Map<String, dynamic>>> fetchArticles() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/articles'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> fetchBuriedStories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/buried-stories'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> fetchAccountability() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/accountability'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> fetchCompare(String topic) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/compare?topic=$topic'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      }
      return {};
    } catch (e) {
      return {};
    }
  }
}
