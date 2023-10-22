import 'package:cisco_szabadulas/helpers/globals.dart' as globals;

String stage_two_html() {
  String otherPcIp = '192.168.${globals.teamNumber}.';
  if (globals.pcNumber == 1) {
    otherPcIp += '2';
  } else {
    otherPcIp += '1';
  }

  return '''
<h1>Cisco Szabadulás - ${globals.teamNumber}. ${globals.teamName} csapat, ${globals.pcNumber}. gép</h1>
<p>Jelenleg a második fázisnál tartotok, szép munka 👍</p>
<p>Ha minden jól megy, akkor a másik számítógépet is el kell érnetek: <a href="http://$otherPcIp:8080"> $otherPcIp </a></p>
<!-- Ellenőrő kód: 794f2326-c30f-47a6-9cb6-6db45efbb6df-0x${globals.teamNumber}${globals.pcNumber} -->
''';
}
