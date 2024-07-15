import 'package:intl/intl.dart';

class Immunization {
  int? id;
  final String name;
  final String history;
  final String vaccineName;
  final String vaccineBrand;
  final String batchNumber;
  final String expiryDate;
  final String dateAdministered;
  final String administeredBy;

  Immunization({
    this.id,
    required this.name,
    required this.history,
    required this.vaccineName,
    required this.vaccineBrand,
    required this.batchNumber,
    required this.expiryDate,
    required this.dateAdministered,
    required this.administeredBy,
  });

factory Immunization.fromJson(Map<String, dynamic> json) {
    // Define the date format you want
    final DateFormat dateFormatter = DateFormat('MM-dd-yyyy');

    // Helper function to parse and format the date
    String formatDate(String dateString) {
      DateTime parsedDate = DateTime.parse(dateString);
      return dateFormatter.format(parsedDate);
    }

    return Immunization(
      id: int.parse(json['id'].toString()),
      name: json['name'].toString(),
      history: json['history'].toString(),
      vaccineName: json['vaccine_name'].toString(),
      vaccineBrand: json['vaccine_brand'].toString(),
      batchNumber: json['batch_number'].toString(),
      expiryDate: formatDate(json['expiry_date']),
      dateAdministered: formatDate(json['date_administered']),
      administeredBy: json['administered_by'].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'history': history,
        'vaccine_name': vaccineName,
        'vaccine_brand': vaccineBrand,
        'batch_number': batchNumber,
        'expiry_date': expiryDate,
        'date_administered': dateAdministered,
        'administered_by': administeredBy,
      };
}
