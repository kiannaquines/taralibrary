import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:taralibrary/model/comment_model.dart';
import 'package:taralibrary/utils/constants.dart';
import 'dart:convert';
import 'package:taralibrary/service/service_app.dart';

class CommentService {
  String get baseUrl => ApiSettings.getApiUrl();

  Future<ApiResponse<AddCommentModel>> postComment(
      String accessToken, String comment, double rating, int userId, int zoneID) async {
    final uri = Uri.parse('$baseUrl/comments/');

    final Map<String, dynamic> requestBody = {
      'comment': comment,
      'rating': rating,
      'user_id': userId,
      'zone_id': zoneID,
    };

    try {
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      ).timeout(const Duration(seconds: 10));

      return _handleResponse<AddCommentModel>(
          response, AddCommentModel.fromJson);
    } catch (e) {
      debugPrint('Error posting comment: $e');
      return ApiResponse(
        result: ApiResult.error,
        errorMessage: 'Error posting comment: $e',
      );
    }
  }

  ApiResponse<T> _handleResponse<T>(
      http.Response response, T Function(Map<String, dynamic>) fromJson) {
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
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
}
