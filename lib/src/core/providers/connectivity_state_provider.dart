import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_template/src/core/enums/connectivity_status.dart';
import 'package:flutter_template/src/core/services/connectivity_service.dart';

final connectivityStateProvider =
    NotifierProvider<ConnectivityNotifier, ConnectivityStatus>(
      ConnectivityNotifier.new,
    );

class ConnectivityNotifier extends Notifier<ConnectivityStatus> {
  StreamSubscription? _subscription;

  Timer? _debounce;

  @override
  ConnectivityStatus build() {
    _initialize();

    ref.onDispose(() {
      _subscription?.cancel();
      _debounce?.cancel();
    });

    return ConnectivityStatus.connected;
  }

  Future<void> _initialize() async {
    state = await ConnectivityService.checkConnection();

    _subscription = ConnectivityService.connectionStream().distinct().listen((
      status,
    ) {
      _debounce?.cancel();

      _debounce = Timer(const Duration(milliseconds: 500), () {
        if (state != status) {
          state = status;
        }
      });
    });
  }

  bool get isConnected => state == ConnectivityStatus.connected;
}
