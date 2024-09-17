import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileProvider with ChangeNotifier {
  String? profileId; // Global profile ID
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _phone;
  String? _gender = 'male'; // Default value
  String? _birthday;
  bool _isEditing = false;

  // Getters
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get phone => _phone;
  String? get gender => _gender;
  String? get birthday => _birthday;
  bool get isEditing => _isEditing;

  // Controllers for TextFields
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final birthdayController = TextEditingController();

  // Toggle editing mode
  void toggleEditing() {
    _isEditing = !_isEditing;
    notifyListeners();
  }

  // Update gender
  void updateGender(String? newGender) {
    _gender = newGender;
    notifyListeners();
  }

  // Fetch profile from API and update provider
  Future<void> fetchProfile(String token) async {
    final response = await http.get(
      Uri.parse('https://art-ecommerce-server.glitch.me/api/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Set profile ID globally
      profileId = data['_id']; // Save profile ID globally

      // Set profile data in provider
      _firstName = data['first_name'];
      _lastName = data['last_name'];
      _email = data['email'];
      _gender = data['gender'];
      _birthday = data['birthday'];

      // Update controllers
      firstNameController.text = _firstName!;
      lastNameController.text = _lastName!;
      emailController.text = _email!;
      birthdayController.text = _birthday!;

      notifyListeners();
    } else {
      throw Exception('Failed to load profile');
    }
  }

  // Edit profile
  Future<void> editProfile(String token) async {
    final editedProfile = {
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
      'email': emailController.text,
      'gender': _gender,
      'birthday': birthdayController.text,
      'phone': phoneController.text,
    };

    final response = await http.put(
      Uri.parse(
          'https://art-ecommerce-server.glitch.me/api/profile/$profileId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(editedProfile),
    );

    if (response.statusCode == 200) {
      print('Profile updated successfully');
    } else {
      throw Exception('Failed to update profile');
    }
  }

  // Delete profile
  Future<void> deleteProfile(String token) async {
    final response = await http.delete(
      Uri.parse(
          'https://art-ecommerce-server.glitch.me/api/profile/$profileId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print('Profile deleted successfully');
    } else {
      throw Exception('Failed to delete profile');
    }
  }
}
