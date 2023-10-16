import 'package:flutter/material.dart';

void showStageOneDebugMenu(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Stage One Debug Menu'),
      content: StageOneDebugMenu(),
      actions: [
        TextButton(
          onPressed: () {
            //TODO allow to redeploy 'emails'
            //TODO changes to save here
            Navigator.of(context).pop();
          },
          child: Text('Mentés'),
        ),
      ],
    ),
  );
}

class StageOneDebugMenu extends StatefulWidget {
  const StageOneDebugMenu({super.key});

  @override
  State<StageOneDebugMenu> createState() => _StageOneDebugMenuState();
}

class _StageOneDebugMenuState extends State<StageOneDebugMenu> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
