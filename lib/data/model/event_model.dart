import 'package:flutter/material.dart';

class EventModel {
  final String id;
  final String eventName;
  final String eventDate;
  final String eventDetails;
  final String imagePath;

  EventModel({
    required this.id,
    required this.eventName,
    required this.eventDate,
    required this.eventDetails,
    required this.imagePath,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['_id'],
      eventName: json['title'],
      eventDate: json['date'],
      eventDetails: json['about'],
      imagePath: json['image'],
    );
  }
}
