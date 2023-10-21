import 'package:flutter/material.dart';
import 'package:cisco_szabadulas/helpers/globals.dart' as globals;

TextEditingController _stageOneStartCtrl = TextEditingController();
TextEditingController _stageOneTimeCtrl = TextEditingController();
TextEditingController _stageTwoStartCtrl = TextEditingController();
TextEditingController _stageTwoTimeCtrl = TextEditingController();

void showTimingsDebugMenu(BuildContext context) {
  _stageOneStartCtrl.text = globals.stageOneStart.toString();
  _stageOneTimeCtrl.text =
      (globals.stageOneEnd - globals.stageOneStart).toString();

  _stageTwoStartCtrl.text = globals.stageTwoStart.toString();
  _stageTwoTimeCtrl.text =
      (globals.stageTwoEnd - globals.stageTwoStart).toString();

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
        ],
      ),
    );
  }
}
