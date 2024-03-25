import 'dart:math';

import 'package:cisco_szabadulas/helpers/debug_menu/debug_menu.dart';
import 'package:cisco_szabadulas/helpers/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ending_screen.dart';
import 'lock_system_websrv.dart';

Map<String, int> connectionStatus = {};

class LockSystemScreen extends StatefulWidget {
  const LockSystemScreen({super.key});

  @override
  State<LockSystemScreen> createState() => _LockSystemScreenState();
}

class _LockSystemScreenState extends State<LockSystemScreen> {
  int topRowCount = 0;
  int bottomRowCount = 0;

  @override
  void initState() {
    switch (globals.numberOfTeams) {
      case 1:
        topRowCount = 1;
        bottomRowCount = 0;
        break;
      case 2:
        topRowCount = 2;
        bottomRowCount = 0;
        break;
      case 3:
        topRowCount = 2;
        bottomRowCount = 1;
        break;
      case 4:
        topRowCount = 2;
        bottomRowCount = 2;
        break;
      case 5:
        topRowCount = 3;
        bottomRowCount = 2;
        break;
      case 6:
        topRowCount = 3;
        bottomRowCount = 3;
        break;
      case 7:
        topRowCount = 4;
        bottomRowCount = 3;
        break;
      case 8:
        topRowCount = 4;
        bottomRowCount = 4;
        break;
      case 9:
        topRowCount = 5;
        bottomRowCount = 4;
        break;
      case 10:
        topRowCount = 5;
        bottomRowCount = 5;
        break;
    }
    for (int i = 1; i <= globals.numberOfTeams!; i++) {
      connectionStatus['$i.1'] = 0;
      connectionStatus['$i.2'] = 0;
    }
    startLockSystemWebSrv(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!connectionStatus.values.any((element) => element == 0)) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        for (int i = 1; i <= globals.numberOfTeams!; i++) {
          if (connectionStatus['$i.1'] == -1) continue;
          if (connectionStatus['$i.2'] == -1) continue;
          String teamName = globals.timingData['$i.1']['teamName'] ??
              globals.timingData['$i.2']['teamName'];

          num avgTime = 0;
          if (globals.timingData['$i.1'] != null) {
            avgTime += globals.timingData['$i.1']['stageOneTime'];
            avgTime += globals.timingData['$i.1']['stageTwoTime'];
            avgTime += globals.timingData['$i.1']['stageThreeTime'];
            avgTime += globals.timingData['$i.1']['stageFourTime'];
            avgTime += globals.timingData['$i.1']['stageFiveTime'];
            avgTime += globals.timingData['$i.1']['stageFiveSectionOneTime'];
            avgTime /= 6;
          }

          num avgTime2 = 0;
          if (globals.timingData['$i.2'] != null) {
            avgTime2 += globals.timingData['$i.2']['stageOneTime'];
            avgTime2 += globals.timingData['$i.2']['stageTwoTime'];
            avgTime2 += globals.timingData['$i.2']['stageThreeTime'];
            avgTime2 += globals.timingData['$i.2']['stageFourTime'];
            avgTime2 += globals.timingData['$i.2']['stageFiveTime'];
            avgTime2 += globals.timingData['$i.2']['stageFiveSectionOneTime'];
            avgTime2 /= 6;
          }

          if (avgTime <= 0 && avgTime2 <= 0) {
            endingTimings[teamName] = null;
          } else if (avgTime <= 0 && avgTime2 >= 0) {
            endingTimings[teamName] = avgTime2;
          } else if (avgTime >= 0 && avgTime2 <= 0) {
            endingTimings[teamName] = avgTime;
          } else if (avgTime >= 0 && avgTime2 >= 0) {
            endingTimings[teamName] = min(avgTime, avgTime2);
          } else {
            endingTimings[teamName] = null;
          }

          print('Ending timings for team $i $teamName: $endingTimings');
        }
        await Future.delayed(Duration(seconds: 2));
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => EndingScreen(),
          ),
        );
      });
    }
    return Scaffold(
      body: KeyboardListener(
        focusNode: FocusNode()..requestFocus(),
        onKeyEvent: (event) {
          if (event is KeyDownEvent && event.character == ' ')
            showDebugMenu(setStateCallback: () {
              setState(() {
                print('Lock System setState called');
              });
            });
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height *
                    (bottomRowCount == 0 ? 1 : 0.5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int i = 1; i <= topRowCount; i++)
                      Container(
                        decoration: BoxDecoration(
                          color: (connectionStatus['$i.1'] == 0 &&
                                  connectionStatus['$i.2'] == 0)
                              ? Colors.red
                              : (connectionStatus['$i.1'] == 1 &&
                                      connectionStatus['$i.2'] == 1)
                                  ? Colors.green
                                  : Colors.grey,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        width: MediaQuery.of(context).size.width / topRowCount,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Csapat ${i}',
                                style: TextStyle(fontSize: 50),
                              ),
                              Text(
                                "${connectionStatus['${i}.1']! + connectionStatus['${i}.2']!} / 2",
                                style: TextStyle(fontSize: 50),
                              ),
                              Icon(
                                (connectionStatus['$i.1'] == 0 &&
                                        connectionStatus['$i.2'] == 0)
                                    ? Icons.error
                                    : (connectionStatus['$i.1'] == 1 &&
                                            connectionStatus['$i.2'] == 1)
                                        ? Icons.check
                                        : Icons.question_mark,
                                size: 50,
                              )
                            ],
                          ),
                        ),
                      )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height *
                    (bottomRowCount == 0 ? 0 : 0.5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int i = 1; i <= bottomRowCount; i++)
                      Container(
                        decoration: BoxDecoration(
                          color: (connectionStatus['${i + topRowCount}.1'] ==
                                      0 &&
                                  connectionStatus['${i + topRowCount}.2'] == 0)
                              ? Colors.red
                              : (connectionStatus['${i + topRowCount}.1'] ==
                                          1 &&
                                      connectionStatus[
                                              '${i + topRowCount}.2'] ==
                                          1)
                                  ? Colors.green
                                  : Colors.grey,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        width:
                            MediaQuery.of(context).size.width / bottomRowCount,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Csapat ${i + topRowCount}',
                                style: TextStyle(fontSize: 50),
                              ),
                              Text(
                                "${connectionStatus['${i + topRowCount}.1']! + connectionStatus['${i + topRowCount}.2']!} / 2",
                                style: TextStyle(fontSize: 50),
                              ),
                              Icon(
                                (connectionStatus['${i + topRowCount}.1'] ==
                                            0 &&
                                        connectionStatus[
                                                '${i + topRowCount}.2'] ==
                                            0)
                                    ? Icons.error
                                    : (connectionStatus[
                                                    '${i + topRowCount}.1'] ==
                                                1 &&
                                            connectionStatus[
                                                    '${i + topRowCount}.2'] ==
                                                1)
                                        ? Icons.check
                                        : Icons.question_mark,
                                size: 50,
                              )
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
