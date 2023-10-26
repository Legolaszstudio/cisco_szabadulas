import 'dart:convert';
import 'dart:io';
import 'package:cisco_szabadulas/helpers/globals.dart' as globals;
import 'package:cisco_szabadulas/ui/html/stage_five_html.dart';

Future<void> startStageFiveThreeWebSrv(
  Function endCallback,
) async {
  globals.server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
  globals.server!.listen((event) {
    if (event.requestedUri.path == '/time/CiscoVegsoCsapas') {
      if (globals.stageFiveEnd == 0) {
        globals.stageFiveEnd = DateTime.now().millisecondsSinceEpoch;
        globals.prefs.setInt('stageFiveEnd', globals.stageTwoEnd);
        print('Timing ended for stage 5: ${globals.stageFiveEnd}');
      }

      event.response.headers.contentType = new ContentType(
        'application',
        'json',
        charset: 'utf-8',
      );
      event.response.write(jsonEncode({
        'teamName': globals.teamName,
        'teamNumber': globals.teamNumber,
        'pcNumber': globals.pcNumber,
        'stageOneStart': globals.stageOneStart,
        'stageOneEnd': globals.stageOneEnd,
        'stageTwoStart': globals.stageTwoStart,
        'stageTwoEnd': globals.stageTwoEnd,
        'stageThreeStart': globals.stageThreeStart,
        'stageThreeEnd': globals.stageThreeEnd,
        'stageFourStart': globals.stageFourStart,
        'stageFourEnd': globals.stageFourEnd,
        'stageFiveStart': globals.stageFiveStart,
        'stageFiveSectionOneEnd': globals.stageFiveSectionOneEnd,
        'stageFiveEnd': globals.stageFiveEnd,
      }));

      Future.delayed(Duration(seconds: 1)).then((value) async {
        endCallback();
      });
    } else {
      event.response.headers.contentType = new ContentType(
        'text',
        'html',
        charset: 'utf-8',
      );
      event.response.write(stage_five_html(3));
    }
    event.response.close();
  });
}
