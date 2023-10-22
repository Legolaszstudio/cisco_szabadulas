import 'package:cisco_szabadulas/helpers/globals.dart' as globals;

String stage_four_html() {
  if (globals.pcNumber == 1) {
    String otherPcIp = '10.10.10.100';
    return '''
<h1>Cisco Szabadulás - ${globals.teamNumber}. ${globals.teamName} csapat, ${globals.pcNumber}. gép</h1>
<p>Jelenleg a negyedik fázisnál tartotok, tökéletes munka 👌</p>
<p>Ha minden jól megy, akkor a másik számítógépet is el kell érnetek: <a href="http://$otherPcIp:8080"> $otherPcIp </a></p>
<!-- Ellenőrző kód: af883afc-0776-464b-9717-fcfa42681539-0x${globals.teamNumber}${globals.pcNumber} -->
''';
  }

  return '''
<h1>Cisco Szabadulás - ${globals.teamNumber}. ${globals.teamName} csapat, Hertelendi gép szimulációja</h1>
<p>Ki tudja, hogy itt miket fogunk látni? Mi csak szimuláljuk a kapcsolatot...</p>
<!-- Ellenőrző kód: af883afc-0776-464b-9717-fcfa42681539-0x${globals.teamNumber}${globals.pcNumber} -->
''';
}
