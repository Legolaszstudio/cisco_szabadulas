import 'package:cisco_szabadulas/helpers/check_conf/http_server.dart';
import 'package:cisco_szabadulas/helpers/check_conf/is_ip_conf_right.dart';
import 'package:cisco_szabadulas/helpers/debug_menu/debug_menu.dart';
import 'package:cisco_szabadulas/ui/html/stage_three_html.dart';
import 'package:cisco_szabadulas/ui/stages/03/stage_three_one.dart';
import 'package:cisco_szabadulas/ui/stages/03/stage_three_three.dart';
import 'package:cisco_szabadulas/ui/stages/03/stage_three_two.dart';
import 'package:flutter/material.dart';
import 'package:cisco_szabadulas/helpers/globals.dart' as globals;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:window_size/window_size.dart';

class StageThree extends StatefulWidget {
  const StageThree({super.key});

  @override
  State<StageThree> createState() => _StageThreeState();
}

class _StageThreeState extends State<StageThree> {
  String myIp = '192.168.${globals.teamNumber}.${globals.pcNumber}';

  @override
  void initState() {
    myIp = '192.168.${globals.teamNumber}.${globals.pcNumber}';
    setWindowTitle('Cisco Szabadulás - Harmadik stádium');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (globals.httpServerVer != 0) {
        await globals.server?.close();
      }
      globals.server = await startServer(stage_three_html());
      globals.httpServerVer = 3;
      if (globals.stageThreeStart == 0) {
        globals.stageThreeStart = DateTime.now().millisecondsSinceEpoch;
        globals.prefs.setInt('stageThreeStart', globals.stageThreeStart);
        print('Timing started for stage 3: ${globals.stageThreeStart}');
      }
      if (globals.currentStage == 3.1) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => StageThreeOne(),
          ),
        );
      }
      if (globals.currentStage == 3.2) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => StageThreeTwo(),
          ),
        );
      }
      if (globals.currentStage == 3.3) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => StageThreeThree(),
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
            'Cisco Szabadulás 3.0 - Harmadik stádium (Egy nagy kapcsolat)',
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
            child: Text('Ugye nem állítódott el még a címünk?',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
          ),
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

                globals.prefs.setDouble('currentStage', 3.1);
                globals.currentStage = 3.1;
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => StageThreeOne(),
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
