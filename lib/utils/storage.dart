import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage extends FlutterSecureStorage {
  Storage() : super(aOptions: _getAndroidOptions());

  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  Future<void> addData(String key, String value) async {
    try {
      await write(key: key, value: value);
    } catch (e) {
      debugPrint('Error adding data: $e');
    }
  }

  Future<void> deleteData(String key) async {
    try {
      await delete(key: key);
    } catch (e) {
      debugPrint('Error removing data: $e');
    }
  }

  Future<String?> getData(String key) async {
    try {
      String? value = await read(key: key);
      return value;
    } catch (e) {
      debugPrint('Error retrieving data: $e');
      return null;
    }
  }
}

class MyStorage {
  final Storage _storage = Storage();

  Future<Map<String, dynamic>> fetchAccessToken() async {
    String? accessToken = await _storage.getData('accessToken');
    return {
      'accessToken': accessToken ?? '',
    };
  }
}
