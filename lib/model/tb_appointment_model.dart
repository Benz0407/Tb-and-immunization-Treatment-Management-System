class TbAppointment {
  int? id;
  int? tuberculosisId;
  final String purpose;
  final String date;
  final String time;
  final String bhwOrNurse;
  final String notes;

  TbAppointment({
    this.id,
    this.tuberculosisId,
    required this.purpose,
    required this.date,
    required this.time,
    required this.bhwOrNurse,
    required this.notes,
  });

  factory TbAppointment.fromJson(Map<String, dynamic> json) {
    return TbAppointment(
      id: json['id'],
      tuberculosisId: json['tuberculosis_id'],
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
      'tuberculosis_id': tuberculosisId,
      'purpose': purpose,
      'date': date,
      'time': time,
      'bhwOrNurse': bhwOrNurse,
      'notes': notes,
    };
  }
}
