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
      // print('Raw JSON response: $jsonResponse');

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

  Future<void> saveEvent(Event event, List<String> participants) async {
    final apiUrl = Uri.parse('${getBaseUrl()}/save_event.php');
    
    // Convert participants list to a JSON array
    List<Map<String, dynamic>> participantsJson = participants.map((name) => {'participant_name': name}).toList();
    
    // Create payload
    Map<String, dynamic> payload = {
      'purpose': event.purpose,
      'date': event.date,
      'time': event.time,
      'venue': event.venue,
      'bhwOrNurse': event.bhwOrNurse,
      'notes': event.notes,
      'participants': json.encode(participantsJson), // Convert to JSON string
    };

    // Make POST request
    final response = await http.post(
      apiUrl,
      body: json.encode(payload),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // print('Event saved successfully');
    } else {
      throw Exception('Failed to save event');
    }
  }

Future<List<String>> fetchEventParticipants(int eventId) async {
  // print('Fetching participants for event ID: $eventId');
  
  final response = await http.get(
    Uri.parse('${getBaseUrl()}/fetch_event_participants.php?event_id=$eventId'),
  );

  // print('Response status: ${response.statusCode}');
  // print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    // print('Parsed response data: $data');

    // Ensure 'success' is treated as a boolean
    bool success = data['success'] == true;

    if (success) {
      List<String> participants = List<String>.from(data['participants']);
      // print('Participants: $participants');
      return participants;
    } else {
      // print('Error: ${data['message']}');
      throw Exception(data['message']);
    }
  } else {
    // print('Failed to load participants');
    throw Exception('Failed to load participants');
  }
}




}

