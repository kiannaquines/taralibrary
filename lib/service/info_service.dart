import 'package:taralibrary/service/service_app.dart';
import 'package:taralibrary/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:taralibrary/model/info_model.dart';
import 'dart:convert';

class InfoService {
  String get baseUrl => ApiSettings.getApiUrl();

  Future<ApiResponse<ZoneInfoModel>> getZoneInformation(
      String accessToken, int zoneID) async {
    final uri = Uri.parse('$baseUrl/zones/info/$zoneID');

    try {
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $accessToken',
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final zoneInfo = ZoneInfoModel.fromJson(data);
        return ApiResponse(result: ApiResult.success, data: zoneInfo);
      } else if (response.statusCode == 401) {
        return ApiResponse(
          result: ApiResult.loginRequired,
          errorMessage: 'Authentication required',
        );
      } else {
        return ApiResponse(
          result: ApiResult.error,
          errorMessage:
              'Failed to get zone information: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      return ApiResponse(
        result: ApiResult.error,
        errorMessage: 'Error fetching zone information: $e',
      );
    }
  }
}