import 'package:flutter/material.dart';
import 'package:taralibrary/model/home_model.dart';
import 'package:http/http.dart' as http;
import 'package:taralibrary/utils/constants.dart';
import 'dart:convert';

class HomeService {
  String get baseUrl => ApiSettings.getApiUrl();

  Future<List<PopularModel>> getPopularSection(String accessToken) async {
    String endpoint = "/zones/popular/";
    final uri = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $accessToken',
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data.map((item) => PopularModel.fromJson(item)).toList();
      } else {
        throw Exception(
            'Failed to get home data, status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching home data: $e');
      return [];
    }
  }

  Future<List<RecommendedModel>> getRecommendedSection(String accessToken) async {
    String endpoint = "/zones/recommended/";
    final uri = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $accessToken',
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data.map((item) => RecommendedModel.fromJson(item)).toList();
      } else {
        throw Exception(
            'Failed to get home data, status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching home data: $e');
      return [];
    }
  }


  Future<List<CategoryModel>> getCategories(String accessToken) async {
    String endpoint = "/category/";
    final uri = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $accessToken',
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data.map((item) => CategoryModel.fromJson(item)).toList();
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
