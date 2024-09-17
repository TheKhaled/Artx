import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/screens/Event_Details.dart';
import 'package:flutter_application_1/presentation/widgets/Color.dart';
import 'package:flutter_application_1/presentation/screens/event_provider.dart';
import 'package:flutter_application_1/presentation/widgets/Event_Searchbar.dart';
import 'package:flutter_application_1/presentation/widgets/Main_Appbar.dart';
import 'package:flutter_application_1/presentation/widgets/Transtion_Card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  Future<List<dynamic>> fetchEvents() async {
    final response = await http
        .get(Uri.parse('https://art-ecommerce-server.glitch.me/api/events'));

    if (response.statusCode == 200) {
      List<dynamic> events = json.decode(response.body);

      // Save event IDs globally
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      eventProvider
          .setEventIds(events.map((event) => event['_id'].toString()).toList());

      return events;
    } else {
      throw Exception('Failed to load events');
    }
  }

  bool _isOverlayVisible = false;
  String _searchQuery = '';

  void _toggleOverlay(bool isVisible) {
    setState(() {
      _isOverlayVisible = isVisible;
    });
  }

  void _handleSearch(String query, bool isNotEmpty) {
    setState(() {
      _searchQuery = query;
      _toggleOverlay(isNotEmpty);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: MainAppbar('Event', context),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SearchEventBarSection(
                  onSearch: _handleSearch,
                ),
                FutureBuilder<List<dynamic>>(
                  future: fetchEvents(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator(
                        color: theWebColor,
                      ));
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No events available'));
                    } else {
                      final events = snapshot.data!;

                      return Column(
                        children: events.map((event) {
                          return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.009),
                              child: GestureDetector(
                                onTap: () {
                                  // Save the selected event ID globally
                                  final eventProvider =
                                      Provider.of<EventProvider>(context,
                                          listen: false);
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
                                child: TransitionCard(
                                  backgroundImage: event['image'],
                                  eventTitle: event['title'],
                                  eventDetails: event['about'],
                                  nextScreen: EventDetails(
                                    imagePath: event['image'],
                                    productname: event['title'],
                                    location: event['location'],
                                    event_date: event['date'],
                                    productdetails: event['about'],
                                    eventId: event['_id'],
                                  ),
                                ),
                              ));
                        }).toList(),
                      );
                    }
                  },
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
          if (_isOverlayVisible)
            GestureDetector(
              onTap: () => _toggleOverlay(false),
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: EventOverlaySection(
                    searchQuery: _searchQuery,
                    onClose: () => _toggleOverlay(false),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
