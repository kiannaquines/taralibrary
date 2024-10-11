import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:taralibrary/model/section_models.dart';
import 'package:taralibrary/utils/constants.dart';
import 'dart:convert';

class SectionService {
  String get baseUrl => ApiSettings.getApiUrl();

  Future<List<AllSectionModel>> getAllSections(String accessToken) async {
    String endpoint = "/zones/all/";
    final uri = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $accessToken',
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data.map((item) => AllSectionModel.fromJson(item)).toList();
      } else {
        throw Exception(
            'Failed to get home data, status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching home data: $e');
      return [];
    }
  }
}
