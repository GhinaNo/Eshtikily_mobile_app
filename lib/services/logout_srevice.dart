import 'package:eshhtikiyl_app/core/network/http_client.dart';
import 'package:eshhtikiyl_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter/material.dart';
import '../core/utils/auth_storage.dart';
import '../core/utils/toast_services.dart';

class LogoutService {
  static Future<bool> showLogoutConfirmation(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'تسجيل الخروج',
            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
            textAlign: TextAlign.right,
          ),
          content: const Text(
            'هل أنت متأكد أنك تريد تسجيل الخروج؟',
            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
            textAlign: TextAlign.right,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'إلغاء',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'تسجيل الخروج',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
          actionsAlignment: MainAxisAlignment.start,
        );
      },
    );

    return result ?? false;
  }

  static Future<void> performLogout(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      await AuthRemoteDataSource(httpClient: HttpClient()).logout();

      await AuthStorage.clearAllData();

      if (context.mounted) Navigator.of(context).pop();

      if (context.mounted) {
        ToastService.showSuccess(
            context,
            'تم تسجيل الخروج بنجاح',
            title: 'نجاح'
        );
      }

      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/login',
                (route) => false
        );
      }

    } catch (e) {
      if (context.mounted) Navigator.of(context).pop();

      if (e.toString().contains('401') || e.toString().contains('انتهت')) {
        await AuthStorage.clearAllData();

        if (context.mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/login',
                  (route) => false
          );
          ToastService.showInfo(
              context,
              'انتهت جلستك، يرجى تسجيل الدخول مرة أخرى',
              title: 'انتهت الجلسة'
          );
        }
      } else {
        if (context.mounted) {
          ToastService.showError(
              context,
              'فشل في تسجيل الخروج: $e',
              title: 'خطأ'
          );
        }
      }
    }
  }
  static Future<void> handleLogout(BuildContext context) async {
    final confirmed = await showLogoutConfirmation(context);

    if (confirmed) {
      await performLogout(context);
    }
  }
}