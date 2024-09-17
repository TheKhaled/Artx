import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/model/event_model.dart';
import 'package:flutter_application_1/presentation/screens/Event_Details.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class SearchEventBarSection extends StatefulWidget {
  final Function(String, bool) onSearch;

  SearchEventBarSection({required this.onSearch});

  @override
  _SearchEventBarSectionState createState() => _SearchEventBarSectionState();
}

class _SearchEventBarSectionState extends State<SearchEventBarSection> {
  List<EventModel> _events = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http
          .get(Uri.parse('https://art-ecommerce-server.glitch.me/api/events'));

      if (response.statusCode == 200) {
        List<dynamic> eventList = json.decode(response.body);
        setState(() {
          _events = eventList.map((json) => EventModel.fromJson(json)).toList();
        });
      }
    } catch (e) {
      print('Error fetching events: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What event are you looking for?',
          style: GoogleFonts.ebGaramond(
            fontSize: screenWidth * 0.06, // 6% of screen width
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: screenWidth * 0.04), // 4% of screen width
        TextField(
          onChanged: (query) {
            widget.onSearch(query, query.isNotEmpty);
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: screenWidth * 0.04),
            hintText: 'Search events...',
            hintStyle: GoogleFonts.openSans(
              fontSize: screenWidth * 0.04, // 4% of screen width
              color: Colors.grey[600],
            ),
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  screenWidth * 0.08), // 8% of screen width
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  screenWidth * 0.08), // 8% of screen width
              borderSide: BorderSide(
                color: Color.fromARGB(255, 201, 171, 129),
                width: 2.0,
              ),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Color.fromARGB(255, 201, 171, 129),
              size: screenWidth * 0.06, // 6% of screen width
            ),
          ),
        ),
      ],
    );
  }
}

class EventOverlaySection extends StatelessWidget {
  final String searchQuery;
  final Function onClose;

  EventOverlaySection({required this.searchQuery, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: http
          .get(Uri.parse('https://art-ecommerce-server.glitch.me/api/events')),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error fetching events'));
        }

        List<dynamic> events = json.decode(snapshot.data!.body);

        List<EventModel> filteredEvents = events
            .map((json) => EventModel.fromJson(json))
            .where((event) => event.eventName
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
            .toList();

        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

        return Align(
          alignment: Alignment.center,
          child: Material(
            elevation: 8,
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(screenWidth * 0.05), // 5% of screen width
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.04), // 4% of screen width
              child: Container(
                width: screenWidth * 0.9, // 90% of screen width
                constraints: BoxConstraints(
                  maxHeight: screenHeight * 0.6, // 60% of screen height
                ),
                child: filteredEvents.isNotEmpty
                    ? ListView.builder(
                        itemCount: filteredEvents.length,
                        itemBuilder: (context, index) {
                          final event = filteredEvents[index];
                          return ListTile(
                            onTap: () async {
                              final response = await http.get(Uri.parse(
                                  'https://art-ecommerce-server.glitch.me/api/events/${event.id}'));
                              if (response.statusCode == 200) {
                                final eventDetails = json.decode(response.body);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EventDetails(
                                      imagePath: eventDetails['image'],
                                      productname: eventDetails['title'],
                                      productdetails: eventDetails['about'],
                                      location: eventDetails['location'],
                                      event_date: eventDetails['date'],
                                      eventId: eventDetails['_id'],
                                    ),
                                  ),
                                );
                                onClose(); // Close the overlay on tap
                              }
                            },
                            leading: Image.network(
                              event.imagePath,
                              width: screenWidth * 0.1, // 10% of screen width
                              height: screenWidth * 0.1, // 10% of screen width
                              fit: BoxFit.cover,
                            ),
                            title: Text(
                              event.eventName,
                              style: GoogleFonts.openSans(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    screenWidth * 0.04, // 4% of screen width
                              ),
                            ),
                            subtitle: Text(
                              event.eventDate,
                              style: GoogleFonts.openSans(
                                fontSize:
                                    screenWidth * 0.03, // 3% of screen width
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          'No events found',
                          style: GoogleFonts.openSans(
                            fontSize: screenWidth * 0.04, // 4% of screen width
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
