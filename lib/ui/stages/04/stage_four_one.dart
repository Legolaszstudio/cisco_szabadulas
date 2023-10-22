import 'package:cisco_szabadulas/helpers/check_conf/is_ip_conf_right.dart';
import 'package:cisco_szabadulas/helpers/debug_menu/debug_menu.dart';
import 'package:flutter/material.dart';
import 'package:cisco_szabadulas/helpers/globals.dart' as globals;
import 'package:loader_overlay/loader_overlay.dart';

class StageFourOne extends StatefulWidget {
  const StageFourOne({super.key});

  @override
  State<StageFourOne> createState() => _StageFourOneState();
}

class _StageFourOneState extends State<StageFourOne> {
  String myIp = '192.168.${globals.teamNumber}.1';
  String myGw = '192.168.${globals.teamNumber}.254';

  @override
  void initState() {
    if (globals.pcNumber == 2) {
      myIp = '10.10.10.100';
      myGw = '10.10.10.${globals.teamNumber}';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text(
            'Cisco Szabadulás 4.1 - Negyedik stádium (Több hálózat)',
          ),
          onDoubleTap: () {
            showDebugMenu();
          },
        ),
      ),
      body: ListView(
        children: [
          globals.pcNumber == 1
              ? Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Text('Default Gateway Only (IP: $myIp, GW: $myGw)'),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Text(
                      'Hertelendi gépét fogjuk szimulálni (IP: $myIp, GW: $myGw)'),
                ),
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
                  gatewayToCheck: myGw,
                );
                context.loaderOverlay.hide();

                if (ipCheckResult == false) return;

                globals.currentStage = 4.2;
                globals.prefs.setDouble('currentStage', 4.2);

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
    );
  }
}
