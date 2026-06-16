import 'package:connectivity_plus/connectivity_plus.dart';

/// Network information interface
abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<ConnectivityResult> get connectivityStream;
}

/// Network information implementation
class NetworkInfoImpl implements NetworkInfo {

  NetworkInfoImpl(this.connectivity);
  final Connectivity connectivity;

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  @override
  Stream<ConnectivityResult> get connectivityStream =>
      connectivity.onConnectivityChanged;
}
