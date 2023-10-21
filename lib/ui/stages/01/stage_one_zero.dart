// Felvezetés, bemutatkozás, etc
import 'dart:async';
import 'package:cisco_szabadulas/helpers/debug_menu/debug_menu.dart';
import 'package:cisco_szabadulas/helpers/file_deployment/file_deployer.dart';
import 'package:cisco_szabadulas/helpers/ms_to_human_str.dart';
import 'package:cisco_szabadulas/helpers/simple_alert.dart';
import 'package:cisco_szabadulas/ui/stages/01/stage_one_one.dart';
import 'package:cisco_szabadulas/ui/stages/01/stage_one_two.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:window_size/window_size.dart';
import 'package:cisco_szabadulas/helpers/globals.dart' as globals;

class StageOne extends StatefulWidget {
  const StageOne({super.key});

  @override
  State<StageOne> createState() => _StageOneState();
}

class _StageOneState extends State<StageOne> {
  late Timer _timer;
  String _timeLeftStr = '${globals.timeForStageOne}:00';

  @override
  void initState() {
    setWindowTitle('Cisco Szabadulás - Első stádium');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.loaderOverlay.show();
      await fileDeployer();
      if (globals.stageOneStart == 0) {
        globals.stageOneStart = DateTime.now().millisecondsSinceEpoch;
        globals.prefs.setInt('stageOneStart', globals.stageOneStart);
        print('Timing started for stage 1: ${globals.stageOneStart}');
      }
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        updateTime();
      });
      context.loaderOverlay.hide();
    });
    super.initState();
  }

  void dispose() {
    _timer.cancel();
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text('Cisco Szabadulás 1.0 - Első stádium'),
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
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 100, right: 100, top: 10),
              child: Text(
                '''
A 2030-as években járunk, ahol a technológia mára már szinte mindenhol ott van. De vajon ez mindig a mi érdekeinket szolgálja? Néha jobb, ha nem mindent egy számítógép vezérel. A Petrikben most ezt valaki kihasználta…\n
Az órák ma nem a megszokott módon zajlottak az iskolában. A szokásos csengő helyett a riasztó szólalt meg óra végén. Minden termet lezártak, az ajtók nem működnek, a kapcsolatot megszüntették, nem érjük el a külvilágot és egymást sem.\n
A Petriket teljes tudatlanság borítja. Akármilyen kilátástalannak látszik a helyzet mégis van remény. Hertelendi Gábor, az iskola rendszergazdája. Viszont senki se tudja, hogy hol tartózkodik jelenleg. Az utolsó jel, amit hagyott az egy program, ami az A122-es teremben található gépeken fut. Itt talán eltudunk indulni valamerre.\n''',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.start,
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.5,
              child: TextButton.icon(
                onPressed: () {
                  globals.currentStage = 1.1;
                  globals.prefs.setDouble('currentStage', 1.1);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => StageOneOne(),
                    ),
                  );
                },
                icon: Icon(Icons.next_plan),
                label: Text('Következő'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
