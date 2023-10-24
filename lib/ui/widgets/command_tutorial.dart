import 'package:flutter/material.dart';

class CommandTutorial extends StatelessWidget {
  final String command;
  final String explanation;
  CommandTutorial(String this.command, String this.explanation)
      : super(key: ValueKey<String>(command + explanation));

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.5,
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
        child: Column(
          children: [
            SelectableText(
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
      ),
    );
  }
}
