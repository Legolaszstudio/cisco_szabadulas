import 'package:cisco_szabadulas/helpers/debug_menu/debug_menu.dart';
import 'package:cisco_szabadulas/helpers/ms_to_human_str.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';
import 'package:cisco_szabadulas/helpers/globals.dart' as globals;

class TheEnd extends StatefulWidget {
  const TheEnd({super.key});

  @override
  State<TheEnd> createState() => _TheEndState();
}

class _TheEndState extends State<TheEnd> {
  @override
  Widget build(BuildContext context) {
    setWindowTitle('Cisco Szabadulás - Itt a vége fuss el véle');
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text(
            'Cisco Szabadulás - Itt a vége fuss el véle',
          ),
          onDoubleTap: () {
            showDebugMenu();
          },
        ),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(height: 10),
            Text(
              'Szép munka!',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            Text(
              'Legyőztétek a gonosz Bátrói csoportot, az újraindítás kiűzte őket a rendszerbe (egyelőre...)',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),
            Text(
              'Idők;',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            Text(
              '1.-es stádium: ' +
                  ((globals.stageOneStart <= 0 || globals.stageOneEnd <= 0)
                      ? 'Ismeretlen???'
                      : '${msToHumanStr(globals.stageOneEnd - globals.stageOneStart)}'),
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            Text(
              '2.-es stádium: ' +
                  ((globals.stageTwoStart <= 0 || globals.stageTwoEnd <= 0)
                      ? 'Ismeretlen???'
                      : '${msToHumanStr(globals.stageTwoEnd - globals.stageTwoStart)}'),
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            Text(
              '3-as stádium: ' +
                  ((globals.stageThreeStart <= 0 || globals.stageThreeEnd <= 0)
                      ? 'Ismeretlen???'
                      : '${msToHumanStr(globals.stageThreeEnd - globals.stageThreeStart)}'),
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            Text(
              '4-es stádium: ' +
                  ((globals.stageFourStart <= 0 || globals.stageFourEnd <= 0)
                      ? 'Ismeretlen???'
                      : '${msToHumanStr(globals.stageFourEnd - globals.stageFourStart)}'),
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            Text(
              '5-ös stádium első fele: ' +
                  ((globals.stageFiveStart <= 0 ||
                          globals.stageFiveSectionOneEnd <= 0)
                      ? 'Ismeretlen???'
                      : '${msToHumanStr(globals.stageFiveSectionOneEnd - globals.stageFiveStart)}'),
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            Text(
              '5-ös stádium: ' +
                  ((globals.stageFiveStart <= 0 || globals.stageFiveEnd <= 0)
                      ? 'Ismeretlen???'
                      : '${msToHumanStr(globals.stageFiveEnd - globals.stageFiveStart)}'),
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
