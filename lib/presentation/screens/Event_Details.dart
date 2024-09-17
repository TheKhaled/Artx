import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/globals.dart';
import 'package:flutter_application_1/presentation/widgets/Category_Appbar.dart';
import 'package:flutter_application_1/presentation/widgets/Main_Button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class EventDetails extends StatelessWidget {
  final String imagePath;
  final String productname;
  final String productdetails;
  final String location;
  final String event_date;
  final String eventId;

  EventDetails({
    required this.imagePath,
    required this.productname,
    required this.productdetails,
    required this.location,
    required this.event_date,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      appBar: CustomAppBar(title: 'Event Details'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: BottomHalfCircleClipper(),
              child: Image.network(
                imagePath,
                width: double.infinity,
                height: screenHeight * 0.35,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(child: Icon(Icons.error, size: 50));
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productname,
                    style: GoogleFonts.ebGaramond(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Divider(color: Color.fromARGB(255, 201, 171, 129)),
                  SizedBox(height: screenHeight * 0.02),
                  Container(
                    height: screenHeight * 0.25,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description',
                            style: GoogleFonts.ebGaramond(
                              fontSize: screenWidth * 0.06,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Text(
                            productdetails,
                            style: GoogleFonts.openSans(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Divider(color: Color.fromARGB(255, 201, 171, 129)),
                  SizedBox(height: screenHeight * 0.02),
                  _buildInfoRow(
                    icon: Icons.place_outlined,
                    text: location,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _buildInfoRow(
                    icon: Icons.date_range_outlined,
                    text: event_date,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Center(
                    child: Main_Button(
                      buttontext: 'Buy Ticket',
                      color: Colors.black,
                      onPressed: () {
                        final String token = authToken!;
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: AlertDialog(
                                title: Text(
                                  'Ticket Booking',
                                  style: GoogleFonts.ebGaramond(
                                    fontSize: screenWidth * 0.06,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                content: FormPopup(
                                  eventId: eventId,
                                  token: token,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    required double screenWidth,
    required double screenHeight,
  }) {
    return Row(
      children: [
        Icon(icon, size: screenWidth * 0.07),
        SizedBox(width: screenWidth * 0.03),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.ebGaramond(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class FormPopup extends StatefulWidget {
  final String eventId;
  final String token;

  FormPopup({required this.eventId, required this.token});

  @override
  _FormPopupState createState() => _FormPopupState();
}

class _FormPopupState extends State<FormPopup> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _phone;
  String? _email;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Map<String, String> clientInfo = {
        'name': _name!,
        'email': _email!,
        'phone_number': _phone!,
      };
      String url =
          'https://art-ecommerce-server.glitch.me/api/ticket/${widget.eventId}';

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${widget.token}',
          },
          body: json.encode(clientInfo),
        );

        if (response.statusCode == 200) {
          Navigator.of(context).pop();
          Future.delayed(Duration(milliseconds: 200), () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  title: Text(
                    'Congratulations!',
                    style: GoogleFonts.ebGaramond(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  content: Text(
                    'You have been submitted. \nWait for a message on your email.',
                    style: GoogleFonts.openSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        'Ok',
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
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to book ticket: ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error occurred: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _buildTextField(
                label: 'Name',
                onSaved: (value) => _name = value,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your full name'
                    : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _buildTextField(
                label: 'Phone',
                onSaved: (value) => _phone = value,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your phone number'
                    : null,
              ),
            ),
            _buildTextField(
              label: 'E-mail',
              onSaved: (value) => _email = value,
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter your email'
                  : null,
            ),
            SizedBox(height: screenHeight * 0.02),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(
                'Submit',
                style: GoogleFonts.openSans(
                  color: Colors.black,
                  fontSize: 16,
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
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.openSans(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 201, 171, 129))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 201, 171, 129))),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }
}

class BottomHalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.7);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height * 0.7);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
