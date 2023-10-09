import 'dart:io';

Future<bool> isIpConfRight(String ipToConf) async {
  for (NetworkInterface interface in await NetworkInterface.list()) {
    if (interface.name.toLowerCase().contains('ethernet')) {
      for (var addr in interface.addresses) {
        if (addr.address.toLowerCase().contains(ipToConf)) {
          return true;
        }
      }
    }
  }
  return false;
}
