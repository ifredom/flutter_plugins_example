import '../stoppable_service.dart';

enum ConnectivityStatus { Cellular, WiFi, Offline }

abstract class ConnectivityService implements StoppableService {
  Stream<ConnectivityStatus> get connectivity$;

  Future<bool> get isConnected;
}
