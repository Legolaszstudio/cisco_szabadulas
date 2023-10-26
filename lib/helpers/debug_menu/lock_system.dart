import 'package:flutter/material.dart';
import 'package:cisco_szabadulas/helpers/globals.dart' as globals;
import 'package:cisco_szabadulas/lockSystem/lock_system_screen.dart'
    as ls_screen;
import 'package:loader_overlay/loader_overlay.dart';

void showLockSystemDebugMenu(BuildContext context, Function? setStateCallback) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Lock System Debug Menu'),
      content: LockSystemDebugMenu(setStateCallback),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('OK'),
        ),
      ],
    ),
  );
}

class LockSystemDebugMenu extends StatefulWidget {
  final Function? setStateCallback;
  LockSystemDebugMenu(this.setStateCallback, {super.key});

  @override
  State<LockSystemDebugMenu> createState() => _LockSystemDebugMenuState();
}

class _LockSystemDebugMenuState extends State<LockSystemDebugMenu> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        SizedBox(
          width: 250,
          child: TextButton(
            style: ButtonStyle(
              shadowColor: MaterialStateProperty.all(Colors.orange),
              side: MaterialStateProperty.all(
                BorderSide(color: Colors.orange),
              ),
            ),
            child: Text('Reset Timing Info'),
            onPressed: () async {
              context.loaderOverlay.show();
              await globals.prefs.setString('timingData', '{}');
              globals.timingData = {};
              ls_screen.connectionStatus = List.filled(
                globals.numberOfTeams!,
                0,
                growable: false,
              );

              widget.setStateCallback!();
              context.loaderOverlay.hide();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 3),
                  backgroundColor: Colors.green,
                  content: Text('Reset timing info!'),
                ),
              );
              Navigator.of(context).pop();
            },
          ),
        ),
        for (int i = 0; i < globals.numberOfTeams!; i++)
          CheckboxListTile(
            title: Text('Ignore Team ${i + 1}'),
            value: ls_screen.connectionStatus[i] == -1,
            onChanged: (newValue) {
              if (newValue!) {
                ls_screen.connectionStatus[i] = -1;
              } else {
                ls_screen.connectionStatus[i] = 0;
              }
              setState(() {});
              if (widget.setStateCallback != null) widget.setStateCallback!();
            },
          ),
      ]),
    );
  }
}
