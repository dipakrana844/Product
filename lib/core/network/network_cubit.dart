import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'network_info.dart';

part 'network_state.dart';

class NetworkCubit extends Cubit<NetworkState> {
  final NetworkInfo _networkInfo;

  NetworkCubit(this._networkInfo) : super(NetworkInitial()) {
    _listenToConnectivityChanges();
  }

  void _listenToConnectivityChanges() {
    _networkInfo.connectionStream.listen((isConnected) {
      if (isConnected) {
        emit(NetworkConnected());
      } else {
        emit(NetworkDisconnected());
      }
    });
  }

  Future<void> checkConnection() async {
    final isConnected = await _networkInfo.isConnected;
    if (isConnected) {
      emit(NetworkConnected());
    } else {
      emit(NetworkDisconnected());
    }
  }
}