import 'package:cisco_szabadulas/helpers/debug_menu/debug_menu.dart';
import 'package:cisco_szabadulas/helpers/ms_to_human_str.dart';
import 'package:cisco_szabadulas/ui/stages/03/stage_three_zero.dart';
import 'package:flutter/material.dart';
import 'package:cisco_szabadulas/helpers/globals.dart' as globals;

/** End of stage two, wait for others */
class StageTwoTwo extends StatefulWidget {
  const StageTwoTwo({super.key});

  @override
  State<StageTwoTwo> createState() => _StageTwoTwoState();
}

class _StageTwoTwoState extends State<StageTwoTwo> {
  String _timeToCompleteStr = '00:00';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      int timeToComplete = globals.stageTwoEnd - globals.stageTwoStart;
      _timeToCompleteStr = msToHumanStr(timeToComplete);
      if (globals.stageTwoEnd == 0) {
        globals.stageTwoEnd = DateTime.now().millisecondsSinceEpoch;
        globals.prefs.setInt('stageTwoEnd', globals.stageTwoEnd);
        print('Timing ended for stage 2: ${globals.stageTwoEnd}');

        timeToComplete = globals.stageTwoEnd - globals.stageTwoStart;
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
            'Cisco Szabadulás 2.2 - Második stádium készen 🎉',
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
Nagyon ügyes voltál, meg minden szépség. Ennyi idő volt kijutni a második stádiumból: ${_timeToCompleteStr}
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
                          globals.currentStage = 3.0;
                          globals.prefs.setDouble('currentStage', 3.0);
                          globals.stageThreeStart = 0;
                          globals.stageThreeEnd = 0;
                          globals.prefs.setInt('stageThreeEnd', 0);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => StageThree(),
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
