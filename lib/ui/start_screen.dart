import 'package:cisco_szabadulas/helpers/debug_menu/debug_menu.dart';
import 'package:cisco_szabadulas/ui/stages/stage_one.dart';
import 'package:flutter/material.dart';
import '../helpers/globals.dart' as globals;

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text('Cisco Szabadulás - Rajthoz!'),
          onDoubleTap: () {
            showDebugMenu();
          },
        ),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              globals.teamNumber.toString() + '.',
              style: const TextStyle(fontSize: 200),
              textAlign: TextAlign.center,
            ),
            Text(
              'csapat (${globals.pcNumber.toString()}. gép)',
              style: const TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),
            FractionallySizedBox(
              widthFactor: 0.5,
              child: IconButton.filled(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Figyelem!'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('A kezdés után nincsen visszaút!'),
                          Text(
                            'Csak akkor indítsd el a játékot, ha szóltunk!',
                            style: TextStyle(color: Colors.red),
                          )
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Mégse'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            globals.currentStage = 1;
                            globals.prefs.setInt('currentStage', 1);
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => StageOne(),
                              ),
                            );
                          },
                          child: Text(
                            'Irány a játék!',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.local_play_rounded),
                    SizedBox(width: 10),
                    Text(
                      'Irány a játék!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
