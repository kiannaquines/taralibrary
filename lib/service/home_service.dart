import 'package:flutter/material.dart';
import 'package:taralibrary/model/home_model.dart';
import 'package:http/http.dart' as http;
import 'package:taralibrary/utils/constants.dart';
import 'dart:convert';
import 'package:taralibrary/service/service_app.dart';


class HomeService {
  String get baseUrl => ApiSettings.getApiUrl();

  Future<ApiResponse<List<T>>> _getData<T>(String endpoint, String accessToken, T Function(Map<String, dynamic>) fromJson) async {
    final uri = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $accessToken',
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return ApiResponse(
          result: ApiResult.success,
          data: data.map((item) => fromJson(item)).toList(),
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
    } catch (e) {
      debugPrint('Error fetching data: $e');
      return ApiResponse(
        result: ApiResult.error,
        errorMessage: 'Server is unreachable, please try again later.',
      );
    }
  }

  Future<ApiResponse<List<PopularModel>>> getPopularSection(String accessToken) async {
    return _getData('/zones/popular/', accessToken, PopularModel.fromJson);
  }

  Future<ApiResponse<List<RecommendedModel>>> getRecommendedSection(String accessToken) async {
    return _getData('/zones/recommended/', accessToken, RecommendedModel.fromJson);
  }

  Future<ApiResponse<List<CategoryModel>>> getCategories(String accessToken) async {
    return _getData('/category/', accessToken, CategoryModel.fromJson);
  }
}