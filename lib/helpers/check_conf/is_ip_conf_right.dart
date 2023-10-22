import 'dart:convert';
import 'dart:io';
import 'package:cisco_szabadulas/helpers/globals.dart' as globals;
import 'package:cisco_szabadulas/helpers/simple_alert.dart';
import 'package:flutter/material.dart';

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

Future<String> getMask(String interf) async {
  Process process = await Process.start(
    'C:\\Windows\\system32\\netsh.exe',
    ['interface', 'ip', 'dump'],
  );
  await Future.delayed(Duration(seconds: 1));
  String output = await process.stdout.transform(latin1.decoder).join();
  return utf8.decode(
    utf8.encode(output
        .split('add address name="$interf"')[1]
        .split('mask=')[1]
        .split('\n')[0]),
  );
}

Future<String> getGateway(String interf) async {
  Process process = await Process.start(
    'C:\\Windows\\system32\\netsh.exe',
    ['interface', 'ip', 'dump'],
  );
  await Future.delayed(Duration(seconds: 1));
  String output = await process.stdout.transform(latin1.decoder).join();
  if (output.split('add route prefix=0.0.0.0/0 interface=\"$interf\"').length >
      2) {
    return 'MultipleGw';
  }
  if (output.split('add route prefix=0.0.0.0/0 interface=\"$interf\"').length <
      2) {
    return 'NoGw';
  }
  return utf8
      .decode(
        utf8.encode(output
            .split('add route prefix=0.0.0.0/0 interface="$interf"')[1]
            .split('nexthop=')[1]
            .split(' ')[0]),
      )
      .split('.')
      .map((e) => int.parse(e))
      .join('.');
}

Future<String> isIpConfRight(
  String ipToConf, {
  String maskToConf = '255.255.255.0',
  String? gatewayToConf,
}) async {
  if (globals.override_ip_check) {
    if (!globals.override_ip_check_permanent) {
      globals.override_ip_check = false;
    }
    return 'OK';
  }

  List<NetworkInterface> interfaces = await NetworkInterface.list();
  // Filter out ethernet interfaces
  interfaces = interfaces
      .where(
        (element) => element.name.startsWith(globals.networkInterface),
      )
      .toList();
  if (interfaces.isEmpty) {
    return 'NoInterface';
  } else if (interfaces.length > 1) {
    return 'TooManyInterfaces ${interfaces.map((e) => e.name).join(', ')})}';
  }

  // Check ipv4 address configuration
  List<InternetAddress> addresses = interfaces[0].addresses;
  if (addresses.isEmpty) {
    return 'NoAddress';
  } else if (addresses.length > 1) {
    return 'TooManyAddresses';
  } else if (addresses[0].address != ipToConf) {
    return 'WrongAddress ${addresses[0].address}';
  }

  // Check subnet mask configuration
  String maskResult = (await getMask(interfaces[0].name))
      .split('.')
      .map((e) => int.parse(e))
      .join('.');

  if (maskToConf != maskResult) {
    return 'WrongMask ${maskResult}';
  }

  if (gatewayToConf != null) {
    String gatewayResult = await getGateway(interfaces[0].name);

    if (gatewayToConf != gatewayResult) {
      return 'WrongGateway ${gatewayResult}';
    }
  }

  return 'OK';
}

/** Returns `true` if configuration is right, will also show alert boxes accordingly */
Future<bool> runIpCheck(
  BuildContext context, {
  required String ipToCheck,
  String maskToCheck = '255.255.255.0',
  String? gatewayToCheck,
}) async {
  // Check one
  String result = 'Err';
  try {
    result = await isIpConfRight(
      ipToCheck,
      maskToConf: maskToCheck,
      gatewayToConf: gatewayToCheck,
    );
  } catch (e) {
    result = 'Exception ${e}';
  }
  print('runIpCheck Result: ' + result.toString());

  if (result == 'NoInterface' || result.startsWith('TooManyInterfaces')) {
    showSimpleAlert(
      context: context,
      title: 'Hiba - Az Interfész kereső hibába futott',
      content: 'Játék konfigurációs hiba, szólj a játékvezetőnek! ($result)',
    );
    return false;
  }

  if (result == 'NoAddress') {
    showSimpleAlert(
      context: context,
      title: 'Hiba - Nincsen cím konfigurálva',
      content:
          'Nem látom, hogy bármilyen címe lenne a gépnek...\nBiztosan be lett állítva?\nJó interfészt állítottak be? (${globals.networkInterface})\n\nHa dupla ellenőrzés után is fennáll a hiba, akkor nyugodtan kérj segítséget!',
    );
    return false;
  }

  if (result == 'TooManyAddresses') {
    showSimpleAlert(
      context: context,
      title: 'Hiba - Túl sok cím van konfigurálva',
      content:
          'Igazi furcsaságokra vagy képes!\nIgen, egy gépnek több címe is lehet a hálózaton belül, de most ilyenre nincsen szükségünk, kérlek csak 1 címet állíts be!\n\nHa dupla ellenőrzés után is fennáll a hiba, akkor nyugodtan kérj segítséget!',
    );
    return false;
  }

  if (result.startsWith('WrongAddress')) {
    showSimpleAlert(
      context: context,
      title: 'Hiba - Nem jó címet konfiguráltál',
      content:
          'Semmi gond, nagy valószínúséggel csak elgépeltél valamit;\n\nA cím amit beállítottál: ${result.split(" ")[1]}\nA cím amit be kellett volna állítani: $ipToCheck\n\nHa dupla ellenőrzés után is fennáll a hiba, akkor nyugodtan kérj segítséget!',
    );
    return false;
  }

  if (result.startsWith('WrongMask')) {
    showSimpleAlert(
      context: context,
      title: 'Hiba - Nem jó maszkot/subnetet konfiguráltál',
      content:
          'Semmi gond, nagy valószínúséggel csak elgépeltél valamit;\n\nA mask amit beállítottál: ${result.split(' ')[1]}\nA mask amit be kellett volna állítani: $maskToCheck\n\nHa dupla ellenőrzés után is fennáll a hiba, akkor nyugodtan kérj segítséget!',
    );
    return false;
  }

  if (result.startsWith('WrongGateway MultipleGw')) {
    showSimpleAlert(
      context: context,
      title: 'Hiba - Több átjáró van konfigurálva',
      content:
          'Lehet közötte van a jó átjáró is, de légyszi csak a jót állítsd be, köszi 🥺\n\nHa dupla ellenőrzés után is fennáll a hiba, akkor nyugodtan kérj segítséget!',
    );
    return false;
  }

  if (result.startsWith('WrongGateway NoGw')) {
    showSimpleAlert(
      context: context,
      title: 'Hiba - Nincs átjáró konfigurálva',
      content:
          'Nem látom, hogy lenne alapértelmezett átjáró, így nem tudok a többi hálózattal beszélgetni.\nLégyszi állítsd be 🥺\n\nHa dupla ellenőrzés után is fennáll a hiba, akkor nyugodtan kérj segítséget!',
    );
    return false;
  }

  if (result.startsWith('WrongGateway')) {
    showSimpleAlert(
      context: context,
      title: 'Hiba - Nem jó átjárót konfiguráltál',
      content:
          'Semmi gond, nagy valószínúséggel csak elgépeltél valamit;\n\nAz átjáró amit beállítottál: ${result.split(' ')[1]}\nAz átjáró amit be kellett volna állítani: $gatewayToCheck\n\nHa dupla ellenőrzés után is fennáll a hiba, akkor nyugodtan kérj segítséget!',
    );
    return false;
  }

  if (result.startsWith('Exception')) {
    showSimpleAlert(
      context: context,
      title: 'Hiba - Hatalmas futásidejű hiba történt',
      content:
          'Semmi gond, adj még egy próbát a dolognak, ha továbbra sem megy szólj a játékvezetőnek!\n\nRészletek\n\n${result}',
    );
    return false;
  }

  if (result != 'OK') {
    showSimpleAlert(
      context: context,
      title: 'Hiba - Ez most meglepő, de nem tudom mi történt... 😅',
      content:
          'A "$result" eredményt nem ismerem...\nLégyszi szólj a játékvezetőnek!🥺',
    );
    return false;
  }

  return true;
}
