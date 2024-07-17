


import 'package:intl/intl.dart';

class Event {
  int? id;
  final String purpose;
  final String date;
  final String time;
  final String venue;
  List<String>? participants;
  final String bhwOrNurse;
  final String notes;

  Event({
    this.id,
    required this.purpose,
    required this.date,
    required this.time,
    required this.venue,
    this.participants,
    required this.bhwOrNurse,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'purpose': purpose,
      'date': date,
      'time': time, 
      'venue': venue,
      // 'participants': participants,
      'bhwOrNurse': bhwOrNurse,
      'notes': notes,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: int.parse(json['id']),
      purpose: json['purpose'] ?? '',
      date: json['date'].toString(),
      time: json['time'] ?? '', 
      venue: json['venue'] ?? '',
      // participants: json['participants'] != null ? List<String>.from(json['participants']) : null,
      bhwOrNurse: json['bhw_or_nurse_name'] ?? '',
      notes: json['notes'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Event(purpose: $purpose, date: $date, time: $time, venue: $venue, bhwOrNurse: $bhwOrNurse, notes: $notes, participants: $participants)';
  }

   DateTime get parsedDate {
    return DateFormat('yyyy-MM-dd').parse(date);
  }
}
