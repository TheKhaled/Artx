import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Main_Button extends StatelessWidget {
  final String buttontext;
  final Color color;
  final VoidCallback onPressed; // Added onPressed as a parameter

  const Main_Button({
    super.key,
    required this.buttontext,
    required this.color,
    required this.onPressed, // Require the onPressed callback
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Color.fromARGB(255, 201, 171, 129), width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          buttontext,
          style: GoogleFonts.openSans(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ));
  }
}
