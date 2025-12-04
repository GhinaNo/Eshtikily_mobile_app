import 'package:flutter/material.dart';

import '../../features/home/presentation/pages/home_page.dart';
import 'app_routes.dart';

import 'package:eshhtikiyl_app/features/auth/presentation/pages/gold_login_page.dart';
import 'package:eshhtikiyl_app/features/auth/presentation/pages/gold_signup_page.dart';
import 'package:eshhtikiyl_app/pages/create_complaint.dart';
import 'package:eshhtikiyl_app/pages/complaint_list.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignupPage());

      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case AppRoutes.createComplaint:
        return MaterialPageRoute(builder: (_) => const CreateComplaintPage());

      case AppRoutes.complaintList:
        return MaterialPageRoute(builder: (_) => const ListComplaintsPage());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("الصفحة غير موجودة")),
          ),
        );
    }
  }
}
