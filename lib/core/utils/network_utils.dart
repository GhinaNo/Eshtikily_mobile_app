// import '../network/network_info.dart';
//
// class NetworkUtils {
//   static Future<bool> isConnected() async {
//     return await NetworkInfo.checkInternet();
//   }
//
//   static Future<void> checkConnectionWithFeedback({
//     required Function() onConnected,
//     required Function(String) onDisconnected,
//   }) async {
//     final isConnected = await NetworkInfo.checkInternet();
//
//     if (isConnected) {
//       onConnected();
//     } else {
//       onDisconnected('لا يوجد اتصال بالإنترنت');
//     }
//   }
//
//   static Future<bool> retryWithConnection({
//     required Future<bool> Function() task,
//     int maxRetries = 3,
//     Duration delayBetweenRetries = const Duration(seconds: 2),
//   }) async {
//     for (int i = 0; i < maxRetries; i++) {
//       final hasInternet = await NetworkInfo.checkInternet();
//       if (!hasInternet) {
//         await Future.delayed(delayBetweenRetries);
//         continue;
//       }
//
//       try {
//         return await task();
//       } catch (e) {
//         if (i == maxRetries - 1) rethrow;
//         await Future.delayed(delayBetweenRetries);
//       }
//     }
//
//     return false;
//   }
// }