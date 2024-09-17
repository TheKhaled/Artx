import 'dart:convert'; // for jsonDecode
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/screens/Event_Details.dart';
import 'package:flutter_application_1/presentation/screens/event_provider.dart';
import 'package:flutter_application_1/presentation/widgets/Color.dart';
import 'package:http/http.dart' as http; // for making HTTP requests
import 'package:provider/provider.dart';
import 'Category_Card.dart'; // assuming Category_Card is in a separate file

class ComplicatedImageDemo extends StatefulWidget {
  @override
  _ComplicatedImageDemoState createState() => _ComplicatedImageDemoState();
}

class _ComplicatedImageDemoState extends State<ComplicatedImageDemo> {
  Future<List<dynamic>> fetchEvents() async {
    final response = await http
        .get(Uri.parse('https://art-ecommerce-server.glitch.me/api/events'));

    if (response.statusCode == 200) {
      List<dynamic> events = jsonDecode(response.body);
      return events;
    } else {
      throw Exception('Failed to load events');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchEvents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: theWebColor,
          ));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading events'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No events found'));
        } else {
          List<dynamic> events = snapshot.data!;
          List<Widget> imageSliders = events.map((event) {
            // Handle null values safely
            String backgroundImage = event['image'] ??
                'https://via.placeholder.com/300'; // Placeholder if null
            String eventTitle =
                event['title'] ?? 'Untitled Event'; // Default title if null
            String eventDetails = event['description'] ??
                'No details available'; // Default description if null

            return Category_Card(
              backgroundImage: backgroundImage,
              eventTitle: eventTitle,
              eventDetails: eventDetails,
              onpress: () {
                final eventProvider =
                    Provider.of<EventProvider>(context, listen: false);
                eventProvider.setEventId(event['_id']);

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EventDetails(
                      imagePath: event['image'],
                      productname: event['title'],
                      location: event['location'],
                      event_date: event['date'],
                      productdetails: event['about'],
                      eventId: event['_id'],
                    ),
                  ),
                );
              },
            );
          }).toList();

          return CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 2.0,
              enlargeCenterPage: true,
            ),
            items: imageSliders,
          );
        }
      },
    );
  }
}
