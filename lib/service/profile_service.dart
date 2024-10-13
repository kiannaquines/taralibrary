import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:taralibrary/model/profile_model.dart';
import 'package:taralibrary/utils/constants.dart';
import 'dart:convert';
import 'package:taralibrary/service/service_app.dart';

class ProfileService {
  String get baseUrl => ApiSettings.getApiUrl();

  Future<ApiResponse<T>> _getData<T>(
      String endpoint,
      String accessToken,
      T Function(Map<String, dynamic>) fromJson) async {
    final uri = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10)); // Adding timeout

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      debugPrint('Error fetching data: $e');
      return ApiResponse(
        result: ApiResult.error,
        errorMessage: 'Error fetching data: $e',
      );
    }
  }

  ApiResponse<T> _handleResponse<T>(
      http.Response response, T Function(Map<String, dynamic>) fromJson) {
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body); // Expecting a single object
      return ApiResponse(
        result: ApiResult.success,
        data: fromJson(data),
      );
    } else if (response.statusCode == 401) {
      return ApiResponse(
        result: ApiResult.loginRequired,
        errorMessage: 'Authentication required',
      );
    } else {
      return ApiResponse(
        result: ApiResult.error,
        errorMessage: 'Failed to get data, status code: ${response.statusCode}',
      );
    }
  }

  Future<ApiResponse<ProfileModel>> getProfile(String accessToken) async {
    return _getData<ProfileModel>('/users/me', accessToken, ProfileModel.fromJson);
  }
}
