import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class SheetService {
  static const String scriptUrl = "https://script.google.com/macros/s/AKfycbw9fnOUZctZAL4LVRxBhwvgO73Fk9hgiePU-JPirloNSBjUgK6j5Dh8X48fG0lEXHvx/exec";

  static Future<List<Map<String, dynamic>>> fetchSheetData(String sheetName) async {
    try {
      final uri = Uri.parse('$scriptUrl?sheet=${Uri.encodeComponent(sheetName)}');
      final response = await http.get(uri);

      if (response.statusCode == 200 || response.statusCode == 302) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((e) => Map<String, dynamic>.from(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      debugPrint("Error fetching $sheetName: $e");
      return [];
    }
  }

  static Future<String> syncUserProfile({
    required String name,
    required String phone,
    required String email,
    required String selectedClass,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(scriptUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "phone": phone,
          "email": email,
          "selected_class": selectedClass,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 302) {
        final resData = jsonDecode(response.body);
        return resData["subscription"] ?? "FREE";
      }
      return "FREE";
    } catch (e) {
      debugPrint("Error syncing user profile: $e");
      return "FREE";
    }
  }
}