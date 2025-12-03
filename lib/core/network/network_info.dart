// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// class NetworkInfo {
//   static final NetworkInfo _instance = NetworkInfo._internal();
//   factory NetworkInfo() => _instance;
//   NetworkInfo._internal();
//
//   final Connectivity _connectivity = Connectivity();
//   final InternetConnectionChecker _connectionChecker = InternetConnectionChecker();
//
//   Future<bool> hasNetworkConnection() async {
//     try {
//       final connectivityResult = await _connectivity.checkConnectivity();
//       return connectivityResult != ConnectivityResult.none;
//     } catch (e) {
//       return false;
//     }
//   }
//
//   Future<bool> hasInternetAccess() async {
//     try {
//       final hasNetwork = await hasNetworkConnection();
//       if (!hasNetwork) return false;
//
//       return await _connectionChecker.hasConnection
//           .timeout(const Duration(seconds: 3), onTimeout: () => false);
//     } catch (e) {
//       return false;
//     }
//   }
//
//   static Future<bool> checkInternet() async {
//     return await NetworkInfo().hasInternetAccess();
//   }
// }