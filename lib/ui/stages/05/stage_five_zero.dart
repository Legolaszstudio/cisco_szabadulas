import 'package:cisco_szabadulas/helpers/check_conf/http_client.dart';
import 'package:cisco_szabadulas/helpers/check_conf/http_server.dart';
import 'package:cisco_szabadulas/helpers/check_conf/is_ip_conf_right.dart';
import 'package:cisco_szabadulas/helpers/debug_menu/debug_menu.dart';
import 'package:cisco_szabadulas/ui/html/stage_five_html.dart';
import 'package:cisco_szabadulas/ui/stages/05/stage_five_one.dart';
import 'package:cisco_szabadulas/ui/widgets/ip_help.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:window_size/window_size.dart';
import 'package:cisco_szabadulas/helpers/globals.dart' as globals;

class StageFive extends StatefulWidget {
  const StageFive({super.key});

  @override
  State<StageFive> createState() => _StageFiveState();
}

class _StageFiveState extends State<StageFive> {
  String ipToConfig = '192.168.${globals.teamNumber}.${globals.pcNumber}';
  String gwToConfig = '192.168.${globals.teamNumber}.254';

  @override
  void initState() {
    setWindowTitle('Cisco Szabadulás - Ötödik stádium');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (globals.httpServerVer != 0) {
        await globals.server?.close();
      }
      globals.server = await startServer(stage_five_html(0));
      globals.httpServerVer = 5.0;
      if (globals.stageFiveStart == 0) {
        globals.stageFiveStart = DateTime.now().millisecondsSinceEpoch;
        globals.prefs.setInt('stageFiveStart', globals.stageFiveStart);
        print('Timing started for stage 5: ${globals.stageFiveStart}');
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
            'Cisco Szabadulás 5.0 - Végső stádium (Támadás!)',
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
Gyorsan pakoljunk vissza gépeinket egy hálózatba.
${globals.pcNumber == 2 ? '\nÁllítsuk vissza az ip címünket \'belső hálózatosra\'\nIp cím: 192.168.${globals.teamNumber}.2\nMaszk: 255.255.255.0\nÁtjáró: 192.168.${globals.teamNumber}.254' : ''}
''',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          if (globals.pcNumber == 2)
            IpHelp(
              myIp: '192.168.${globals.teamNumber}.2',
              myGw: '192.168.${globals.teamNumber}.254',
            ),
          Text(
            '''
Dugjuk is be a gépeket a switchünk be!
''',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
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
          FractionallySizedBox(
            widthFactor: 0.5,
            child: TextButton.icon(
              icon: Icon(Icons.checklist),
              label: Text('Ellenőrzés'),
              onPressed: () async {
                context.loaderOverlay.show();

                bool ipCheckResult = await runIpCheck(
                  context,
                  ipToCheck: ipToConfig,
                  gatewayToCheck: gwToConfig,
                );

                if (ipCheckResult == false) {
                  context.loaderOverlay.hide();
                  return; // Config is not right, ipcheck function should handle error messages
                }

                bool httpCheckResult = await runHttpConnectivityCheck(
                  context,
                  destination: globals.pcNumber == 1
                      ? 'http://192.168.${globals.teamNumber}.2/'
                      : 'http://192.168.${globals.teamNumber}.1',
                  stageNum: 5.0,
                );

                if (httpCheckResult == false) {
                  context.loaderOverlay.hide();
                  return; // Something is not right, httpcheck function should handle error messages
                }

                context.loaderOverlay.hide();
                globals.prefs.setDouble('currentStage', 5.1);
                globals.currentStage = 5.1;
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => StageFiveOne(),
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
