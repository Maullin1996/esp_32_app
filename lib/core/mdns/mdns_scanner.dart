import 'dart:async';
import 'package:multicast_dns/multicast_dns.dart';

class MdnsScanner {
  final MDnsClient _client = MDnsClient();

  Future<List<MdnsDiscoveredDevice>> discoverEsp32() async {
    final List<MdnsDiscoveredDevice> results = [];

    try {
      await _client.start();

      await for (final PtrResourceRecord ptr
          in _client.lookup<PtrResourceRecord>(
            ResourceRecordQuery.serverPointer('_http._tcp.local'),
          )) {
        final domain = ptr.domainName;

        await for (final SrvResourceRecord srv
            in _client.lookup<SrvResourceRecord>(
              ResourceRecordQuery.service(domain),
            )) {
          final host = srv.target;
          int port = srv.port;

          await for (final IPAddressResourceRecord ip
              in _client.lookup<IPAddressResourceRecord>(
                ResourceRecordQuery.addressIPv4(host),
              )) {
            results.add(
              MdnsDiscoveredDevice(
                hostname: host,
                ip: ip.address.address,
                port: port,
              ),
            );
          }
        }
      }
    } catch (e) {
      print("mDNS error: $e");
    }

    _client.stop();
    return results;
  }
}

class MdnsDiscoveredDevice {
  final String hostname;
  final String ip;
  final int port;

  MdnsDiscoveredDevice({
    required this.hostname,
    required this.ip,
    required this.port,
  });
}
