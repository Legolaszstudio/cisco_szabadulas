import 'dart:math';
import 'package:async/async.dart';
import 'package:cisco_szabadulas/helpers/check_conf/http_client.dart';
import 'package:cisco_szabadulas/helpers/check_conf/is_ip_conf_right.dart';
import 'package:cisco_szabadulas/helpers/debug_menu/debug_menu.dart';
import 'package:cisco_szabadulas/helpers/simple_alert.dart';
import 'package:cisco_szabadulas/ui/stages/03/stage_three_two.dart';
import 'package:cisco_szabadulas/ui/stages/03/stage_three_zero.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:cisco_szabadulas/helpers/globals.dart' as globals;

class StageThreeOne extends StatefulWidget {
  const StageThreeOne({super.key});

  @override
  State<StageThreeOne> createState() => _StageThreeOneState();
}

class _StageThreeOneState extends State<StageThreeOne> {
  bool _isChecking = false;
  Widget _btnWidget = Icon(Icons.checklist);
  Widget _checkList = SizedBox();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text(
            'Cisco Szabadulás 3.1 - Harmadik stádium (Egy nagy kapcsolat)',
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
            child: Text('Kössünk össze mindent!'),
          ),
          SizedBox(height: 10),
          FractionallySizedBox(
            widthFactor: 0.5,
            child: TextButton.icon(
              icon: _btnWidget,
              label: Text('Ellenőrzés'),
              onPressed: () async {
                if (_isChecking) return;
                _isChecking = true;
                context.loaderOverlay.show();

                String myIp =
                    '192.168.${globals.teamNumber}.${globals.pcNumber}';
                String otherPcIp = '192.168.${globals.teamNumber}.';
                if (globals.pcNumber == 1) {
                  otherPcIp += '2';
                } else {
                  otherPcIp += '1';
                }

                String ipCheckResult = await isIpConfRight(myIp);

                if (ipCheckResult != 'OK') {
                  globals.prefs.setDouble('currentStage', 3.0);
                  globals.currentStage = 3.0;
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => StageThree(),
                    ),
                  );
                  showSimpleAlert(
                    context: context,
                    title: 'Hiba - Félrecsúszott valami az ip-vel',
                    content: 'Adjunk ennek a dolognak még egy próbát! 😉',
                  );
                  context.loaderOverlay.hide();
                  _isChecking = false;
                  return; // IpConfig is not right, return to previous stage
                }

                context.loaderOverlay.hide();
                setState(() {
                  _btnWidget = CircularProgressIndicator();
                });
                List<Widget> checkListItems = [];
                for (int i = 1; i <= (globals.numberOfTeams ?? 7); i++) {
                  checkListItems.add(
                    ListTile(
                      title: Text('Csapat $i'),
                      trailing: CircularProgressIndicator(),
                    ),
                  );
                }
                setState(() {
                  _checkList = Column(
                    children: checkListItems,
                  );
                });

                bool httpCheckResult = false;
                final FutureGroup futureGroup = FutureGroup();
                for (int i = 1; i <= (globals.numberOfTeams ?? 7); i++) {
                  Future<void> task() async {
                    await Future.delayed(
                      Duration(
                        milliseconds: 1000 + Random().nextInt(1000),
                      ),
                    );
                    if (i == globals.teamNumber) {
                      httpCheckResult = await runHttpConnectivityCheck(
                        context,
                        destination: 'http://$otherPcIp/',
                        stageNum: 3,
                      );
                      print('http check result: $httpCheckResult');
                      if (httpCheckResult == false) {
                        checkListItems[i - 1] = ListTile(
                          title: Text('Csapat $i'),
                          trailing: Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                        );
                      } else {
                        checkListItems[i - 1] = ListTile(
                          title: Text('Csapat $i'),
                          trailing: Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                        );
                      }
                      setState(() {
                        _checkList = Column(
                          children: checkListItems,
                        );
                      });
                    } else {
                      checkListItems[i - 1] = ListTile(
                        title: Text('Csapat $i'),
                        trailing: Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                      );
                    }
                    setState(() {
                      _checkList = Column(
                        children: checkListItems,
                      );
                    });
                  }

                  futureGroup.add(task());
                }
                futureGroup.close();
                await futureGroup.future;

                await Future.delayed(
                  Duration(
                    milliseconds: 2500,
                  ),
                );

                setState(() {
                  _btnWidget = Icon(Icons.checklist);
                  _isChecking = false;
                });

                if (httpCheckResult == false) return;

                globals.prefs.setDouble('currentStage', 3.2);
                globals.currentStage = 3.2;

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => StageThreeTwo(),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 25),
          _checkList,
        ],
      ),
    );
  }
}
