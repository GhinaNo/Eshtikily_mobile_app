import 'package:eshhtikiyl_app/core/network/http_client.dart';
import 'package:eshhtikiyl_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter/material.dart';
import '../utils/auth_storage.dart';
import '../utils/toast_services.dart';

class LogoutService {
  static final _remote = AuthRemoteDataSource(httpClient: HttpClient());

  static Future<bool> showLogoutConfirmation(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text(
            'تسجيل الخروج',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: const Text(
            'هل أنت متأكد أنك تريد تسجيل الخروج؟',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          actionsAlignment: MainAxisAlignment.start,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('تسجيل الخروج', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    ) ??
        false;
  }

  static Future<bool> performLogout(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      await _remote.logout();

      await AuthStorage.clearAllData();

      if (context.mounted) Navigator.pop(context);

      if (context.mounted) {
        ToastService.showSuccess(context, 'تم تسجيل الخروج بنجاح', title: 'نجاح');
      }

      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
      }

      return true;
    } catch (e) {
      if (context.mounted) Navigator.pop(context);

      if ('$e'.contains('401') || '$e'.contains('انتهت')) {
        await AuthStorage.clearAllData();

        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);

          ToastService.showInfo(
            context,
            'انتهت جلستك، يرجى تسجيل الدخول مرة أخرى',
            title: 'انتهت الجلسة',
          );
        }
        return false;
      }

      if (context.mounted) {
        ToastService.showError(context, 'فشل في تسجيل الخروج: $e', title: 'خطأ');
      }
      return false;
    }
  }

  static Future<void> handleLogout(BuildContext context) async {
    if (await showLogoutConfirmation(context)) {
      await performLogout(context);
    }
  }
}
