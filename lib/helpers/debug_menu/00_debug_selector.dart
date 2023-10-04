import 'package:cisco_szabadulas/helpers/debug_menu/01_general.dart';
import 'package:flutter/material.dart';

class DebugSelector extends StatelessWidget {
  const DebugSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        SizedBox(
          width: 250,
          child: TextButton(
            style: ButtonStyle(
              shadowColor: MaterialStateProperty.all(Colors.orange),
              side: MaterialStateProperty.all(
                BorderSide(color: Colors.orange),
              ),
            ),
            child: Text('General'),
            onPressed: () {
              showGeneralDebugMenu(context);
            },
          ),
        ),
      ],
    );
  }
}
