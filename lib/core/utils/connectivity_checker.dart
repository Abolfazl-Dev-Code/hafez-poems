import 'dart:io';

class ConnectivityChecker {
  ConnectivityChecker._();

  static Future<bool> hasInternet() async {
    const probes = ['1.1.1.1', '8.8.8.8'];
    for (final ip in probes) {
      Socket? socket;
      try {
        socket = await Socket.connect(
          ip,
          443,
          timeout: const Duration(seconds: 3),
        );
        return true;
      } catch (_) {
        continue;
      } finally {
        socket?.destroy();
      }
    }
    return false;
  }
}
