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
  Widget hintWidget = Padding(
    padding: const EdgeInsets.only(left: 100, right: 100, top: 10),
    child: Text(
      '''
(Segítség hamarosan)
''',
      style: TextStyle(fontSize: 15),
      textAlign: TextAlign.center,
    ),
  );
  TextEditingController _passwordCtrl = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void updateTime() {
    setState(() {
      int endTime = globals.stageOneStart + (globals.timeForStageOne * 60000);
      int timeLeft = endTime - DateTime.now().millisecondsSinceEpoch;

      _timeLeftStr = msToHumanStr(timeLeft);

      if (timeLeft <= (globals.timeForStageOne - 12) * 60000) {
        // 12 minute passed
        hintWidget = Padding(
          padding: const EdgeInsets.only(left: 100, right: 100, top: 10),
          child: Text(
            '''
Első levél: Asztalon
Második levél: Letöltések között
Harmadik levél: Képek között (Screenshot/Képernyőkép mappában)
Negyedik levél: Zenék között (Valamelyik mappában)
''',
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
        );
      } else if (timeLeft <= (globals.timeForStageOne - 10) * 60000) {
        // 10 minute passed
        hintWidget = Padding(
          padding: const EdgeInsets.only(left: 100, right: 100, top: 10),
          child: Text(
            '''
Első levél: Asztalon
Második levél: Letöltések között
Harmadik levél: Képek között
''',
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
        );
      } else if (timeLeft <= (globals.timeForStageOne - 8) * 60000) {
        // 8 minute passed
        hintWidget = Padding(
          padding: const EdgeInsets.only(left: 100, right: 100, top: 10),
          child: Text(
            '''
Első levél: Asztalon
Második levél: Letöltések között
''',
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
        );
      } else if (timeLeft <= (globals.timeForStageOne - 5) * 60000) {
        // 5 minute passed
        hintWidget = Padding(
          padding: const EdgeInsets.only(left: 100, right: 100, top: 10),
          child: Text(
            '''
Első levél: Asztalon
''',
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
        );
      }

      if (timeLeft <= 0) {
        _timeLeftStr = '00:00';
        goToNextStage(false);
        Future.delayed(Duration(seconds: 2)).then((value) {
          showSimpleAlert(
              context: globals.navigatorKey.currentContext!,
              title: 'Lejárt az idő! ⏰',
              content: '''
Nektek itt vége a versenynek, kérlek hagyjátok el a konyhát.

Csak vicceltem 🤣
Semmi gond; ha idáig eljutottatok, az már elég bizonyíték arra, hogy ti vagytok a legjobbak a feladatra! 😎

Egy valamit jól véssetek eszetekbe: X.C.C.C
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

  void goToNextStage(bool success) {
    _timer.cancel();
    globals.stageOneEnd = DateTime.now().millisecondsSinceEpoch;
    globals.prefs.setInt('stageOneEnd', globals.stageOneEnd);
    globals.currentStage = 1.2;
    globals.prefs.setDouble('currentStage', 1.2);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => StageOneTwo(success: success)),
    );
  }

  @override
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
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 100, right: 100, top: 10),
              child: Text(
                '''
      A gépeken találtok elszórva pár levelet, pontosan 4-et, melyeket az ilyen vészhelyzetek esetére rejtettem el. 😅
      Viszont direkt el vannak rejtve, hogy akárki ne találhassa meg őket.
      A feladatotok az, hogy megtaláljátok őket, és a kódot beírjátok ide alulra;
      ''',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.start,
              ),
            ),
            hintWidget,
            Padding(
              padding: const EdgeInsets.only(left: 100, right: 100, top: 10),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  autofocus: true,
                  controller: _passwordCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Kód',
                    errorStyle: TextStyle(color: Colors.red),
                  ),
                  onFieldSubmitted: (value) {
                    if (_formKey.currentState!.validate()) {
                      goToNextStage(true);
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kérem a jelszót';
                    }
                    if (value.toLowerCase() != globals.stageOnePassword) {
                      return 'Hibás jelszó';
                    }
                    return null;
                  },
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            FractionallySizedBox(
              widthFactor: 0.5,
              child: TextButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    goToNextStage(true);
                  }
                },
                icon: Icon(Icons.key),
                label: Text('Tovább'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
