import 'package:flutter/foundation.dart';
import 'package:management_of_immunizataion_and_tuberculosis_treatment/model/tb_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String getBaseUrl() {
  if (kIsWeb) {
    return 'http://127.0.0.1/Management';
  } else {
    return 'http://10.0.2.2:/Management';
  }
}

class TbService {

  Future<List<Tuberculosis>> fetchTuberculosis() async {
    final apiUrl = Uri.parse('${getBaseUrl()}/tb.php');
    final response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Tuberculosis.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load tuberculosis data');
    }
  }

  Future<List<Tuberculosis>> searchTbRecords(String query) async {
    final response = await http.get(Uri.parse('${getBaseUrl()}/tb_search.php?q=$query'));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      List<Tuberculosis> tb = jsonList.map((e) => Tuberculosis.fromJson(e)).toList();
      return tb;
    } else {
      throw Exception('Failed to search tuberculosis records');
    }
  }

  Future<Tuberculosis> fetchTuberculosisById(int? id) async {
    final fetchUrl = Uri.parse('${getBaseUrl()}/fetch_tb_by_id.php');
    final response = await http.post(
      fetchUrl,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id': id.toString()}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data.containsKey('message')) {
        throw Exception('No record found');
      } else {
        return Tuberculosis.fromJson(data);
      }
    } else {
      throw Exception('Failed to load tuberculosis');
    }
  }

  Future<void> saveTuberculosis(Tuberculosis tuberculosis) async {
    final saveUrl = Uri.parse('${getBaseUrl()}/save_tb.php');

    try {
      final response = await http.post(
        saveUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(tuberculosis.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to save tuberculosis');
      }
    } catch (e) {
      throw Exception('Failed to save tuberculosis');
    }
  }

  Future<void> updateTuberculosis(Tuberculosis tuberculosis) async {
    final url = Uri.parse('${getBaseUrl()}/update_tb.php');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(tuberculosis.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update tuberculosis');
    }
  }
}
