import 'package:flutter/material.dart';
import 'package:cisco_szabadulas/helpers/globals.dart' as globals;

TextEditingController _teamNumberCtrl = TextEditingController();
TextEditingController _pcNumberCtrl = TextEditingController();
TextEditingController _stageCtrl = TextEditingController();

void showGeneralDebugMenu(BuildContext context) {
  _teamNumberCtrl.text = globals.teamNumber.toString();
  _pcNumberCtrl.text = globals.pcNumber.toString();
  _stageCtrl.text = globals.currentStage.toString();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('General Debug Menu'),
      content: GeneralDebugMenu(),
      actions: [
        TextButton(
          onPressed: () {
            globals.prefs.setInt(
              'teamNumber',
              int.parse(_teamNumberCtrl.text),
            );
            globals.teamNumber = int.parse(_teamNumberCtrl.text);
            globals.prefs.setInt(
              'pcNumber',
              int.parse(_pcNumberCtrl.text),
            );
            globals.pcNumber = int.parse(_pcNumberCtrl.text);
            globals.prefs.setInt(
              'currentStage',
              int.parse(_stageCtrl.text),
            );
            globals.currentStage = int.parse(_stageCtrl.text);
            Navigator.of(context).pop();
          },
          child: Text('Mentés'),
        ),
      ],
    ),
  );
}

class GeneralDebugMenu extends StatefulWidget {
  const GeneralDebugMenu({super.key});

  @override
  State<GeneralDebugMenu> createState() => _GeneralDebugMenuState();
}

class _GeneralDebugMenuState extends State<GeneralDebugMenu> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextFormField(
            controller: _teamNumberCtrl,
            decoration: const InputDecoration(
              labelText: 'Csapatszám',
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _pcNumberCtrl,
            decoration: const InputDecoration(
              labelText: 'Komputer szám',
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _stageCtrl,
            decoration: const InputDecoration(
              labelText: 'Aktuális szint',
            ),
          ),
        ],
      ),
    );
  }
}
