import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../utils/auth_storage.dart';
import '../utils/error_handler_services.dart';
import '../utils/logger.dart';
import '../utils/app_messages.dart';

extension FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}

class HttpClient {
  Future<Map<String, dynamic>> post({
    required String endpoint,
    required Map<String, dynamic> data,
    bool requiresAuth = false,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');

      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      if (requiresAuth) {
        final token = await AuthStorage.getAuthToken();
        if (token != null) {
          headers['Authorization'] = 'Bearer $token';
          Logger.debug('Using token: ${token.substring(0, 20)}...');
        } else {
          Logger.error('No token found for authenticated request');
          throw Exception('لم يتم العثور على رمز الجلسة');
        }
      }

      Logger.api('POST', endpoint);
      Logger.debug('URL: $url');
      Logger.debug('Data: $data');
      Logger.debug('Headers: $headers');

      final response = await http
          .post(url, headers: headers, body: json.encode(data))
          .timeout(const Duration(seconds: ApiConstants.timeoutSeconds));

      Logger.debug('Status: ${response.statusCode}');
      Logger.debug('Response: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      Logger.error('Request failed', error: e);

      if (requiresAuth && e.toString().contains('401')) {
        Logger.error('Token expired, clearing local data');
        await AuthStorage.clearAllData();
      }

      final arabicError = ErrorHandlerService.handleApiError(e);
      throw Exception(arabicError);
    }
  }

  Future<Map<String, dynamic>> get({
    required String endpoint,
    Map<String, String>? headers,
    bool requiresAuth = false,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');

      final finalHeaders = headers ?? <String, String>{
        'Accept': 'application/json',
      };

      if (requiresAuth) {
        final token = await AuthStorage.getAuthToken();
        if (token != null) {
          finalHeaders['Authorization'] = 'Bearer $token';
        }
      }

      Logger.api('GET', endpoint);
      Logger.debug('URL: $url');
      Logger.debug('Headers: $finalHeaders');

      final response = await http
          .get(url, headers: finalHeaders)
          .timeout(const Duration(seconds: ApiConstants.timeoutSeconds));

      Logger.debug('Status: ${response.statusCode}');
      Logger.debug('Response: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      Logger.error('GET Request failed', error: e);
      final arabicError = ErrorHandlerService.handleApiError(e);
      throw Exception(arabicError);
    }
  }

  Future<bool> ping() async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}/');
      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
      );

      Logger.debug('Ping status: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      Logger.error('Ping failed', error: e);
      return false;
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final responseBody = response.body;

    // ✅ التعامل مع انتهاء الجلسة مباشرة
    if (statusCode == 401) {
      AuthStorage.clearAllData();
      throw Exception('انتهت الجلسة. يرجى تسجيل الدخول مرة أخرى.');
    }

    if (responseBody.isEmpty) {
      throw Exception(AppMessages.serverError);
    }

    try {
      final jsonResponse = json.decode(responseBody);

      if (statusCode >= 200 && statusCode < 300) {
        return jsonResponse;
      } else {
        final errorMessage = _extractArabicErrorMessage(jsonResponse, statusCode);
        throw Exception(errorMessage);
      }
    } catch (e) {
      Logger.error('JSON parse failed', error: e);
      throw Exception(AppMessages.serverError);
    }
  }

  String _extractArabicErrorMessage(Map<String, dynamic> jsonResponse, int statusCode) {
    final rawMessage = jsonResponse['message'] ?? jsonResponse['error'] ?? '';
    final errors = jsonResponse['errors'];

    return _translateErrorMessage(rawMessage.toString(), statusCode, errors: errors);
  }

  String _translateErrorMessage(String message, int statusCode, {Map<String, dynamic>? errors}) {
    final messageLower = message.toLowerCase();

     if (statusCode == 422) {
    if (messageLower.contains('phone number has already been taken')) {
    return 'رقم الهاتف مستخدم مسبقاً';
    }
    return 'بيانات غير صحيحة. يرجى مراجعة المدخلات';
    }


    if (messageLower.contains('the email has already been taken')) {
      return AppMessages.emailAlreadyExists;
    } else if (messageLower.contains('the phone number has already been taken')) {
      return 'رقم الهاتف مستخدم مسبقاً';
    } else if (messageLower.contains('invalid verification code') ||
        messageLower.contains('wrong code')) {
      return AppMessages.invalidVerificationCode;
    } else if (messageLower.contains('these credentials do not match our records')) {
      return AppMessages.invalidCredentials;
    } else if (messageLower.contains('unauthenticated') ||
        messageLower.contains('token')) {
      return AppMessages.unauthorized;
    } else if (messageLower.contains('server error') ||
        messageLower.contains('internal server')) {
      return AppMessages.serverError;
    } else if (statusCode == 404) {
      return 'لم يتم العثور على الصفحة المطلوبة';
    } else if (statusCode == 500) {
      return AppMessages.serverError;
    } else if (statusCode == 403) {
      return 'ليس لديك صلاحية للوصول إلى هذا المورد';
    }

    if (message.isNotEmpty && message.length < 100 && _isUserFriendly(message)) {
      return message;
    }

    return 'حدث خطأ (رمز: $statusCode)';
  }

  bool _isUserFriendly(String message) {
    final technicalTerms = [
      'exception',
      'error',
      'failed',
      'null',
      'undefined',
      'sql',
      'database',
      'query',
      'syntax',
      'stack trace',
    ];

    return !technicalTerms.any((term) => message.toLowerCase().contains(term));
  }
}
