import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cisco_szabadulas/helpers/globals.dart' as globals;
import 'package:cisco_szabadulas/ui/html/door_system_html.dart';
import 'package:cisco_szabadulas/ui/html/hertelendi_con_html.dart';
import '../helpers/check_conf/http_client.dart' as httpClient;
import './lock_system_screen.dart' as lockSystemScreen;

Future<String> getTiming(String teamIp) async {
  String result = '';
  try {
    HttpClientRequest request = await httpClient.client
        .get(
          teamIp,
          8080,
          '/time/CiscoVegsoCsapas',
        )
        .timeout(
          const Duration(
            seconds: 2,
          ),
        );
    request.headers.add('Authorization', 'CiscoVegsoCsapas');
    HttpClientResponse response = await request.close().timeout(
          const Duration(
            seconds: 2,
          ),
        );
    result = 'OK ' + await response.transform(utf8.decoder).join();
  } on TimeoutException catch (_) {
    result = 'TimeoutException';
  } catch (e) {
    result = 'Exception $e';
  }
  return result;
}

Future<void> startLockSystemWebSrv(Function setStateCallback) async {
  if (globals.httpServerVer != 0) {
    await globals.server?.close();
  }
  globals.server = await HttpServer.bind(InternetAddress.anyIPv4, 1234);
  globals.httpServerVer = -1;
  print('Lock system web server started on port 1234.');

  HttpServer connectivityCheckServer = await HttpServer.bind(
    InternetAddress.anyIPv4,
    8080,
  );
  connectivityCheckServer.listen((event) {
    event.response.headers.contentType = new ContentType(
      'text',
      'html',
      charset: 'utf-8',
    );
    event.response.write(hertelendiConHtml);
    event.response.close();
  });
  print('Connectivity check server started on port 8080.');

  globals.server!.listen((event) async {
    event.response.headers.contentType = new ContentType(
      'text',
      'html',
      charset: 'utf-8',
    );
    print('Remote computer: ${event.connectionInfo!.remoteAddress.address}');

    if (event.requestedUri.path == '/shutdown') {
      String result = '';
      int i = 0;
      late Map<String, dynamic> timing;
      while (!result.startsWith('OK') && i <= 5) {
        try {
          result = await getTiming(event.connectionInfo!.remoteAddress.address);
          result = result.split('OK ').sublist(1).join('');
          timing = jsonDecode(result);
        } catch (e) {
          result = 'Exception $e';
        }
        print('Timing result: $result');
        await Future.delayed(Duration(seconds: 2));
        i++;
      }

      if (result.startsWith('OK')) {
        timing['stageOneTime'] =
            timing['stageOneEnd'] - timing['stageOneStart'];
        timing['stageTwoTime'] =
            timing['stageTwoEnd'] - timing['stageTwoStart'];
        timing['stageThreeTime'] =
            timing['stageThreeEnd'] - timing['stageThreeStart'];
        timing['stageFourTime'] =
            timing['stageFourEnd'] - timing['stageFourStart'];
        timing['stageFiveTime'] =
            timing['stageFiveEnd'] - timing['stageFiveStart'];
        timing['stageFiveSectionOneTime'] =
            timing['stageFiveSectionOneEnd'] - timing['stageFiveStart'];

        globals.timingData['${timing['teamNumber']}.${timing['pcNumber']}'] =
            timing;
        print(timing);
        globals.prefs.setString(
          'timingData',
          jsonEncode(globals.timingData),
        );
        lockSystemScreen.connectionStatus[timing['teamNumber'] - 1] = 1;
        setStateCallback();
        event.response.write(
          '<p style="text-align:center;margin-top:200px">Rendszer elkezdett leállni!</p>',
        );
      } else {
        event.response.write(
          '<p style="text-align:center;margin-top:200px">Rendszer leállás elindítása sikertelen volt!<br>Próbáld meg újratölteni az oldalt!<br><br>$result</p>',
        );
      }
    } else {
      event.response.write(doorSysHtml);
    }
    event.response.close();
  });
}
