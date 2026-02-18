import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'network_cubit.dart';
import 'network_info.dart';

class NetworkUtils {
  static Future<bool> isConnected(BuildContext context) async {
    final networkInfo = context.read<NetworkInfo>();
    return await networkInfo.isConnected;
  }

  static Stream<bool> listenToNetworkChanges(BuildContext context) {
    final networkInfo = context.read<NetworkInfo>();
    return networkInfo.connectionStream;
  }

  static bool isCurrentlyConnected(BuildContext context) {
    try {
      final state = context.watch<NetworkCubit>().state;
      return state is NetworkConnected;
    } catch (e) {
      return false;
    }
  }

  static Future<void> checkConnection(BuildContext context) async {
    final networkCubit = context.read<NetworkCubit>();
    await networkCubit.checkConnection();
  }
}
