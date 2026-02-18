part of 'network_cubit.dart';

abstract class NetworkState extends Equatable {}

class NetworkInitial extends NetworkState {
  @override
  List<Object> get props => [];
}

class NetworkConnected extends NetworkState {
  @override
  List<Object> get props => [];
}

class NetworkDisconnected extends NetworkState {
  @override
  List<Object> get props => [];
}