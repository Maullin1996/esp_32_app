import 'dart:io';

class NetworkScanner {
  Future<List<String>> scanSubnet(String baseIp) async {
    final List<String> results = [];

    for (int i = 1; i <= 254; i++) {
      final host = "$baseIp.$i";

      try {
        final socket = await Socket.connect(
          host,
          80,
          timeout: Duration(milliseconds: 200),
        );
        socket.destroy();
        results.add(host);
      } catch (_) {
        // no responde → ignorar
      }
    }

    return results;
  }
}
