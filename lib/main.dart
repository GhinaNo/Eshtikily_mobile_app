import 'package:eshhtikiyl_app/background_message_handler.dart';
import 'package:eshhtikiyl_app/pages/complaint_list.dart';
import 'package:eshhtikiyl_app/pages/create_complaint.dart';
import 'package:eshhtikiyl_app/features/auth/presentation/pages/gold_login_page.dart';
import 'package:eshhtikiyl_app/features/auth/presentation/pages/gold_signup_page.dart';
import 'package:eshhtikiyl_app/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/services/login_protection_service.dart';
import 'core/services/notification_services.dart';
import 'core/utils/auth_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyC19OHwq0BeMVKw5q3nft5liuzJtnzz6RI",
      appId: "1:95532699305:android:1e9ff37061bf6953e2e3b8",
      messagingSenderId: "95532699305",
      projectId: "vendorslist-8abd3",
    ),
  );

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await NotificationService.initialize();
  await LoginProtectionService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيق الشكاوى الحكومية',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFF0A3C3A),
        fontFamily: 'Almarai',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(168, 10, 60, 58),
          elevation: 3.0,
          titleTextStyle: TextStyle(
            fontFamily: 'Almarai',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Almarai',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          displayMedium: TextStyle(
            fontFamily: 'Almarai',
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Almarai',
            fontSize: 16,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Almarai',
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'AE'),
        Locale('en', 'US'),
      ],
      locale: const Locale('ar', 'AE'),
      home: FutureBuilder(
        future: AuthStorage.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final isLoggedIn = snapshot.data ?? false;
          return isLoggedIn ? const HomePage() : const LoginPage();
        },
      ),
      routes: {
        '/signup': (_) => const SignupPage(),
        '/login': (_) => const LoginPage(),
        '/create-complaint': (_) => const CreateComplaintPage(),
        '/list-complaint': (_) => const ListComplaintsPage(),
        '/home-page':(_) => const HomePage(),
      },
    );
  }
}