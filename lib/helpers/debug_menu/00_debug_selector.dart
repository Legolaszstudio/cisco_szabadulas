import 'package:cisco_szabadulas/helpers/debug_menu/01_general.dart';
import 'package:cisco_szabadulas/helpers/debug_menu/02_stage_one.dart';
import 'package:cisco_szabadulas/helpers/debug_menu/03_stage_two.dart';
import 'package:flutter/material.dart';

class DebugSelector extends StatelessWidget {
  const DebugSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
          SizedBox(height: 10),
          SizedBox(
            width: 250,
            child: TextButton(
              style: ButtonStyle(
                shadowColor: MaterialStateProperty.all(Colors.orange),
                side: MaterialStateProperty.all(
                  BorderSide(color: Colors.orange),
                ),
              ),
              child: Text('Stage One'),
              onPressed: () {
                showStageOneDebugMenu(context);
              },
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 250,
            child: TextButton(
              style: ButtonStyle(
                shadowColor: MaterialStateProperty.all(Colors.orange),
                side: MaterialStateProperty.all(
                  BorderSide(color: Colors.orange),
                ),
              ),
              child: Text('Stage Two'),
              onPressed: () {
                showStageTwoDebugMenu(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
