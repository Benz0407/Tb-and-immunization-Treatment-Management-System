import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:management_of_immunizataion_and_tuberculosis_treatment/model/appointment_model.dart';

String getBaseUrl() {
  if (kIsWeb) {
    return 'http://127.0.0.1/Management';
  } else {
    return 'http://10.0.2.2/Management';
  }
}

class AppointmentService {

  Future<void> addAppointment(Appointment appointment) async {
    try {
      final response = await http.post(
        Uri.parse('${getBaseUrl()}/appointments.php'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(appointment.toJson()),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          print('Appointment added successfully: ${responseData['message']}');
        } else {
          throw Exception('Failed to add appointment: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to add appointment. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding appointment: $e');
    }
  }

  Future<List<Appointment>> fetchAppointmentsByImmunizationId(int? immunizationId) async {
    final response = await http.get(Uri.parse('${getBaseUrl()}/fetch_appointments.php?immunization_id=$immunizationId'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      List<Appointment> appointments = data.map((appointmentJson) {
        return Appointment(
          id: appointmentJson['id'],
          immunizationId: appointmentJson['immunization_id'],
          purpose: appointmentJson['purpose'],
          date: appointmentJson['date'],
          time: appointmentJson['time'],
          bhwOrNurse: appointmentJson['bhwOrNurse'],
          notes: appointmentJson['notes'],
        );
      }).toList();

      return appointments;
    } else {
      throw Exception('Failed to fetch appointments');
    }
  }
}
