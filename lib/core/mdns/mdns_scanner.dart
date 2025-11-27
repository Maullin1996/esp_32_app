import 'dart:async';
import 'package:multicast_dns/multicast_dns.dart';

class MdnsScanner {
  final MDnsClient _client = MDnsClient();

  Future<List<MdnsDiscoveredDevice>> discoverEsp32() async {
    final List<MdnsDiscoveredDevice> results = [];

    await _client.start();

    // Paso 1: buscar servicios HTTP
    await for (final PtrResourceRecord ptr in _client.lookup<PtrResourceRecord>(
      ResourceRecordQuery.serverPointer('_http._tcp.local'),
    )) {
      final domain = ptr.domainName;

      // Paso 2: buscar metadata del servicio
      await for (final SrvResourceRecord srv
          in _client.lookup<SrvResourceRecord>(
            ResourceRecordQuery.service(domain),
          )) {
        final host = srv.target;

        // Paso 3: obtener la IP del host
        await for (final IPAddressResourceRecord ip
            in _client.lookup<IPAddressResourceRecord>(
              ResourceRecordQuery.addressIPv4(host),
            )) {
          results.add(
            MdnsDiscoveredDevice(hostname: host, ip: ip.address.address),
          );
        }
      }
    }

    _client.stop();

    return results;
  }
}

// Modelo para dispositivos encontrados
class MdnsDiscoveredDevice {
  final String hostname;
  final String ip;

  MdnsDiscoveredDevice({required this.hostname, required this.ip});
}
