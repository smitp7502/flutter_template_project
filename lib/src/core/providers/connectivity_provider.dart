import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_template/src/core/enums/connectivity_status.dart';
import 'package:flutter_template/src/core/services/connectivity_service.dart';

final connectivityProvider = StreamProvider<ConnectivityStatus>((ref) {
  return ConnectivityService.connectionStream();
});
