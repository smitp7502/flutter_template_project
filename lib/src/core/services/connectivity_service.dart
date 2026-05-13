import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'package:flutter_template/src/core/enums/connectivity_status.dart';

class ConnectivityService {
  ConnectivityService._();

  static final InternetConnection _checker = InternetConnection();

  /// Current status
  static Future<ConnectivityStatus> checkConnection() async {
    final isConnected = await _checker.hasInternetAccess;

    return isConnected
        ? ConnectivityStatus.connected
        : ConnectivityStatus.disconnected;
  }

  /// Connection stream
  static Stream<ConnectivityStatus> connectionStream() {
    return _checker.onStatusChange.distinct().map((status) {
      switch (status) {
        case InternetStatus.connected:
          return ConnectivityStatus.connected;

        case InternetStatus.disconnected:
          return ConnectivityStatus.disconnected;
      }
    });
  }
}
