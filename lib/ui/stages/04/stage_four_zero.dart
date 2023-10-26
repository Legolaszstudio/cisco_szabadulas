import 'package:cisco_szabadulas/helpers/check_conf/http_server.dart';
import 'package:cisco_szabadulas/helpers/debug_menu/debug_menu.dart';
import 'package:cisco_szabadulas/ui/html/stage_four_html.dart';
import 'package:cisco_szabadulas/ui/stages/04/stage_four_one.dart';
import 'package:cisco_szabadulas/ui/stages/04/stage_four_three.dart';
import 'package:cisco_szabadulas/ui/stages/04/stage_four_two.dart';
import 'package:flutter/material.dart';
import 'package:cisco_szabadulas/helpers/globals.dart' as globals;
import 'package:window_size/window_size.dart';

class StageFour extends StatefulWidget {
  const StageFour({super.key});

  @override
  State<StageFour> createState() => _StageFourState();
}

class _StageFourState extends State<StageFour> {
  @override
  void initState() {
    setWindowTitle('Cisco Szabadulás - Negyedik stádium');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (globals.httpServerVer != 0) {
        await globals.server?.close();
      }
      globals.server = await startServer(stage_four_html());
      globals.httpServerVer = 4;
      if (globals.stageFourStart == 0) {
        globals.stageFourStart = DateTime.now().millisecondsSinceEpoch;
        globals.prefs.setInt('stageFourStart', globals.stageFourStart);
        print('Timing started for stage 4: ${globals.stageFourStart}');
      }
      if (globals.currentStage == 4.1) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => StageFourOne(),
          ),
        );
      }
      if (globals.currentStage == 4.2) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => StageFourTwo(),
          ),
        );
      }
      if (globals.currentStage == 4.3) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => StageFourThree(),
          ),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text(
            'Cisco Szabadulás 4.0 - Negyedik stádium (Több hálózat)',
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
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Text(
                '''
      Annyira buta vagyok, de tényleg, nagyon sajnálom 😅😭
      Az én gépem egy teljesen másik hálózatban van (10.x.x.x), így azt továbbra sem érjük el..
      Sajnos nem létezik olyan maszk, hogy 0.0.0.0...
      
      De szerencsére a másik zúgó csoda eszköz, melynek becses neve Router, pontosan ezt a feladatot látja el, különböző hálózatokat köt össze.
      Mivel nem szeretünk élesben tesztelni, ezért építsünk fel egy picike teszt hálózatot a routerünkkel és a két géppel...
      
      Ehhez romboljunk le mindent amit eddig bedugtunk, összekötöttünk... 😅
      Bocsánat, tényleg sajnálom 😭
      
      Ha kész vagyunk, akkor lépjünk csak tovább;
      ''',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.5,
              child: TextButton.icon(
                icon: Icon(Icons.next_plan),
                label: Text('Következő'),
                onPressed: () async {
                  globals.currentStage = 4.1;
                  globals.prefs.setDouble('currentStage', 4.1);

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => StageFourOne(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
