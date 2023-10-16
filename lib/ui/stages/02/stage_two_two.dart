import 'package:cisco_szabadulas/helpers/debug_menu/debug_menu.dart';
import 'package:flutter/material.dart';

/** End of stage two, wait for others */
class StageTwoTwo extends StatefulWidget {
  const StageTwoTwo({super.key});

  @override
  State<StageTwoTwo> createState() => _StageTwoTwoState();
}

class _StageTwoTwoState extends State<StageTwoTwo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text(
            'Cisco Szabadulás 2.2 - Második stádium készen 🎉',
          ),
          onDoubleTap: () {
            showDebugMenu();
          },
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Text(
              '''
Nagyon ügyes voltál, meg minden szépség.
''',
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
