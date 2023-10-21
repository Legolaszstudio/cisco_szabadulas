import 'package:cisco_szabadulas/helpers/debug_menu/debug_menu.dart';
import 'package:cisco_szabadulas/helpers/ms_to_human_str.dart';
import 'package:cisco_szabadulas/ui/stages/02/stage_two_zero.dart';
import 'package:flutter/material.dart';
import 'package:cisco_szabadulas/helpers/globals.dart' as globals;

class StageOneTwo extends StatefulWidget {
  const StageOneTwo({super.key, required bool success});

  @override
  State<StageOneTwo> createState() => _StageOneTwoState();
}

class _StageOneTwoState extends State<StageOneTwo> {
  String _timeToCompleteStr = '00:00';

  @override
  void initState() {
    int timeToComplete = globals.stageOneEnd - globals.stageOneStart;
    _timeToCompleteStr = msToHumanStr(timeToComplete);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (globals.stageOneEnd == 0) {
        globals.stageOneEnd = DateTime.now().millisecondsSinceEpoch;
        globals.prefs.setInt('stageOneEnd', globals.stageOneEnd);
        print('Timing ended for stage 1: ${globals.stageOneEnd}');

        timeToComplete = globals.stageOneEnd - globals.stageOneStart;
      }
      setState(() {
        _timeToCompleteStr = msToHumanStr(timeToComplete);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text(
            'Cisco Szabadulás 1.2 - Első stádium készen 🎉',
          ),
          onDoubleTap: () {
            showDebugMenu();
          },
        ),
      ),
      body: ListView(
        children: [
          //TODO: Felhasználni a success attributot
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Text(
              '''
Nagyon ügyes voltál, meg minden szépség. Ennyi idő volt kijutni az első stádiumból: ${_timeToCompleteStr}
''',
            ),
          ),
          SizedBox(height: 10),
          FractionallySizedBox(
            widthFactor: 0.5,
            child: TextButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Figyelem!'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('A kezdés után nincsen visszaút!'),
                        Text(
                          'Csak akkor lépj tovább, ha szóltunk!',
                          style: TextStyle(color: Colors.red),
                        )
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Mégse'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          globals.currentStage = 2.0;
                          globals.prefs.setDouble('currentStage', 2.0);
                          globals.stageTwoStart = 0;
                          globals.stageTwoEnd = 0;
                          globals.prefs.setInt('stageTwoEnd', 0);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => StageTwo(),
                            ),
                          );
                        },
                        child: Text(
                          'Irány a következő stádium!',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.next_plan),
              label: Text('Következő'),
            ),
          ),
        ],
      ),
    );
  }
}
