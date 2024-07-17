class Appointment {
  int? id;
  int? immunizationId;
  final String purpose;
  final String date;
  final String time;
  final String bhwOrNurse;
  final String notes;

  Appointment({
    this.id,
    this.immunizationId,
    required this.purpose,
    required this.date,
    required this.time,
    required this.bhwOrNurse,
    required this.notes,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      immunizationId: json['immunization_id'],
      purpose: json['purpose'],
      date: json['date'],
      time: json['time'],
      bhwOrNurse: json['bhwOrNurse'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'immunization_id': immunizationId,
      'purpose': purpose,
      'date': date,
      'time': time,
      'bhwOrNurse': bhwOrNurse,
      'notes': notes,
    };
  }
}
