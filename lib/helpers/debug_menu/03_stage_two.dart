import 'package:flutter/material.dart';

void showStageTwoDebugMenu(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Stage Two Debug Menu'),
      content: StageTwoDebugMenu(),
      actions: [
        TextButton(
          onPressed: () {
            //TODO changes to save here
            Navigator.of(context).pop();
          },
          child: Text('Mentés'),
        ),
      ],
    ),
  );
}

class StageTwoDebugMenu extends StatefulWidget {
  const StageTwoDebugMenu({super.key});

  @override
  State<StageTwoDebugMenu> createState() => _StageTwoDebugMenuState();
}

class _StageTwoDebugMenuState extends State<StageTwoDebugMenu> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
