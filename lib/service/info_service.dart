import 'package:taralibrary/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:taralibrary/model/info_model.dart';
import 'dart:convert';

class InfoService {
  String get baseUrl => ApiSettings.getApiUrl();

  Future<ZoneInfoModel> getZoneInformation(
      String accessToken, int zoneID) async {
    final uri = Uri.parse('$baseUrl/zones/info/$zoneID');

    try {
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $accessToken',
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return ZoneInfoModel.fromJson(data);
      } else {
        throw Exception(
            'Failed to get zone information: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching zone information: $e');
    }
  }
}
