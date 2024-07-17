import 'package:intl/intl.dart';

class Tuberculosis {
  int? id;
  String name;
  String tbBrand;
  String batchNumber;
  String expiryDate;
  String dateAdministered;
  String administeredBy;
  String tbDiagnosisDate;
  String tbType;
  String treatmentStartDate;
  String medicinePrescribed;
  String dosage;
  String frequency;
  String treatmentCompletionDate;
  String diagnosticTestConducted;
  String diagnosticTestResult;
  String vaccinationHistory;
  String treatmentOutcome;
  String followupDate;
  String notes;

  Tuberculosis({
    this.id,
    required this.name,
    required this.tbBrand,
    required this.batchNumber,
    required this.expiryDate,
    required this.dateAdministered,
    required this.administeredBy,
    required this.tbDiagnosisDate,
    required this.tbType,
    required this.treatmentStartDate,
    required this.medicinePrescribed,
    required this.dosage,
    required this.frequency,
    required this.treatmentCompletionDate,
    required this.diagnosticTestConducted,
    required this.diagnosticTestResult,
    required this.vaccinationHistory,
    required this.treatmentOutcome,
    required this.followupDate,
    required this.notes,
  });

  factory Tuberculosis.fromJson(Map<String, dynamic> json) {

        // Define the date format you want
    final DateFormat dateFormatter = DateFormat('MM-dd-yyyy');

    // Helper function to parse and format the date
    String formatDate(String dateString) {
      DateTime parsedDate = DateTime.parse(dateString);
      return dateFormatter.format(parsedDate);
    }
    return Tuberculosis(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      tbBrand: json['tb_brand'],
      batchNumber: json['batch_number'],
      expiryDate: formatDate(json['expiry_date']),
      dateAdministered: formatDate(json['date_administered']),
      administeredBy: json['administered_by'],
      tbDiagnosisDate: formatDate(json['tb_diagnosis_date']),
      tbType: json['tb_type'],
      treatmentStartDate: formatDate(json['treatment_start_date']),
      medicinePrescribed: json['medicine_prescribed'],
      dosage: json['dosage'],
      frequency: json['frequency'],
      treatmentCompletionDate: formatDate(json['treatment_completion_date']),
      diagnosticTestConducted: json['diagnostic_test_conducted'],
      diagnosticTestResult: json['diagnostic_test_result'],
      vaccinationHistory: json['vaccination_history'],
      treatmentOutcome: json['treatment_outcome'],
      followupDate: formatDate(json['followup_date']),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tb_brand': tbBrand,
      'batch_number': batchNumber,
      'expiry_date': expiryDate,
      'date_administered': dateAdministered,
      'administered_by': administeredBy,
      'tb_diagnosis_date': tbDiagnosisDate,
      'tb_type': tbType,
      'treatment_start_date': treatmentStartDate,
      'medicine_prescribed': medicinePrescribed,
      'dosage': dosage,
      'frequency': frequency,
      'treatment_completion_date': treatmentCompletionDate,
      'diagnostic_test_conducted': diagnosticTestConducted,
      'diagnostic_test_result': diagnosticTestResult,
      'vaccination_history': vaccinationHistory,
      'treatment_outcome': treatmentOutcome,
      'followup_date': followupDate,
      'notes': notes,
    };
  }
}
