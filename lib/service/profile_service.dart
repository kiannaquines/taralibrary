import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:taralibrary/model/profile_model.dart';
import 'package:taralibrary/utils/constants.dart';
import 'dart:convert';
import 'package:taralibrary/service/service_app.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class ProfileService {
  String get baseUrl => ApiSettings.getApiUrl();

  Future<ApiResponse<T>> _getData<T>(String endpoint, String accessToken,
      T Function(Map<String, dynamic>) fromJson) async {
    final uri = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse(
        result: ApiResult.error,
        errorMessage: 'Error fetching data: $e',
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

  Future<ApiResponse<ProfileModel>> getProfile(String accessToken) async {
    return _getData<ProfileModel>(
        '/users/me', accessToken, ProfileModel.fromJson);
  }

  Future<ApiResponse<UpdateProfileModel>> updateProfileWithImage(
    int userId,
    String accessToken,
    UpdateProfileModel profile,
    XFile? imageFile,
  ) async {
    final String endpoint = '/users/me/update?user_id=$userId';

    final uri = Uri.parse('$baseUrl$endpoint');

    var request = http.MultipartRequest('PUT', uri)
      ..headers['Authorization'] = 'Bearer $accessToken'
      ..fields['email'] = profile.email
      ..fields['first_name'] = profile.firstName
      ..fields['last_name'] = profile.lastName;

    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'profile_img',
        imageFile.path,
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    try {
      final response = await request.send();
      debugPrint('Response Status Code: ${response.statusCode}');

      if (response.statusCode == 307) {
        final redirectUrl = response.headers['location'];
        return ApiResponse(
          result: ApiResult.error,
          errorMessage: 'Redirected to: $redirectUrl',
        );
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = await http.Response.fromStream(response);
        final data = jsonDecode(responseData.body);

        return ApiResponse(
          result: ApiResult.success,
          data: UpdateProfileModel.fromJson(data),
        );
      } else {
        final errorData = await http.Response.fromStream(response);
        final errorMessage = jsonDecode(errorData.body);

        return ApiResponse(
          result: ApiResult.error,
          errorMessage: errorMessage['message'] ?? 'Failed to update profile',
        );
      }
    } catch (e) {
      return ApiResponse(
        result: ApiResult.error,
        errorMessage: 'Server is unreachable, please try again later.',
      );
    }
  }
}
