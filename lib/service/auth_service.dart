import 'package:taralibrary/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:taralibrary/model/auth_models.dart';
import 'dart:convert';

class AuthService {
  String get baseUrl => ApiSettings.getApiUrl();

  Future<Map<String, dynamic>> registerService(
    RegisterModel registerModel,
  ) async {
    const String endpoint = "/auth/register";
    final uri = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.post(
        uri,
        body: jsonEncode(registerModel.toJson()),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return {
          'current_id': responseData['user']['id'] ?? 0,
          'message': responseData['message'],
          'status_code': response.statusCode,
        };
      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return {
          'current_id': 0,
          'message': responseData['detail'] ?? 'An error occurred',
          'status_code': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'current_id': 0,
        'message': 'Failed to register user: $e',
        'status_code': 500,
      };
    }
  }

  Future<Map<String, dynamic>> verificationAccount(
    AccountVerification accountVerification,
  ) async {
    const String endpoint = "/auth/register/verify";
    final uri = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.post(
        uri,
        body: jsonEncode(accountVerification.toJson()),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'message': responseData['message'],
          'status_code': response.statusCode,
        };
      } else {
        return {
          'message': responseData['detail'],
          'status_code': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'message': 'Failed to verify account',
        'status_code': 500,
      };
    }
  } 


  Future<Map<String, dynamic>> login() async{


    String endpoint = "/auth/login";
    final uri = Uri.parse('$baseUrl$endpoint');

    
    try {
      return {
        'access_token': 'this is the JWT token',
        'type': 'bearer',
        'status_code': 200,
      }
    } catch (e) {
      return {
        'access_token': '',
        'status_code': 500,
      };
    }
  }












  // Future<Map<String, dynamic>> login(Login loginDetails) async {
  //   String endpoint = "/auth/login";
  //   final uri = Uri.parse('$baseUrl$endpoint');


  //   try {
  //     return {
  //       'access_token': 'this is the JWT token',
  //       'type': 'bearer',
  //       'status_code': 200,
  //     };
  //   } catch (e) {
  //     return {
  //       'access_token': '',
  //       'status_code': 500,
  //     };
  //   }
  // }
}
