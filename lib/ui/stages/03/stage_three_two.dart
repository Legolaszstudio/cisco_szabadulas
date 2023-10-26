import 'package:async/async.dart';
import 'package:cisco_szabadulas/helpers/check_conf/http_client.dart';
import 'package:cisco_szabadulas/helpers/check_conf/is_ip_conf_right.dart';
import 'package:cisco_szabadulas/helpers/debug_menu/debug_menu.dart';
import 'package:cisco_szabadulas/helpers/simple_alert.dart';
import 'package:cisco_szabadulas/ui/stages/03/stage_three_three.dart';
import 'package:cisco_szabadulas/ui/widgets/ip_help.dart';
import 'package:cisco_szabadulas/ui/widgets/reading_for_quickies.dart';
import 'package:flutter/material.dart';
import 'package:cisco_szabadulas/helpers/globals.dart' as globals;
import 'package:loader_overlay/loader_overlay.dart';

class StageThreeTwo extends StatefulWidget {
  const StageThreeTwo({super.key});

  @override
  State<StageThreeTwo> createState() => _StageThreeTwoState();
}

class _StageThreeTwoState extends State<StageThreeTwo> {
  bool _isChecking = false;
  bool showReading = false;
  Widget _statefulHint = SizedBox();
  Widget _btnWidget = Icon(Icons.checklist);
  Widget _checkList = SizedBox();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text(
            'Cisco Szabadulás 3.2 - Harmadik stádium (Egy nagy kapcsolat)',
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
Jaj én butus, így továbbra is csak a saját csapatunkat érjük el! 😅
Hiszen a 255.255.255.0-ás maszk az jelenti, hogy csak olyan címekkel beszélgetünk, aminek az első három számjegye megegyezik a sajátunkkal.
Mivel minden csapat a saját csapatszámát használja harmadik számjegyként, ezért ez így nem lesz jó.

Ez gyorsan orvosolható, csak át kell írni a maszkot 255.255.0.0-ra.
Így már csak az első két számjegynek kell stimmelni, hogy tudjunk beszélgetni.
''',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
          IpHelp(
            myIp: '192.168.${globals.teamNumber}.${globals.pcNumber}',
            myMask: '255.255.0.0',
          ),
          _statefulHint,
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

                bool ipCheckResult = await runIpCheck(
                  context,
                  ipToCheck: myIp,
                  maskToCheck: '255.255.0.0',
                );
                context.loaderOverlay.hide();

                if (ipCheckResult == false) {
                  _isChecking = false;
                  return;
                }

                setState(() {
                  _btnWidget = CircularProgressIndicator();
                });
                List<Widget> checkListItems = [
                  ListTile(
                    title: Text('Hertelendi gépe'),
                    trailing: Wrap(
                      direction: Axis.horizontal,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    ),
                  ),
                ];
                Map<String, String> resultMap = {};
                for (int i = 1; i <= (globals.numberOfTeams ?? 7); i++) {
                  checkListItems.add(
                    ListTile(
                      title: Text('Csapat $i'),
                      trailing: Wrap(
                        direction: Axis.horizontal,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 10),
                          CircularProgressIndicator(),
                        ],
                      ),
                    ),
                  );
                }
                setState(() {
                  _checkList = Column(
                    children: checkListItems,
                  );
                });

                final FutureGroup futureGroup = FutureGroup();
                Future<void> checkHertelendiPc() async {
                  String httpResult = await checkHttpConnectivity(
                    'http://10.100.100.100',
                    100,
                  );
                  print('http check result 10.100.100.100: $httpResult');
                  if (httpResult == 'OK') {
                    checkListItems[0] = ListTile(
                      title: Text('Hertelendi gépe'),
                      trailing: Wrap(
                        direction: Axis.horizontal,
                        children: [
                          Tooltip(
                            message: httpResult,
                            child: Icon(
                              Icons.check,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    checkListItems[0] = ListTile(
                      title: Text('Hertelendi gépe'),
                      trailing: Wrap(
                        direction: Axis.horizontal,
                        children: [
                          Tooltip(
                            message: httpResult,
                            child: Icon(
                              Icons.error,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }

                futureGroup.add(checkHertelendiPc());
                for (int i = 1; i <= (globals.numberOfTeams ?? 7); i++) {
                  Future<void> task() async {
                    String httpResultOne = await checkHttpConnectivity(
                      'http://192.168.$i.1',
                      3,
                    );
                    print('http check result 192.168.$i.1: $httpResultOne');
                    resultMap['$i.1'] = httpResultOne;
                    if (httpResultOne == 'OK') {
                      checkListItems[i] = ListTile(
                        title: Text('Csapat $i'),
                        trailing: Wrap(
                          direction: Axis.horizontal,
                          children: [
                            Tooltip(
                              message: httpResultOne,
                              child: Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(width: 10),
                            CircularProgressIndicator(),
                          ],
                        ),
                      );
                    } else {
                      checkListItems[i] = ListTile(
                        title: Text('Csapat $i'),
                        trailing: Wrap(
                          direction: Axis.horizontal,
                          children: [
                            Tooltip(
                              message: httpResultOne,
                              child: Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(width: 10),
                            CircularProgressIndicator(),
                          ],
                        ),
                      );
                    }
                    setState(() {
                      _checkList = Column(
                        children: checkListItems,
                      );
                    });

                    String httpResultTwo = await checkHttpConnectivity(
                      'http://192.168.$i.2',
                      3,
                    );
                    resultMap['$i.2'] = httpResultTwo;
                    print('http check result 192.168.$i.2: $httpResultTwo');
                    if (httpResultOne == 'OK') {
                      if (httpResultTwo == 'OK') {
                        checkListItems[i] = ListTile(
                          title: Text('Csapat $i'),
                          trailing: Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Tooltip(
                                message: httpResultOne,
                                child: Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                              ),
                              SizedBox(width: 10),
                              Tooltip(
                                message: httpResultTwo,
                                child: Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        checkListItems[i] = ListTile(
                          title: Text('Csapat $i'),
                          trailing: Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Tooltip(
                                message: httpResultOne,
                                child: Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                              ),
                              SizedBox(width: 10),
                              Tooltip(
                                message: httpResultTwo,
                                child: Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    } else {
                      if (httpResultTwo == 'OK') {
                        checkListItems[i] = ListTile(
                          title: Text('Csapat $i'),
                          trailing: Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Tooltip(
                                message: httpResultOne,
                                child: Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              ),
                              SizedBox(width: 10),
                              Tooltip(
                                message: httpResultTwo,
                                child: Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        checkListItems[i] = ListTile(
                          title: Text('Csapat $i'),
                          trailing: Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Tooltip(
                                message: httpResultOne,
                                child: Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              ),
                              SizedBox(width: 10),
                              Tooltip(
                                message: httpResultTwo,
                                child: Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
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

                List<String> results = resultMap.values.toList();
                List<String> okTeams = resultMap.entries
                    .where((element) => element.value == 'OK')
                    .map((e) => e.key)
                    .toList();
                print('ok teams: $okTeams');
                if (okTeams.length == 0) {
                  showSimpleAlert(
                    context: context,
                    title: 'Hiba - Nem sikerült semmilyen kapcsolat...',
                    content:
                        'Azért a saját csapatodat el kellene érni, nem?\nValami nagyon furcsa hiba történhetett...\n\nMinden be van dugva? Jó helyre?\nMinden ip cím jól van beállítva?\n\nHa a hiba továbbra is fennáll szóljatok bátran!',
                  );
                  setState(() {
                    _btnWidget = Icon(Icons.checklist);
                    _isChecking = false;
                  });
                  return;
                }

                if (okTeams.length == 2 &&
                    okTeams.every((element) =>
                        element.startsWith('${globals.teamNumber}.'))) {
                  showSimpleAlert(
                    context: context,
                    title: 'Hiba - Csak a saját csapatba tudok csatlakozni...',
                    content:
                        'A saját csapatunkkal tudunk kommunikálni, ez már fél siker 😊\n\nSubnet mask jól lett beállítva?\nMinden be van dugva? Jó helyre? A saját switch össze van kötve a \'fő\' switchel?\n\nHa a hiba továbbra is fennáll szóljatok bátran!',
                  );
                  setState(() {
                    _statefulHint = Container(
                      constraints: BoxConstraints.expand(
                          height: MediaQuery.of(context).size.height * 0.6),
                      child: Image(
                        fit: BoxFit.scaleDown,
                        image: AssetImage('assets/03eszkozok/mainSw.jpg'),
                      ),
                    );
                    _btnWidget = Icon(Icons.checklist);
                    _isChecking = false;
                  });
                  return;
                }

                if (results.any((element) => element == 'TimeoutException') &&
                    results.every((element) =>
                        element == 'OK' || element == 'TimeoutException')) {
                  showSimpleAlert(
                    context: context,
                    title:
                        'Hiba - Nem sikerült minden csapattal a kommunikáció...',
                    content:
                        'Semmi gond, nagy valószínűséggel a hiba a másik csapatnál van, nem nálatok 😊\nVárjatok egy picit és próbáljátok újra!',
                  );
                  setState(() {
                    _btnWidget = Icon(Icons.checklist);
                    _isChecking = false;
                    showReading = true;
                  });
                  return;
                }

                if (results.any((element) => element.startsWith('Exception'))) {
                  String errors = results
                      .where((element) => element.startsWith('Exception'))
                      .toList()
                      .join('\n');
                  showSimpleAlert(
                    context: context,
                    title:
                        'Hiba - Feltehetőleg a gép nem csatlakozik a hálózatra',
                    content:
                        'Egy/Több bonyolult hibába ütköztem, de ez általában azt jelenti, hogy valamelyik kábel nincs jól bedugva...\n\nHa dupla ellenőrzés után is fennáll a hiba, akkor nyugodtan kérj segítséget!\n\nRészletek:\n$errors',
                  );
                  setState(() {
                    _btnWidget = Icon(Icons.checklist);
                    _isChecking = false;
                  });
                  return;
                }

                if (!results.every((element) => element == 'OK')) {
                  showSimpleAlert(
                    context: context,
                    title: 'Hiba - Nem tudom mi történik 😅',
                    content:
                        'Ezt a hibát nem kellene sohasem látni...\nHaladéktalanul szólj a játékvezetőnek!\n\nRészletek:\n$resultMap',
                  );
                  setState(() {
                    _btnWidget = Icon(Icons.checklist);
                    _isChecking = false;
                  });
                  return;
                }

                await Future.delayed(
                  Duration(
                    milliseconds: 1000,
                  ),
                );

                setState(() {
                  _btnWidget = Icon(Icons.checklist);
                  _isChecking = false;
                });

                globals.prefs.setDouble('currentStage', 3.3);
                globals.currentStage = 3.3;

                globals.stageThreeEnd = DateTime.now().millisecondsSinceEpoch;
                globals.prefs.setInt('stageThreeEnd', globals.stageThreeEnd);
                print('Timing ended for stage 3: ${globals.stageThreeEnd}');

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => StageThreeThree(),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 25),
          _checkList,
          SizedBox(height: 15),
          if (showReading) ReadingForQuickies(),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
