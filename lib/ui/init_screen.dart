import 'package:cisco_szabadulas/ui/start_screen.dart';
import 'package:flutter/material.dart';
import '../helpers/globals.dart' as globals;

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  TextEditingController _teamNumberCtrl = TextEditingController();
  TextEditingController _pcNumberCtrl = TextEditingController(text: '1');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cisco Szabadulás Initial Screen - Please Configure'),
      ),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.75,
          child: ListView(children: [
            SizedBox(height: 10),
            TextFormField(
              controller: _teamNumberCtrl,
              decoration: const InputDecoration(
                labelText: 'Csapatszám',
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _pcNumberCtrl,
              decoration: const InputDecoration(
                labelText: 'Komputer szám',
              ),
            ),
            SizedBox(height: 25),
            IconButton(
              color: Colors.orange,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Figyelem!'),
                    content: Text(
                      'Helyesek az alábbi adatok?\n\nCsapatszám: ${_teamNumberCtrl.text}\nKomputer szám: ${_pcNumberCtrl.text}',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          globals.prefs.setInt(
                            'teamNumber',
                            int.parse(_teamNumberCtrl.text),
                          );
                          globals.prefs.setInt(
                            'pcNumber',
                            int.parse(_pcNumberCtrl.text),
                          );

                          globals.prefs.setInt('currentStage', 0);
                          globals.currentStage = 0;

                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => StartScreen(),
                            ),
                          );
                        },
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.check),
            )
          ]),
        ),
      ),
    );
  }
}
