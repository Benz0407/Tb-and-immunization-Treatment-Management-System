import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/model/event_model.dart';

String getBaseUrl() {
  if (kIsWeb) {
    return 'http://127.0.0.1/Management';
  } else {
    return 'http://10.0.2.2/Management';
  }
}

class EventService {
  Future<List<Event>> fetchEvents() async {
    final apiUrl = Uri.parse('${getBaseUrl()}/fetch_events.php');
    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);

      // Print the raw JSON response for debugging
      print('Raw JSON response: $jsonResponse');

      // Handle empty response
      if (jsonResponse.isEmpty) {
        return [];
      }

      return jsonResponse.map((data) => Event.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load Events data');
    }
  }

  Future<List<String>> fetchAllParticipants() async {
    final response =
        await http.get(Uri.parse('${getBaseUrl()}/fetch_participants.php'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.cast<String>();
    } else {
      throw Exception('Failed to load participants');
    }
  }

  Future<void> saveEvent(Event eventData) async {
    final apiUrl = Uri.parse('${getBaseUrl()}/save_event.php');
    try {
      final response = await http.post(
        apiUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(eventData.toJson()),
      );

      // Debugging statement to check the response
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Decode the response body
      final responseData = jsonDecode(response.body);
      print('Decoded response data: $responseData');
    } catch (e) {
      print('Exception during event save: $e');
      throw Exception('Failed to save event');
    }
  }
}
