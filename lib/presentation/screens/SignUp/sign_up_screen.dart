import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/screens/Login/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup_service.dart';

class SignUp extends StatefulWidget {
  SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  bool confirmObscureText = true;
  String? gender = 'male';

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Processing Data'),
          backgroundColor: Color.fromARGB(255, 201, 171, 129),
        ),
      );

      final response = await registerUser(
        _firstNameController.text,
        _lastNameController.text,
        _emailController.text,
        _passwordController.text,
        gender!,
      );

      if (response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration successful'),
            backgroundColor: Colors.green,
          ),
        );
        await Future.delayed(Duration(seconds: 5));

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Login()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${response['message']}'),
            backgroundColor: Colors.red,
          ),
        );
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
            width: 370,
            height: 700,
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
                      SizedBox(height: 40),
                      _buildFirstNameField(),
                      SizedBox(height: 16),
                      _buildLastNameField(),
                      SizedBox(height: 16),
                      _buildEmailField(),
                      SizedBox(height: 16),
                      _buildPasswordField(),
                      SizedBox(height: 16),
                      _buildConfirmPasswordField(),
                      SizedBox(height: 16),
                      _buildGenderField(),
                      SizedBox(height: 24),
                      _buildSignUpButton(),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "I have an account. ",
                              style: GoogleFonts.openSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: "Sign In",
                              style: GoogleFonts.openSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 201, 171, 129),
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => Login(),
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
          "Sign Up",
          style: GoogleFonts.jomolhari(fontSize: 32),
        ),
        SizedBox(width: 32),
      ],
    );
  }

  Widget _buildFirstNameField() {
    return TextFormField(
      controller: _firstNameController,
      cursorColor: Color.fromARGB(255, 201, 171, 129),
      decoration: InputDecoration(
        labelText: "First Name",
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
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your first name';
        }
        return null;
      },
    );
  }

  Widget _buildLastNameField() {
    return TextFormField(
      controller: _lastNameController,
      cursorColor: Color.fromARGB(255, 201, 171, 129),
      decoration: InputDecoration(
        labelText: "Last Name",
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
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your last name';
        }
        return null;
      },
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

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      cursorColor: Color.fromARGB(255, 201, 171, 129),
      obscureText: confirmObscureText,
      decoration: InputDecoration(
        labelText: "Confirm Password",
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
              confirmObscureText = !confirmObscureText;
            });
          },
          icon: Icon(
              confirmObscureText ? Icons.visibility : Icons.visibility_off),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        if (value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  Widget _buildGenderField() {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            title: Text(
              'Male',
              style: TextStyle(fontSize: 15),
            ),
            leading: Radio<String>(
              value: 'male',
              groupValue: gender,
              onChanged: (value) {
                setState(() {
                  gender = value;
                });
              },
              activeColor: Color.fromARGB(255, 201, 171, 129),
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: Text(
              'Female',
              style: TextStyle(fontSize: 15),
            ),
            leading: Radio<String>(
              value: 'female',
              groupValue: gender,
              onChanged: (value) {
                setState(() {
                  gender = value;
                });
              },
              activeColor: Color.fromARGB(255, 201, 171, 129),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return OutlinedButton(
      onPressed: _register,
      child: Text(
        'Sign Up',
        style: GoogleFonts.openSans(
          color: Colors.black,
          fontSize: 15,
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
    );
  }
}
