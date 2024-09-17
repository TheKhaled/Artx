// lib/services/auth_service.dart
import 'package:flutter_application_1/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Function to perform login request
Future<Map<String, dynamic>> loginUser(
  String email,
  String password,
  bool rememberMe,
) async {
  final url =
      Uri.parse('https://art-ecommerce-server.glitch.me/api/auth/login');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'password': password,
      'rememberMe': rememberMe,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    // Save the token in the global variable
    authToken = data['token'];

    if (rememberMe) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', authToken!);
      await prefs.setString('saved_email', email);
      await prefs.setString('saved_password',
          password); // Save password (not recommended for production)
    }
    return data;
  } else {
    final errorData = jsonDecode(response.body);
    return {
      'success': false,
      'message': errorData['message'] ?? 'An error occurred'
    };
  }
}
