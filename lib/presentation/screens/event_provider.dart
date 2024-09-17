import 'package:flutter/material.dart';

class EventProvider extends ChangeNotifier {
  String? _selectedEventId;
  List<dynamic> _eventIds = [];

  String? get selectedEventId => _selectedEventId;
  List<dynamic> get eventIds => _eventIds;

  void setEventId(dynamic eventId) {
    _selectedEventId = eventId;
    notifyListeners();
  }

  void setEventIds(List<String> eventIds) {
    _eventIds = eventIds;
    notifyListeners();
  }
}
