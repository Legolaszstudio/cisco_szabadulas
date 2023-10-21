import 'package:cisco_szabadulas/helpers/check_conf/http_server.dart';
import 'package:cisco_szabadulas/helpers/check_conf/is_ip_conf_right.dart';
import 'package:cisco_szabadulas/helpers/debug_menu/debug_menu.dart';
import 'package:cisco_szabadulas/ui/html/stage_two_html.dart';
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
  @override
  void initState() {
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
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Text(
              '''
Itt kellene írni arról, hogy hogyan és miért kell statikus címet beírni
''',
            ),
          ),
          SizedBox(height: 10),
          TextButton(
            child: Text('Ellenőrzés'),
            onPressed: () async {
              context.loaderOverlay.show();

              String myIp = '192.168.${globals.teamNumber}.';
              if (globals.pcNumber == 1) {
                myIp += '1';
              } else {
                myIp += '2';
              }

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
        ],
      ),
    );
  }
}
