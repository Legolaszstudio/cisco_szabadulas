import 'package:cisco_szabadulas/helpers/check_conf/http_server.dart';
import 'package:cisco_szabadulas/helpers/check_conf/is_ip_conf_right.dart';
import 'package:cisco_szabadulas/helpers/debug_menu/debug_menu.dart';
import 'package:cisco_szabadulas/ui/html/stage_two_html.dart';
import 'package:cisco_szabadulas/ui/stages/02/stage_two_two.dart';
import 'package:cisco_szabadulas/ui/widgets/ip_help.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:window_size/window_size.dart';
import 'package:cisco_szabadulas/helpers/globals.dart' as globals;
import 'stage_two_one.dart';

class StageTwo extends StatefulWidget {
  const StageTwo({super.key});

  @override
  State<StageTwo> createState() => _StageTwoState();
}

class _StageTwoState extends State<StageTwo> {
  String myIp = '192.168.${globals.teamNumber}.${globals.pcNumber}';

  @override
  void initState() {
    myIp = '192.168.${globals.teamNumber}.${globals.pcNumber}';
    setWindowTitle('Cisco Szabadulás - Második stádium');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (globals.httpServerVer != 0) {
        await globals.server?.close();
      }
      globals.server = await startServer(stage_two_html());
      globals.httpServerVer = 2;
      if (globals.stageTwoStart == 0) {
        globals.stageTwoStart = DateTime.now().millisecondsSinceEpoch;
        globals.prefs.setInt('stageTwoStart', globals.stageTwoStart);
        print('Timing started for stage 2: ${globals.stageTwoStart}');
      }
      if (globals.currentStage == 2.1) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => StageTwoOne(),
          ),
        );
      }
      if (globals.currentStage == 2.2) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => StageTwoTwo(),
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
            'Cisco Szabadulás 2.0 - Második stádium (Egyszerű kapcsolat)',
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
Mivel a jelszavaimat a gépemen tárolom, ezért kénytelenek lesztek feltörni. Ne aggódjatok, ez a program segíteni fog benne.
      
Először is adjunk címet a számítógépünknek, hogy tudjunk kommunikálni majd az én gépemmel.
Olyan mint a lakcímek, ha levelet akarunk küldeni, akkor tudnunk kell a címét a címzettünknek, illetve rendelkeznünk kell nekünk is egy címmel, hogy tudjunk választ fogadni.
      
Az alábbi címet kellene beállítani: $myIp
192.168.(csapat szám).(gép szám)

A következő maszkkal: 255.255.255.0
Ez azt jelenti, hogy mi csak olyan feladókkal beszélgetünk, akinek megegyzik az első három szegmense a miénkkel.''',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
            SizedBox(height: 10),
            IpHelp(myIp: myIp),
            SizedBox(height: 10),
            FractionallySizedBox(
              widthFactor: 0.5,
              child: TextButton.icon(
                icon: Icon(Icons.checklist),
                label: Text('Ellenőrzés'),
                onPressed: () async {
                  context.loaderOverlay.show();

                  bool ipCheckResult = await runIpCheck(
                    context,
                    ipToCheck: myIp,
                  );
                  context.loaderOverlay.hide();

                  if (ipCheckResult == false) {
                    return; // Config is not right, ipcheck function should handle error messages
                  }

                  globals.prefs.setDouble('currentStage', 2.1);
                  globals.currentStage = 2.1;
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => StageTwoOne(),
                    ),
                  );
                },
              ),
            ),
            Text(
              'Biztosan sok kérdésetek van, de majd mindenre szépen lassan választ kaptok 😉',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
