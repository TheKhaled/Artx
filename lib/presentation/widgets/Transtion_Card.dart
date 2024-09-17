import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_1/presentation/widgets/Event_Card.dart';

class TransitionCard extends StatefulWidget {
  final String eventTitle;
  final String eventDetails;
  final String backgroundImage;
  final Widget nextScreen;

  const TransitionCard({
    Key? key,
    required this.eventTitle,
    required this.eventDetails,
    required this.backgroundImage,
    required this.nextScreen,
  }) : super(key: key);

  @override
  _TransitionCardState createState() => _TransitionCardState();
}

class _TransitionCardState extends State<TransitionCard> {
  bool _slowAnimations = true;

  @override
  Widget build(BuildContext context) {
    return EventCard(
      backgroundImage: widget.backgroundImage,
      eventTitle: widget.eventTitle,
      eventDetails: widget.eventDetails,
      onpress: () async {
        if (_slowAnimations) {
          // Apply slow animation only on the first click
          await Future<void>.delayed(const Duration(milliseconds: 50));
          timeDilation = 5.0; // Slow down the animation
          setState(() {
            _slowAnimations = false; // Disable slow animation for future taps
          });

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => widget.nextScreen,
            ),
          ).then((_) {
            // Reset timeDilation to normal after the transition completes
            WidgetsBinding.instance.addPostFrameCallback((_) {
              timeDilation = 1.0;
            });
          });
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => widget.nextScreen,
            ),
          );
        }
      },
    );
  }
}
