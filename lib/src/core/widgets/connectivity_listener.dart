import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';

import 'package:flutter_template/src/core/enums/connectivity_status.dart';
import 'package:flutter_template/src/core/providers/connectivity_state_provider.dart';

class ConnectivityListener extends ConsumerStatefulWidget {
  final Widget child;

  const ConnectivityListener({super.key, required this.child});

  @override
  ConsumerState<ConnectivityListener> createState() {
    return _ConnectivityListenerState();
  }
}

class _ConnectivityListenerState extends ConsumerState<ConnectivityListener> {
  ToastificationItem? _offlineToast;

  bool _isFirstEvent = true;

  @override
  Widget build(BuildContext context) {
    ref.listen(connectivityStateProvider, (previous, next) {
      /// Ignore initial connected state
      if (_isFirstEvent) {
        _isFirstEvent = false;

        if (next == ConnectivityStatus.connected) {
          return;
        }
      }

      switch (next) {
        case ConnectivityStatus.disconnected:
          _showOfflineToast();
          break;

        case ConnectivityStatus.connected:
          _showOnlineToast();
          break;
      }
    });

    return widget.child;
  }

  void _showOfflineToast() {
    if (_offlineToast != null) return;

    _offlineToast = toastification.show(
      autoCloseDuration: null,
      alignment: Alignment.bottomCenter,
      showProgressBar: false,
      closeButtonShowType: CloseButtonShowType.none,
      dragToClose: false,
      margin: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(12),
      backgroundColor: Colors.red.shade600,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      title: const Text(
        "No internet connection",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  void _showOnlineToast() {
    if (_offlineToast != null) {
      toastification.dismiss(_offlineToast!);
      _offlineToast = null;
    }

    toastification.show(
      autoCloseDuration: const Duration(seconds: 2),
      alignment: Alignment.bottomCenter,
      showProgressBar: false,
      closeButtonShowType: CloseButtonShowType.none,
      dragToClose: false,
      margin: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(12),
      backgroundColor: Colors.green.shade600,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      title: const Text(
        "Back online",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
