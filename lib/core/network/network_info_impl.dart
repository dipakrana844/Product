import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'network_info.dart';

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;
  final InternetConnection _internetConnection;

  NetworkInfoImpl(this._connectivity, this._internetConnection);

  @override
  Stream<bool> get connectionStream {
    // Combine connectivity changes with internet status for maximum robustness
    return _internetConnection.onStatusChange
        .map((status) => status == InternetStatus.connected)
        .distinct()
        .asBroadcastStream();
  }

  @override
  Future<bool> get isConnected async {
    // First check basic connectivity
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    }

    // Then check for actual internet access
    return await _internetConnection.hasInternetAccess;
  }
}
