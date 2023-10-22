import 'package:cisco_szabadulas/helpers/globals.dart' as globals;

String stage_three_html() {
  String otherPcLinks = '';
  for (int i = 1; i <= (globals.numberOfTeams ?? 7); i++) {
    otherPcLinks +=
        '<a href="http://192.168.$i.1:8080"> $i csapat 1.-es gép</a><br>\n<a href="http://192.168.$i.2:8080"> $i csapat 2.-es gép</a><br><br>\n';
  }

  return '''
<h1>Cisco Szabadulás - ${globals.teamNumber}. ${globals.teamName} csapat, ${globals.pcNumber}. gép</h1>
<p>Jelenleg a harmadik fázisnál tartotok, csodás munka 🎉</p>
<p>Ha minden jól megy, akkor a többi csapat gépét is el kell érnetek;</p>
<p>
$otherPcLinks
</p>
<!-- Ellenőrző kód: d94164e7-1613-4770-8872-cf4a34e33abb-0x${globals.teamNumber}${globals.pcNumber} -->
''';
}
