import 'package:flutter/material.dart';

class CommandTutorial extends StatelessWidget {
  final String command;
  final String explanation;
  CommandTutorial(String this.command, String this.explanation, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
      child: Column(
        children: [
          Text(
            this.command,
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          Text(
            this.explanation,
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
