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

      final Map<String, dynamic> result = jsonDecode(response.body);

      switch (response.statusCode) {
        case 200:
          return ForgotPasswordResponse(
            message: result['message'],
            statusCode: response.statusCode,
            userId: accountVerification.userId,
          ).toJson();
        case 500:
        case 404:
        case 400:
        case 307:
          return ErrorResponse(
            message: result['detail'],
            statusCode: response.statusCode,
          ).toJson();
        default:
          return ErrorResponse(
            message: 'Failed to verify account',
            statusCode: response.statusCode,
          ).toJson();
      }
    } catch (e) {
      return ErrorResponse(
        message: 'Something went wrong, please try again later',
        statusCode: 500,
      ).toJson();
    }
  }

  Future<Map<String, dynamic>> login(Login loginDetails) async {
    String endpoint = "/auth/login";
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(
      uri,
      body: loginDetails.toUrlEncoded(),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    final Map<String, dynamic> result = jsonDecode(response.body);

    switch (response.statusCode) {
      case 200:
        return LoginResponse(
          token: result['access_token'],
          message: 'Login successful, redirecting...',
          type: result['token_type'],
          statusCode: response.statusCode,
        ).toJson();

      case 422:
      case 401:
        return ErrorResponse(
          message: result['detail'],
          statusCode: response.statusCode,
        ).toJson();
      default:
        return ErrorResponse(
          message: 'Sorry, cannot login, try again later',
          statusCode: response.statusCode,
        ).toJson();
    }
  }

  Future<Map<String, dynamic>> forgotPassword(
      ForgotPassword forgotpassword) async {
    String endpoint = "/auth/request/forgot-password";
    final uri = Uri.parse('$baseUrl$endpoint');

    final response = await http.post(
      uri,
      body: jsonEncode(forgotpassword.toJson()),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    final Map<String, dynamic> result = jsonDecode(response.body);

    switch (response.statusCode) {
      case 200:
        return ForgotPasswordResponse(
          message: result['message'],
          statusCode: response.statusCode,
          userId: result['user_id'],
        ).toJson();

      case 422:
      case 401:
      case 404:
      case 500:
        return ErrorResponse(
          message: result['detail'] ?? 'Unknown error occurred',
          statusCode: response.statusCode,
        ).toJson();

      default:
        return ErrorResponse(
          message: 'Sorry, system error, try again later',
          statusCode: response.statusCode,
        ).toJson();
    }
  }

  Future<Map<String, dynamic>> changePasswordRequest(
    ChangePasswordModel changePassword,
  ) async {
    const String endpoint = "/auth/request/change-password";
    final uri = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.post(
        uri,
        body: jsonEncode(changePassword.toJson()),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      final Map<String, dynamic> result = jsonDecode(response.body);

      switch (response.statusCode) {
        case 200:
          return ForgotPasswordResponse(
            message: result['message'],
            statusCode: response.statusCode,
            userId: changePassword.userId,
          ).toJson();
        case 500:
        case 404:
        case 400:
        case 307:
          return ErrorResponse(
            message: result['detail'],
            statusCode: response.statusCode,
          ).toJson();
        default:
          return ErrorResponse(
            message: 'Failed to change account password',
            statusCode: response.statusCode,
          ).toJson();
      }
    } catch (e) {
      return ErrorResponse(
        message: 'Something went wrong, please try again later',
        statusCode: 500,
      ).toJson();
    }
  }


  Future<Map<String, dynamic>> changePasswordInAccount(
    ChangePasswordInAccount changePassword,
    String accessToken,
  ) async {
    const String endpoint = "/users/me/change-password";
    final uri = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.put(
        uri,
        body: jsonEncode(changePassword.toJson()),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      final Map<String, dynamic> result = jsonDecode(response.body);

      switch (response.statusCode) {
        case 200:
          return ForgotPasswordResponse(
            message: result['message'],
            statusCode: response.statusCode,
            userId: changePassword.userId,
          ).toJson();
        case 500:
        case 404:
        case 400:
        case 401:
        case 307:
          return ErrorResponse(
            message: result['detail'],
            statusCode: response.statusCode,
          ).toJson();
        default:
          return ErrorResponse(
            message: 'Failed to change account password',
            statusCode: response.statusCode,
          ).toJson();
      }
    } catch (e) {
      return ErrorResponse(
        message: 'Something went wrong, please try again later',
        statusCode: 500,
      ).toJson();
    }
  }
}
