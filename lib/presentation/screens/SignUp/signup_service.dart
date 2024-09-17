import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> registerUser(
  String firstName,
  String lastName,
  String email,
  String password,
  String gender,
) async {
  final url =
      Uri.parse('https://art-ecommerce-server.glitch.me/api/auth/register');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'gender': gender,
    }),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to register user');
  }
}
