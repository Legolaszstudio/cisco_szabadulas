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
  TextEditingController _teamName = TextEditingController();
  TextEditingController _interfaceName = TextEditingController(
    text: globals.networkInterface,
  );

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
            SizedBox(height: 10),
            TextFormField(
              controller: _teamName,
              decoration: const InputDecoration(
                labelText: 'Csapatnév',
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _interfaceName,
              decoration: const InputDecoration(
                labelText: 'Hálózati interfész',
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
                      'Helyesek az alábbi adatok?\n\nCsapatszám: ${_teamNumberCtrl.text}\nKomputer szám: ${_pcNumberCtrl.text}\nCsapatnév: ${_teamName.text}\nHálózati interfész: ${_interfaceName.text}',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          //TODO: Check firewall and other permissions
                          globals.teamNumber = int.parse(_teamNumberCtrl.text);
                          globals.prefs.setInt(
                            'teamNumber',
                            int.parse(_teamNumberCtrl.text),
                          );
                          globals.pcNumber = int.parse(_pcNumberCtrl.text);
                          globals.prefs.setInt(
                            'pcNumber',
                            int.parse(_pcNumberCtrl.text),
                          );

                          globals.teamName = _teamName.text;
                          globals.prefs.setString('teamName', _teamName.text);

                          globals.networkInterface = _interfaceName.text;
                          globals.prefs.setString(
                            'networkInterface',
                            _interfaceName.text,
                          );

                          globals.prefs.setDouble('currentStage', 0);
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
