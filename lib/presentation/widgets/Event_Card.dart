import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/widgets/Main_Button.dart';
import 'package:getwidget/getwidget.dart';

class EventCard extends StatelessWidget {
  final String backgroundImage;
  final String eventTitle;
  final String eventDetails;
  final VoidCallback onpress;

  EventCard({
    required this.backgroundImage,
    required this.eventTitle,
    required this.eventDetails,
    required this.onpress,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight * 0.3; // 30% of screen height for image

    return Column(
      children: [
        Container(
          width: screenWidth,
          child: GFCard(
            padding: EdgeInsets.zero,
            content: Stack(
              children: [
                GFImageOverlay(
                  height: imageHeight,
                  width: screenWidth,
                  image: NetworkImage(backgroundImage),
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5),
                    BlendMode.darken,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20, // Add right padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eventTitle,
                        style: TextStyle(
                          fontSize: screenWidth *
                              0.06, // 6% of screen width for font size
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        eventDetails,
                        style: TextStyle(
                          fontSize: screenWidth *
                              0.04, // 4% of screen width for font size
                          color: Colors.white.withOpacity(0.9),
                        ),
                        overflow: TextOverflow
                            .ellipsis, // Truncate text if it overflows
                        maxLines: 1, // Limit to one line
                      ),
                      SizedBox(height: 10),
                      Main_Button(
                        buttontext: 'Show Event',
                        color: Colors.white,
                        onPressed: onpress,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
