import 'package:cisco_szabadulas/helpers/check_conf/http_server.dart';
import 'package:cisco_szabadulas/helpers/check_conf/ping_check.dart';
import 'package:cisco_szabadulas/helpers/debug_menu/debug_menu.dart';
import 'package:cisco_szabadulas/helpers/simple_alert.dart';
import 'package:cisco_szabadulas/ui/html/stage_five_html.dart';
import 'package:flutter/material.dart';
import 'package:cisco_szabadulas/helpers/globals.dart' as globals;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:window_size/window_size.dart';

import 'stage_five_two.dart';

class StageFiveOne extends StatefulWidget {
  const StageFiveOne({super.key});

  @override
  State<StageFiveOne> createState() => _StageFiveOneState();
}

class _StageFiveOneState extends State<StageFiveOne> {
  @override
  void initState() {
    setWindowTitle('Cisco Szabadulás - Ötödik stádium');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (globals.httpServerVer != 0) {
        await globals.server?.close();
      }
      globals.server = await startServer(stage_five_html(1));
      globals.httpServerVer = 5.1;
    });
    super.initState();
  }

  void nextStage() {
    globals.currentStage = 5.2;
    globals.prefs.setDouble('currentStage', 5.2);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => StageFiveTwo(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text(
            'Cisco Szabadulás 5.1 - Végső stádium (Támadás!)',
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
Csatlakozzunk a routerhez!
Így már minden gépünk képes lesz elérni a többi hálózatot.

Dugjuk be a switchünk 'uplink' portját a routerünk f0/0 portjába!''',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
          Container(
            constraints: BoxConstraints.expand(
                height: MediaQuery.of(context).size.height * 0.75),
            child: Image(
              fit: BoxFit.scaleDown,
              image: AssetImage('assets/03eszkozok/r_sw.jpg'),
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

                PingSuccess result =
                    await pingCheck('192.168.${globals.teamNumber}.254');
                if (result.successRate == 100) {
                  showSimpleAlert(
                    context: context,
                    title: '100%-os kapcsolat 🎉',
                    content:
                        'Hibátlanul elérem a routert, nagyon ügyesek vagytok ✨',
                    dismissable: false,
                    okCallback: nextStage,
                  );
                } else if (result.successRate == 0) {
                  showSimpleAlert(
                    context: context,
                    title: 'Hiba - Ez sajnos nem működik :(',
                    content:
                        'Próbáljátok meg újra, jó helyre van minden bedugva?\nHa továbbra sem működik, kérjetek segítséget nyugodtan!\n\nRészletek:\n${result.errors.join("\n")}',
                  );
                  context.loaderOverlay.hide();
                  return;
                } else {
                  // Se nem 100, se nem null
                  showSimpleAlert(
                    context: context,
                    title:
                        'Ugyan nem 100%-os, csak ${result.successRate}%-os, de működik',
                    content:
                        'Nem hibátlan, de működik, ez már valami! 🎉\n\nRészletek:\n${result.errors.join("\n")}',
                    dismissable: false,
                    okCallback: nextStage,
                  );
                }
                context.loaderOverlay.hide();
              },
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
