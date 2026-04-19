import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkCheckingService {
  NetworkCheckingService._();

  static Future<bool> checkInternet() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }

      return true;
    } catch (err) {
      return false;
    }
  }
}
