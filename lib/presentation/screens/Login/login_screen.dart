import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/bottomAppBar.dart';
import 'package:flutter_application_1/presentation/screens/SignUp/sign_up_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/login_service.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  bool rememberMe = false;
  bool _isLoading = false; // Track the loading state
  String? _errorMessage; // Track the error message from the backend

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkIfAlreadySignedIn();
  }

  Future<void> _checkIfAlreadySignedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_email');
    final savedPassword = prefs.getString('saved_password');

    if (savedEmail != null && savedPassword != null) {
      // User is already signed in, navigate to MyHomePage
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MyHomePage(
            title: '',
          ),
        ),
      );
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Start loading
        _errorMessage = null; // Clear previous error message
      });

      try {
        final response = await loginUser(
          _emailController.text,
          _passwordController.text,
          rememberMe,
        );
        setState(() {
          _isLoading = false; // Stop loading
        });
        if (response['success']) {
          // Handle successful login
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login successful'),
              backgroundColor: Colors.green,
            ),
          );

          if (rememberMe) {
            // Save email and password if "Remember Me" is selected
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('saved_email', _emailController.text);
            await prefs.setString('saved_password', _passwordController.text);
          } else {
            // Clear saved credentials if "Remember Me" is not selected
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('saved_email');
            await prefs.remove('saved_password');
          }

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => MyHomePage(
                title: '',
              ),
            ),
          );
        } else {
          // Handle login failure and show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login failed: ${response['message']}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'An unexpected error occurred'; // Set a generic error message
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image(
          image: AssetImage("assets/back.png"),
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
        Center(
          child: Container(
            width: 320,
            height: 550,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(195, 0, 0, 0),
                  spreadRadius: 12,
                  blurRadius: 12,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.transparent,
                body: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildHeader(),
                      SizedBox(height: 80),
                      _buildEmailField(),
                      SizedBox(height: 32),
                      _buildPasswordField(),
                      SizedBox(height: 10),
                      _buildRememberMeCheckbox(),
                      SizedBox(height: 32),
                      _buildSignInButton(),
                      if (_errorMessage != null) ...[
                        SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "I don't have an account. ",
                              style: GoogleFonts.openSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: "Sign Up",
                              style: GoogleFonts.openSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 201, 171, 129),
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => SignUp(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset("assets/Logo.png"),
        Text(
          "Sign in",
          style: GoogleFonts.jomolhari(fontSize: 32),
        ),
        SizedBox(width: 32),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      cursorColor: Color.fromARGB(255, 201, 171, 129),
      decoration: InputDecoration(
        labelText: "Email",
        labelStyle: GoogleFonts.openSans(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 201, 171, 129),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 201, 171, 129),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        hintText: "example@example.example",
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      cursorColor: Color.fromARGB(255, 201, 171, 129),
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: GoogleFonts.openSans(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 201, 171, 129),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 201, 171, 129),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        suffixIcon: IconButton(
          color: Color.fromARGB(255, 201, 171, 129),
          onPressed: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
          icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters long';
        }
        return null;
      },
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: rememberMe,
          onChanged: (bool? value) {
            setState(() {
              rememberMe = value ?? false;
            });
          },
          checkColor: Colors.white,
          activeColor: Color.fromARGB(255, 201, 171, 129),
        ),
        Text(
          "Remember Me",
          style: GoogleFonts.openSans(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton() {
    return OutlinedButton(
      onPressed: _isLoading ? null : _login, // Disable button if loading
      child: _isLoading
          ? LinearProgressIndicator(
              color: Color.fromARGB(255, 201, 171, 129),
              backgroundColor: Colors.transparent,
            ) // Show loading spinner
          : Text(
              'Sign In',
              style: GoogleFonts.openSans(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Color.fromARGB(255, 201, 171, 129), width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}
