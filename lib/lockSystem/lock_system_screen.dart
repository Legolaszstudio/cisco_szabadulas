import 'package:cisco_szabadulas/helpers/debug_menu/debug_menu.dart';
import 'package:cisco_szabadulas/helpers/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'lock_system_websrv.dart';

List<int> connectionStatus = [];

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
    if (connectionStatus.length == 0)
      connectionStatus = List<int>.filled(
        globals.numberOfTeams!,
        0,
        growable: false,
      );
    startLockSystemWebSrv(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RawKeyboardListener(
        focusNode: FocusNode()..requestFocus(),
        onKey: (event) {
          if (event is RawKeyDownEvent && event.character == ' ')
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
                    for (int i = 0; i < topRowCount; i++)
                      Container(
                        decoration: BoxDecoration(
                          color: connectionStatus[i] == 0
                              ? Colors.red
                              : connectionStatus[i] == 1
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
                                'Csapat ${i + 1}',
                                style: TextStyle(fontSize: 50),
                              ),
                              Icon(
                                connectionStatus[i] == 0
                                    ? Icons.error
                                    : connectionStatus[i] == 1
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
                    for (int i = 0; i < bottomRowCount; i++)
                      Container(
                        decoration: BoxDecoration(
                          color: connectionStatus[i + topRowCount] == 0
                              ? Colors.red
                              : connectionStatus[i + topRowCount] == 1
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
                                'Csapat ${i + topRowCount + 1}',
                                style: TextStyle(fontSize: 50),
                              ),
                              Icon(
                                connectionStatus[i + topRowCount] == 0
                                    ? Icons.error
                                    : connectionStatus[i + topRowCount] == 1
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
