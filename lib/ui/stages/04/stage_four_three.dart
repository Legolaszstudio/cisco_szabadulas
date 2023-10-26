import 'package:cisco_szabadulas/helpers/debug_menu/debug_menu.dart';
import 'package:cisco_szabadulas/helpers/ms_to_human_str.dart';
import 'package:cisco_szabadulas/ui/stages/05/stage_five_zero.dart';
import 'package:cisco_szabadulas/ui/widgets/reading_for_quickies.dart';
import 'package:flutter/material.dart';
import 'package:cisco_szabadulas/helpers/globals.dart' as globals;

class StageFourThree extends StatefulWidget {
  const StageFourThree({super.key});

  @override
  State<StageFourThree> createState() => _StageFourThreeState();
}

class _StageFourThreeState extends State<StageFourThree> {
  String _timeToCompleteStr = '00:00';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      int timeToComplete = globals.stageFourEnd - globals.stageFourStart;
      _timeToCompleteStr = msToHumanStr(timeToComplete);
      if (globals.stageFourEnd == 0) {
        globals.stageFourEnd = DateTime.now().millisecondsSinceEpoch;
        globals.prefs.setInt('stageFourEnd', globals.stageFourEnd);
        print('Timing ended for stage 4: ${globals.stageFourEnd}');

        timeToComplete = globals.stageFourEnd - globals.stageFourStart;
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
            'Cisco Szabadulás 4.3 - Negyedik stádium készen 🎉',
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
Nagyon tuti vagy 😎
Ennyi idő volt kijutni a negyedik stádiumból: ${_timeToCompleteStr}

Megvárjuk a többi csapatot, utána folytatjuk
''',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
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
                          globals.currentStage = 5.0;
                          globals.prefs.setDouble('currentStage', 5.0);
                          globals.stageFiveStart = 0;
                          globals.stageFiveEnd = 0;
                          globals.stageFiveSectionOneEnd = 0;
                          globals.prefs.setInt('stageFiveEnd', 0);
                          globals.prefs.setInt('stageFiveSectionOneEnd', 0);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => StageFive(),
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
          SizedBox(height: 15),
          ReadingForQuickies(),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
