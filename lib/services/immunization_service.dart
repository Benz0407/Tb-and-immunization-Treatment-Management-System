import 'package:flutter/foundation.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/model/immunization_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

String getBaseUrl() {
  if (kIsWeb) {
    return 'http://127.0.0.1/Management';
  } else {
    return 'http://10.0.2.2:/Management';
  }
}

class ImmunizationService {

  Future<List<Immunization>> fetchImmunization() async {
    final apiUrl = Uri.parse('${getBaseUrl()}/immunization.php');
    final response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Immunization.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load immunization data');
    }
  }

  Future<List<Immunization>> searchImmunizations(String query) async {
    final response = await http.get(Uri.parse('${getBaseUrl()}/search.php?q=$query'));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      List<Immunization> immunizations = jsonList.map((e) => Immunization.fromJson(e)).toList();
      return immunizations;
    } else {
      throw Exception('Failed to search immunizations');
    }
  }

  Future<Immunization> fetchImmunizationById(int? id) async {
  final fetchUrl = Uri.parse('${getBaseUrl()}/fetch_by_id.php');
  final response = await http.post(
    fetchUrl,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'id': id.toString()}),
  );

  // print('Response status: ${response.statusCode}');
  // print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    final data = json.decode(response.body) as Map<String, dynamic>;
    // print('Parsed JSON: $data');
    if (data.containsKey('message')) {
      throw Exception('No record found');
    } else {
      return Immunization.fromJson(data);
    }
  } else {
    throw Exception('Failed to load immunization');
  }
}

  Future<void> saveImmunization(Immunization immunization) async {
    final saveUrl = Uri.parse('${getBaseUrl()}/save_immunization.php');

    try {
      final response = await http.post(
        saveUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(immunization.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to save immunization');
      }
    } catch (e) {
      throw Exception('Failed to save immunization');
    }
  }

  Future<void> updateImmunization(Immunization immunization) async {
    final url = Uri.parse('${getBaseUrl()}/update_immunization.php');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(immunization.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update immunization');
    }
  }
}
