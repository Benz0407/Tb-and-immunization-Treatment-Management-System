


class Event {
  int? id;
  final String purpose;
  final DateTime date;
  final String time;
  final String venue;
  final List<String> participants;
  final String bhwOrNurse;
  final String notes;

  Event({
    this.id,
    required this.purpose,
    required this.date,
    required this.time,
    required this.venue,
    required this.participants,
    required this.bhwOrNurse,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'purpose': purpose,
      'date': date.toIso8601String(),
      'time': time, 
      'venue': venue,
      'participants': participants,
      'bhwOrNurse': bhwOrNurse,
      'notes': notes,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: int.parse(json['id']),
      purpose: json['purpose'],
      date: DateTime.parse(json['date']),
      time: json['time'], 
      venue: json['venue'],
      participants: List<String>.from(json['participants']),
      bhwOrNurse: json['bhw_or_nurse_name'],
      notes: json['notes'],
    );
  }
}
