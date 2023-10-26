import 'package:cisco_szabadulas/helpers/globals.dart' as globals;

String stage_five_html(int subStage) {
  return '''
<h1>Cisco Szabadulás - ${globals.teamNumber}. ${globals.teamName} csapat, ${globals.pcNumber}. gép</h1>
<p>Jelenleg a végső fázisnál tartotok, gyönyörűséges munka ✨</p>
<!-- Ellenőrző kód: 25751a43-e361-433c-a26c-44aa1efbbc18-0x${globals.teamNumber}${globals.pcNumber}-$subStage -->
''';
}
