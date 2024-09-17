import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/model/ProfileProvider.dart';
import 'package:flutter_application_1/presentation/screens/Login/login_screen.dart';
import 'package:flutter_application_1/presentation/screens/Order_History_Screans.dart';
import 'package:flutter_application_1/presentation/widgets/Category_Appbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? token;

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchProfile();
  }

  // Load token from shared preferences and fetch profile
  Future<void> _loadTokenAndFetchProfile() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString(
        'auth_token'); // Assuming you store the token under 'auth_token'

    if (token != null) {
      // Call fetch profile method from provider
      await Provider.of<ProfileProvider>(context, listen: false)
          .fetchProfile(token!);
    } else {
      print('Token is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      appBar: CustomAppBar(title: 'Profile', actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    OrderHistory(), // Navigate to the Order History screen
              ),
            );
          },
          icon: Icon(Icons.history_outlined),
          iconSize: 30,
        )
      ]),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          if (profileProvider.firstName == null) {
            // Display loading indicator while fetching profile
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'User Info',
                        style: GoogleFonts.ebGaramond(
                          color: Colors.black,
                          fontSize: screenWidth * 0.07,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    _buildTextField(
                      profileProvider.firstNameController,
                      'First Name',
                      profileProvider.isEditing,
                      screenWidth,
                    ),
                    _buildTextField(
                      profileProvider.lastNameController,
                      'Last Name',
                      profileProvider.isEditing,
                      screenWidth,
                    ),
                    _buildTextField(
                      profileProvider.emailController,
                      'Email Address',
                      profileProvider.isEditing,
                      screenWidth,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    _buildTextField(
                      profileProvider.phoneController,
                      'Phone Number',
                      profileProvider.isEditing,
                      screenWidth,
                      keyboardType: TextInputType.phone,
                    ),
                    _buildTextField(
                      profileProvider.birthdayController,
                      'Birthday',
                      profileProvider.isEditing,
                      screenWidth,
                      keyboardType: TextInputType.datetime,
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Text('Gender',
                        style: TextStyle(fontSize: screenWidth * 0.04)),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            fillColor: MaterialStateProperty.all(
                                Color.fromARGB(255, 201, 171, 129)),
                            title: const Text('Male'),
                            value: 'male',
                            groupValue: profileProvider.gender,
                            onChanged: profileProvider.isEditing
                                ? profileProvider.updateGender
                                : null,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            fillColor: MaterialStateProperty.all(
                                Color.fromARGB(255, 201, 171, 129)),
                            title: const Text('Female'),
                            value: 'female',
                            groupValue: profileProvider.gender,
                            onChanged: profileProvider.isEditing
                                ? profileProvider.updateGender
                                : null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (profileProvider.isEditing) {
                            // Save profile changes
                            await profileProvider.editProfile(token!);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Profile has been updated successfully'),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              ),
                            );

                            profileProvider
                                .toggleEditing(); // Disable editing mode
                          } else {
                            // Toggle editing mode
                            profileProvider.toggleEditing();
                          }
                        },
                        child: Text(
                          profileProvider.isEditing
                              ? 'Save Profile'
                              : 'Edit Profile',
                          style: GoogleFonts.openSans(
                            color: Colors.black,
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Color.fromARGB(255, 201, 171, 129),
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          await _signOut(context);
                        },
                        child: Text(
                          'Sign Out',
                          style: GoogleFonts.ebGaramond(
                              color: Colors.red,
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token'); // Remove the auth token

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => Login(), // Navigate back to the login screen
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    bool isEditing,
    double screenWidth, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: screenWidth * 0.01, horizontal: screenWidth * 0.04),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.openSans(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Color.fromARGB(255, 201, 171, 129))),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Color.fromARGB(255, 201, 171, 129))),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
        enabled: isEditing,
        keyboardType: keyboardType,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left,
      ),
    );
  }
}
