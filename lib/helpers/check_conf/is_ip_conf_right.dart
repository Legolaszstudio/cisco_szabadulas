import 'dart:convert';
import 'dart:io';

class NetShResult {
  final String ip;
  final String mask;
  final String gateway;

  NetShResult({
    required this.ip,
    required this.mask,
    required this.gateway,
  });
}

Future<NetShResult> netShForInt(String interf) async {
  Process process = await Process.start(
    'netsh interface ip show addresses "Ethernet"',
    [],
  );
  await Future.delayed(Duration(seconds: 1));
  String output = await process.stdout.transform(latin1.decoder).join();
  return NetShResult(
    ip: output
        .toLowerCase()
        .split('ip address:')[1]
        .split('\n')[0]
        .replaceAll(' ', ''),
    mask: output
        .toLowerCase()
        .split('mask ')[1]
        .split(')')[0]
        .replaceAll(' ', ''),
    gateway: output
        .toLowerCase()
        .split('gateway:')[1]
        .split('\n')[0]
        .replaceAll(' ', ''),
  );
}

Future<bool> isIpConfRight(
  String ipToConf, {
  String maskToConf = '255.255.255.0',
}) async {
  for (NetworkInterface interf in await NetworkInterface.list()) {
    if (interf.name.toLowerCase().contains('ethernet')) {
      for (InternetAddress addr in interf.addresses) {
        if (addr.address.toLowerCase().contains(ipToConf)) {
          NetShResult doubleCheck = await netShForInt(interf.name);
          if (doubleCheck.ip.toLowerCase().contains(ipToConf) &&
              doubleCheck.mask.toLowerCase().contains(maskToConf)) {
            return true;
          }
        }
      }
    }
  }
  return false;
}
