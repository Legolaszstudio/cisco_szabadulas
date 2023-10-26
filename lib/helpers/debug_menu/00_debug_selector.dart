import 'package:cisco_szabadulas/helpers/debug_menu/lock_system.dart';

import '../globals.dart' as globals;
import 'package:cisco_szabadulas/helpers/debug_menu/01_general.dart';
import 'package:cisco_szabadulas/helpers/debug_menu/03_timings.dart';
import 'package:cisco_szabadulas/helpers/debug_menu/04_stage_one.dart';
import 'package:cisco_szabadulas/helpers/debug_menu/02_overrides.dart';
import 'package:cisco_szabadulas/helpers/debug_menu/05_stage_four.dart';
import 'package:flutter/material.dart';

class DebugSelector extends StatelessWidget {
  final Function? setStateCallback;
  DebugSelector({super.key, this.setStateCallback});

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
              child: Text('Overrides'),
              onPressed: () {
                showOverridesDebugMenu(context);
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
              child: Text('Timings'),
              onPressed: () {
                showTimingsDebugMenu(context);
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
              child: Text('Stage Four'),
              onPressed: () {
                showStageFourDebugMenu(context);
              },
            ),
          ),
          if (globals.teamNumber == -1) SizedBox(height: 10),
          if (globals.teamNumber == -1)
            SizedBox(
              width: 250,
              child: TextButton(
                style: ButtonStyle(
                  shadowColor: MaterialStateProperty.all(Colors.orange),
                  side: MaterialStateProperty.all(
                    BorderSide(color: Colors.orange),
                  ),
                ),
                child: Text('Lock system'),
                onPressed: () {
                  showLockSystemDebugMenu(context, setStateCallback);
                },
              ),
            ),
          //TODO: Factory default button (erase all prefs)
        ],
      ),
    );
  }
}
