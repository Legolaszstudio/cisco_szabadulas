import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cisco_szabadulas/helpers/globals.dart' as globals;
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
  print('Lock system web server started. On port 1234.');

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
      while (!result.startsWith('OK') && i <= 5) {
        result = await getTiming(event.connectionInfo!.remoteAddress.address);
        print('Timing result: $result');
        await Future.delayed(Duration(seconds: 2));
        i++;
      }
      if (result.startsWith('OK')) {
        result = result.split('OK ').sublist(1).join('');
        Map<String, dynamic> timing = jsonDecode(result);
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
        event.response.write('<p>Rendszer leállás elindítva!</p>');
      } else {
        event.response.write(
          '<p>Rendszer leállás elindítása sikertelen!<br>$result</p>',
        );
      }
    } else {
      event.response.write('<a href="/shutdown">Leállás</a>');
    }
    event.response.close();
  });
}
