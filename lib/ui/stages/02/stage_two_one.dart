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
Itt kellene írni arról, hogy hogyan a fallba bedugni a cuccokat, meg a rackbe
''',
            ),
          ),
          SizedBox(height: 10),
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
        ],
      ),
    );
  }
}
