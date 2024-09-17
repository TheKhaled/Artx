import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/widgets/Main_Button.dart';
import 'package:google_fonts/google_fonts.dart';

class Category_Card extends StatelessWidget {
  final String backgroundImage;
  final String eventTitle;
  final String eventDetails;
  final VoidCallback onpress;

  Category_Card({
    required this.backgroundImage,
    required this.eventTitle,
    required this.eventDetails,
    required this.onpress,
  });

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Adjust sizes based on screen width and height
    final double cardHeight = screenHeight * 0.25; // 25% of screen height
    final double fontSizeTitle = screenWidth * 0.06; // 6% of screen width
    final double buttonHeight = screenHeight * 0.06; // 6% of screen height
    final double buttonWidth = screenWidth * 0.4; // 40% of screen width

    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.02, horizontal: screenWidth * 0.02),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: cardHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(backgroundImage),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Positioned(
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            bottom: screenHeight * 0.02,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventTitle,
                  style: GoogleFonts.ebGaramond(
                    color: Colors.white,
                    fontSize: fontSizeTitle,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                SizedBox(
                  width: buttonWidth,
                  height: buttonHeight,
                  child: Main_Button(
                    buttontext: 'Show Event',
                    color: Colors.white,
                    onPressed: onpress,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
