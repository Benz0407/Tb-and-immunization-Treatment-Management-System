import 'package:flutter/foundation.dart';

class Appointment {
  final String purpose;
  final String date;
  final String time;
  final String bhwOrNurse;
  final String notes;
  final String residentName;

  Appointment({
    required this.purpose,
    required this.date,
    required this.time,
    required this.bhwOrNurse,
    required this.notes,
    required this.residentName, 
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      purpose: json['purpose'],
      date: json['date'],
      time: json['time'],
      bhwOrNurse: json['bhwOrNurse'],
      notes: json['notes'],
      residentName: json['residentName'], 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'purpose': purpose,
      'date': date,
      'time': time,
      'bhwOrNurse': bhwOrNurse,
      'notes': notes,
      'residentName': residentName,
    };
  }
}
