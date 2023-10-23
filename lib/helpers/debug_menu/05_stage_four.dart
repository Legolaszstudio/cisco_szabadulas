import 'package:flutter/material.dart';
import '../globals.dart' as globals;

bool routerInit = false;

void showStageFourDebugMenu(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Stage Four Debug Menu'),
      content: StageFourDebugMenu(),
      actions: [
        TextButton(
          onPressed: () {
            globals.routerInit = routerInit;
            globals.prefs.setBool('routerInit', routerInit);
            Navigator.of(context).pop();
          },
          child: Text('OK'),
        ),
      ],
    ),
  );
}

class StageFourDebugMenu extends StatefulWidget {
  const StageFourDebugMenu({super.key});

  @override
  State<StageFourDebugMenu> createState() => _StageFourDebugMenuState();
}

class _StageFourDebugMenuState extends State<StageFourDebugMenu> {
  @override
  void initState() {
    routerInit = globals.routerInit;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CheckboxListTile(
            title: Text('Router Initialized'),
            value: routerInit,
            onChanged: (newValue) {
              setState(() {
                routerInit = newValue!;
              });
            },
          ),
        ],
      ),
    );
  }
}
