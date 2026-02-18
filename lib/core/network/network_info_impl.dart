import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'network_info.dart';

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfoImpl(this._connectivity);

  Stream<bool>? _connectionStream;
  
  @override
  Stream<bool> get connectionStream {
    return _connectionStream ??= _connectivity.onConnectivityChanged
        .asyncMap((List<ConnectivityResult> result) async {
          if (result.isEmpty || result.contains(ConnectivityResult.none)) {
            return false;
          }
          // Check if we have actual internet access
          return await _checkInternetConnection(result);
        })
        .distinct()
        .asBroadcastStream();
  }

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    if (result.contains(ConnectivityResult.none)) {
      return false;
    }
    return await _checkInternetConnection(result);
  }

  Future<bool> _checkInternetConnection(List<ConnectivityResult> result) async {
    // First check if there's a network connection at all
    if (result.contains(ConnectivityResult.none)) {
      return false;
    }

    // Then verify internet access by pinging a reliable host
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}