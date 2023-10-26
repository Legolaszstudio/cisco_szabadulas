import 'package:flutter/material.dart';
import 'package:cisco_szabadulas/helpers/globals.dart' as globals;

TextEditingController _stageOneStartCtrl = TextEditingController();
TextEditingController _stageOneTimeCtrl = TextEditingController();
TextEditingController _stageTwoStartCtrl = TextEditingController();
TextEditingController _stageTwoTimeCtrl = TextEditingController();
TextEditingController _stageThreeStartCtrl = TextEditingController();
TextEditingController _stageThreeTimeCtrl = TextEditingController();
TextEditingController _stageFourStartCtrl = TextEditingController();
TextEditingController _stageFourTimeCtrl = TextEditingController();
TextEditingController _stageFiveStartCtrl = TextEditingController();
TextEditingController _stageFiveTimeCtrl = TextEditingController();
TextEditingController _stageFiveSectionOneTime = TextEditingController();

void showTimingsDebugMenu(BuildContext context) {
  _stageOneStartCtrl.text = globals.stageOneStart.toString();
  _stageOneTimeCtrl.text =
      (globals.stageOneEnd - globals.stageOneStart).toString();

  _stageTwoStartCtrl.text = globals.stageTwoStart.toString();
  _stageTwoTimeCtrl.text =
      (globals.stageTwoEnd - globals.stageTwoStart).toString();

  _stageThreeStartCtrl.text = globals.stageThreeStart.toString();
  _stageThreeTimeCtrl.text =
      (globals.stageThreeEnd - globals.stageThreeStart).toString();

  _stageFourStartCtrl.text = globals.stageFourStart.toString();
  _stageFourTimeCtrl.text =
      (globals.stageFourEnd - globals.stageFourStart).toString();

  _stageFiveStartCtrl.text = globals.stageFiveStart.toString();
  _stageFiveSectionOneTime.text =
      (globals.stageFiveSectionOneEnd - globals.stageFiveStart).toString();
  _stageFiveTimeCtrl.text =
      (globals.stageFiveEnd - globals.stageFiveStart).toString();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Timings Debug Menu'),
      content: TimingsDebugMenu(),
      actions: [
        TextButton(
          onPressed: () {
            // -------------------- Stage One ------------------------
            globals.prefs.setInt(
              'stageOneStart',
              int.parse(_stageOneStartCtrl.text),
            );
            globals.stageOneStart = int.parse(_stageOneStartCtrl.text);

            int stageOneEnd =
                globals.stageOneStart + int.parse(_stageOneTimeCtrl.text);
            globals.prefs.setInt('stageOneEnd', stageOneEnd);
            globals.stageOneEnd = stageOneEnd;

            // -------------------- Stage Two ------------------------
            globals.prefs.setInt(
              'stageTwoStart',
              int.parse(_stageTwoStartCtrl.text),
            );
            globals.stageTwoStart = int.parse(_stageTwoStartCtrl.text);

            int stageTwoEnd =
                globals.stageTwoStart + int.parse(_stageTwoTimeCtrl.text);
            globals.prefs.setInt('stageTwoEnd', stageTwoEnd);
            globals.stageTwoEnd = stageTwoEnd;

            // -------------------- Stage Three ------------------------
            globals.prefs.setInt(
              'stageThreeStart',
              int.parse(_stageThreeStartCtrl.text),
            );
            globals.stageThreeStart = int.parse(_stageThreeStartCtrl.text);

            int stageThreeEnd =
                globals.stageThreeStart + int.parse(_stageThreeTimeCtrl.text);
            globals.prefs.setInt('stageThreeEnd', stageThreeEnd);
            globals.stageThreeEnd = stageThreeEnd;

            // -------------------- Stage Four ------------------------
            globals.prefs.setInt(
              'stageFourStart',
              int.parse(_stageFourStartCtrl.text),
            );
            globals.stageFourStart = int.parse(_stageFourStartCtrl.text);

            int stageFourEnd =
                globals.stageFourStart + int.parse(_stageFourTimeCtrl.text);
            globals.prefs.setInt('stageFourEnd', stageFourEnd);
            globals.stageFourEnd = stageFourEnd;

            // -------------------- Stage Five ------------------------
            globals.prefs.setInt(
              'stageFiveStart',
              int.parse(_stageFiveStartCtrl.text),
            );
            globals.stageFiveStart = int.parse(_stageFiveStartCtrl.text);

            int stageFiveEnd =
                globals.stageFiveStart + int.parse(_stageFiveTimeCtrl.text);
            globals.prefs.setInt('stageFiveEnd', stageFiveEnd);
            globals.stageFiveEnd = stageFiveEnd;

            int stageFiveSectionOneEnd = globals.stageFiveStart +
                int.parse(_stageFiveSectionOneTime.text);
            globals.prefs.setInt(
              'stageFiveSectionOneEnd',
              stageFiveSectionOneEnd,
            );
            globals.stageFiveSectionOneEnd = stageFiveSectionOneEnd;

            Navigator.of(context).pop();
          },
          child: Text('OK'),
        ),
      ],
    ),
  );
}

class TimingsDebugMenu extends StatefulWidget {
  const TimingsDebugMenu({super.key});

  @override
  State<TimingsDebugMenu> createState() => _TimingsDebugMenuState();
}

class _TimingsDebugMenuState extends State<TimingsDebugMenu> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextFormField(
            controller: _stageOneStartCtrl,
            decoration: const InputDecoration(
              labelText: 'Stage 1 Start',
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _stageOneTimeCtrl,
            decoration: const InputDecoration(
              labelText: 'Stage 1 Time To Complete (ms)',
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _stageTwoStartCtrl,
            decoration: const InputDecoration(
              labelText: 'Stage 2 Start',
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _stageTwoTimeCtrl,
            decoration: const InputDecoration(
              labelText: 'Stage 2 Time To Complete (ms)',
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _stageThreeStartCtrl,
            decoration: const InputDecoration(
              labelText: 'Stage 3 Start',
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _stageThreeTimeCtrl,
            decoration: const InputDecoration(
              labelText: 'Stage 3 Time To Complete (ms)',
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _stageFourStartCtrl,
            decoration: const InputDecoration(
              labelText: 'Stage 4 Start',
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _stageFourTimeCtrl,
            decoration: const InputDecoration(
              labelText: 'Stage 4 Time To Complete (ms)',
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _stageFiveStartCtrl,
            decoration: const InputDecoration(
              labelText: 'Stage 5 Start',
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _stageFiveSectionOneTime,
            decoration: const InputDecoration(
              labelText: 'Stage 5 Section 1 Time To Complete (ms)',
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _stageFiveTimeCtrl,
            decoration: const InputDecoration(
              labelText: 'Stage 5 Time To Complete (ms)',
            ),
          ),
        ],
      ),
    );
  }
}
