import 'package:cisco_szabadulas/helpers/debug_menu/debug_menu.dart';
import 'package:cisco_szabadulas/helpers/ms_to_human_str.dart';
import 'package:cisco_szabadulas/ui/stages/04/stage_four_zero.dart';
import 'package:flutter/material.dart';
import 'package:cisco_szabadulas/helpers/globals.dart' as globals;

class StageThreeThree extends StatefulWidget {
  const StageThreeThree({super.key});

  @override
  State<StageThreeThree> createState() => _StageThreeThreeState();
}

class _StageThreeThreeState extends State<StageThreeThree> {
  String _timeToCompleteStr = '00:00';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      int timeToComplete = globals.stageThreeEnd - globals.stageThreeStart;
      _timeToCompleteStr = msToHumanStr(timeToComplete);
      if (globals.stageThreeEnd == 0) {
        globals.stageThreeEnd = DateTime.now().millisecondsSinceEpoch;
        globals.prefs.setInt('stageThreeEnd', globals.stageThreeEnd);
        print('Timing ended for stage 3: ${globals.stageThreeEnd}');

        timeToComplete = globals.stageThreeEnd - globals.stageThreeStart;
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
            'Cisco Szabadulás 3.3 - Harmadik stádium készen 🎉',
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
Nagyon ügyes voltál, meg minden szépség. Ennyi idő volt kijutni a harmadik stádiumból: ${_timeToCompleteStr}
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
                          globals.currentStage = 4.0;
                          globals.prefs.setDouble('currentStage', 4.0);
                          globals.stageFourStart = 0;
                          globals.stageFourEnd = 0;
                          globals.prefs.setInt('stageFourEnd', 0);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => StageFour(),
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
          )
        ],
      ),
    );
  }
}
