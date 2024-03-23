import 'package:cisco_szabadulas/helpers/check_conf/http_client.dart';
import 'package:cisco_szabadulas/helpers/check_conf/is_ip_conf_right.dart';
import 'package:cisco_szabadulas/helpers/debug_menu/debug_menu.dart';
import 'package:cisco_szabadulas/helpers/globals.dart' as globals;
import 'package:cisco_szabadulas/helpers/simple_alert.dart';
import 'package:cisco_szabadulas/ui/stages/02/stage_two_two.dart';
import 'package:cisco_szabadulas/ui/stages/02/stage_two_zero.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

class StageTwoOne extends StatefulWidget {
  const StageTwoOne({super.key});

  @override
  State<StageTwoOne> createState() => _StageTwoOneState();
}

class _StageTwoOneState extends State<StageTwoOne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text(
            'Cisco Szabadulás 2.1 - Második stádium (Egyszerű kapcsolat)',
          ),
          onDoubleTap: () {
            showDebugMenu();
          },
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Text(
              '''
Jut eszembe, ha összekötitek a két gépet, úgy kétszer gyorsabban fogjátok tudni feltörni a gépemet 😅
Ehhez viszont a sarokban található zúgó ketyerékre lesz majd szükségetek.
A gépektől a szekrényig vannak kábelek a falba, így nekünk szerencsére nem kell majd 20-30 méteres kábeleket gubancolni.


1. Dugjuk át gépünket a szekrényhez vezető (falban található) kábelbe.
Jelen pillanatban nagy valószínűséggel a NET feliratú aljzatba van dugva.
Innen kellene átdugni a piros (RACK feliratú) aljzatba. (Jegyezzük meg a számot ahova bedugtuk!)
''',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),
          Container(
            constraints: BoxConstraints.expand(
                height: MediaQuery.of(context).size.height * 0.6),
            child: Image(
              fit: BoxFit.scaleDown,
              image: AssetImage('assets/03eszkozok/fal.jpg'),
            ),
          ),
          SizedBox(height: 20),
          Text(
            '''
Az alábbi eszközök a tietek, de ez ott is fel lesz matricázva, illetve a megfelelő színnel jelölve;
''',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          Container(
            constraints: BoxConstraints.expand(
                height: MediaQuery.of(context).size.height * 0.90),
            child: Image(
              fit: BoxFit.scaleDown,
              image: AssetImage(
                  'assets/03eszkozok/csoportok/${globals.teamNumber}.jpg'),
            ),
          ),
          SizedBox(height: 20),
          Text(
            '''
Most a fentebb található, 'sok lyukú' eszközre van szükségetek, őt úgy hívják, hogy switch.
Feladata, hogy összekössön sok számítógépet. Jelen esetben a mi kettő gépünket.
A középen található 'H' jelölésű elosztó (patch) panelen található rack aljzatba bedugott kábel másik vége.
''',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          Container(
            constraints: BoxConstraints.expand(
                height: MediaQuery.of(context).size.height * 0.6),
            child: Image(
              fit: BoxFit.scaleDown,
              image: AssetImage('assets/03eszkozok/patch01.jpg'),
            ),
          ),
          SizedBox(height: 10),
          Text(
            '''
Tehát, a képet például véve, ha a 31-es fali aljzatba dugtuk a gépünket az előbb, akkor itt a 'H' panelen is a 31-esből fogunk kiindulni
És bedugni a switchünk a bal oldalon található 24 port valamelyikébe. (Mind1 melyikbe, mindegyik 'össze van kötve')
Ha mindent jól csináltunk akkor a port felett található led elkezd sárgán villogni, majd (ha türelmesek vagyunk), akkor zöld-re vált és kezdődhet a kommunikáció.

Ha jól csináltunk mindent, mind két gépen/géppel, akkor az alábbi ellenőrzés gomb szépen tovább fog engedni minket;
''',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          FractionallySizedBox(
            widthFactor: 0.5,
            child: TextButton.icon(
              icon: Icon(Icons.checklist),
              label: Text('Ellenőrzés'),
              onPressed: () async {
                context.loaderOverlay.show();

                String myIp = '192.168.${globals.teamNumber}.';
                String otherPcIp = '192.168.${globals.teamNumber}.';
                if (globals.pcNumber == 1) {
                  myIp += '1';
                  otherPcIp += '2';
                } else {
                  myIp += '2';
                  otherPcIp += '1';
                }

                String ipCheckResult = await isIpConfRight(myIp);

                if (ipCheckResult != 'OK') {
                  globals.prefs.setDouble('currentStage', 2.0);
                  globals.currentStage = 2.0;
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => StageTwo(),
                    ),
                  );
                  showSimpleAlert(
                    context: context,
                    title: 'Hiba - Félrecsúszott valami az ip-vel',
                    content: 'Adjunk ennek a dolognak még egy próbát! 😉',
                  );
                  context.loaderOverlay.hide();
                  return; // IpConfig is not right, return to previous stage
                }

                bool httpCheckResult = await runHttpConnectivityCheck(
                  context,
                  destination: 'http://$otherPcIp/',
                  stageNum: 2,
                );
                context.loaderOverlay.hide();

                if (httpCheckResult == false) {
                  return; // Something is not right, httpcheck function should handle error messages
                }

                globals.prefs.setDouble('currentStage', 2.2);
                globals.currentStage = 2.2;

                globals.stageTwoEnd = DateTime.now().millisecondsSinceEpoch;
                globals.prefs.setInt('stageTwoEnd', globals.stageTwoEnd);
                print('Timing ended for stage 2: ${globals.stageTwoEnd}');

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => StageTwoTwo(),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
