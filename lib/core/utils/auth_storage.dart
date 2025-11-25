import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthStorage {
  static const String _authTokenKey = 'auth_token';
  static const String _userDataKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';

  static Future<void> saveAuthToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_authTokenKey, token);
      await prefs.setBool(_isLoggedInKey, true);
    } catch (e) {
      throw Exception('فشل في حفظ بيانات الجلسة');
    }
  }

  static Future<String?> getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_authTokenKey);
    } catch (e) {
      return null;
    }
  }

  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userDataKey, jsonEncode(userData));
    } catch (e) {
      throw Exception('فشل في حفظ بيانات المستخدم');
    }
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_userDataKey);
      return data != null ? jsonDecode(data) : null;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_authTokenKey);
      await prefs.remove(_userDataKey);
      await prefs.remove(_isLoggedInKey);
    } catch (e) {
      throw Exception('فشل في تسجيل الخروج');
    }
  }
}