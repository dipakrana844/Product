abstract class NetworkInfo {
  Stream<bool> get connectionStream;
  Future<bool> get isConnected;
}