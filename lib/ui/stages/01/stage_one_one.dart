//Indulhat a levélkeresés
import 'dart:async';
import 'package:cisco_szabadulas/helpers/globals.dart' as globals;
import 'package:cisco_szabadulas/helpers/debug_menu/debug_menu.dart';
import 'package:cisco_szabadulas/helpers/ms_to_human_str.dart';
import 'package:cisco_szabadulas/helpers/simple_alert.dart';
import 'package:cisco_szabadulas/ui/stages/01/stage_one_two.dart';
import 'package:flutter/material.dart';

class StageOneOne extends StatefulWidget {
  const StageOneOne({super.key});

  @override
  State<StageOneOne> createState() => _StageOneOneState();
}

class _StageOneOneState extends State<StageOneOne> {
  late Timer _timer;
  String _timeLeftStr = '${globals.timeForStageOne}:00';

  void updateTime() {
    setState(() {
      int endTime = globals.stageOneStart + (globals.timeForStageOne * 60000);
      int timeLeft = endTime - DateTime.now().millisecondsSinceEpoch;

      _timeLeftStr = msToHumanStr(timeLeft);

      if (timeLeft <= 0) {
        _timeLeftStr = '00:00';
        _timer.cancel();
        globals.stageOneEnd = DateTime.now().millisecondsSinceEpoch;
        globals.prefs.setInt('stageOneEnd', globals.stageOneEnd);
        globals.currentStage = 1.2;
        globals.prefs.setDouble('currentStage', 1.2);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => StageOneTwo()),
        );
        Future.delayed(Duration(seconds: 2)).then((value) {
          showSimpleAlert(
              context: globals.navigatorKey.currentContext!,
              title: 'Lejárt az idő! ⏰',
              content: '''
Nektek itt vége a versenynek, kérlek hagyjátok el a konyhát.

Csak vicceltem 🤣
Semmi gond; ha idáig eljutottatok, az már elég bizonyíték arra, hogy ti vagytok a legjobbak a feladatra! 😎

Egy valamit jól vésetek eszetekbe: X.C.C.C
''');
        });
      }
    });
  }

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      updateTime();
    });
    super.initState();
  }

  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text(
            'Cisco Szabadulás 1.1 - Első stádium',
          ),
          onDoubleTap: () {
            showDebugMenu();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Idő: $_timeLeftStr'),
          ),
        ],
      ),
      body: Placeholder(),
    );
  }
}
