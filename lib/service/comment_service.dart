import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:taralibrary/utils/constants.dart';
import 'dart:convert';
import 'package:taralibrary/service/service_app.dart';

class CommentService {
  String get baseUrl => ApiSettings.getApiUrl();

  Future<ApiResponse> addCommentService({
    required String accessToken,
    required int zoneId,
    required int userId,
    required double rating,
    required String comment,
  }) async {
    final uri = Uri.parse('$baseUrl/comments/');
    final Map<String, dynamic> data = {
      'zone_id': zoneId,
      'user_id': userId,
      'rating': rating,
      'comment': comment,
    };

    try {
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      debugPrint('Error posting comment: $e');
      return ApiResponse(
        result: ApiResult.error,
        errorMessage: 'Error posting comment: $e',
      );
    }
  }

  ApiResponse _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ApiResponse(
        result: ApiResult.success,
        data: jsonDecode(response.body),
      );
    } else if (response.statusCode == 401) {
      return ApiResponse(
        result: ApiResult.loginRequired,
        errorMessage: 'Authentication required',
      );
    } else {
      return ApiResponse(
        result: ApiResult.error,
        errorMessage: 'Failed to post comment, status code: ${response.statusCode}',
      );
    }
  }
}
