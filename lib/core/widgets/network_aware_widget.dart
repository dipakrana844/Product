import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../network/network_cubit.dart';

class NetworkAwareWidget extends StatefulWidget {
  final Widget child;
  final Widget? offlineIndicator;
  final bool showOfflineIndicator;
  final VoidCallback? onNetworkRestored;
  final VoidCallback? onNetworkLost;

  const NetworkAwareWidget({
    super.key,
    required this.child,
    this.offlineIndicator,
    this.showOfflineIndicator = true,
    this.onNetworkRestored,
    this.onNetworkLost,
  });

  @override
  State<NetworkAwareWidget> createState() => _NetworkAwareWidgetState();
}

class _NetworkAwareWidgetState extends State<NetworkAwareWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NetworkCubit, NetworkState>(
      listener: (context, state) {
        if (state is NetworkConnected && widget.onNetworkRestored != null) {
          widget.onNetworkRestored!();
        } else if (state is NetworkDisconnected &&
            widget.onNetworkLost != null) {
          widget.onNetworkLost!();
        }
      },
      builder: (context, state) {
        bool isOnline = state is NetworkConnected;

        return Stack(
          children: [
            widget.child,
            if (!isOnline && widget.showOfflineIndicator)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Material(
                    type: MaterialType.transparency,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      color: Colors.orange.withOpacity(0.9),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.signal_wifi_off,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'No internet connection',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
