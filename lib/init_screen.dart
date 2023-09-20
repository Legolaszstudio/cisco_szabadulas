import 'package:flutter/material.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  TextEditingController _currServerUrlCtrl = TextEditingController();
  TextEditingController _gameServerUrlCtrl = TextEditingController();
  TextEditingController _teamNumberCtrl = TextEditingController();
  TextEditingController _pcNumberCtrl = TextEditingController(text: "1");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cisco Szabadulás Initial Screen - Please Configure"),
      ),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.75,
          child: ListView(children: [
            SizedBox(height: 10),
            TextFormField(
              controller: _currServerUrlCtrl,
              decoration: const InputDecoration(
                labelText: "Cisco Szabadulás Server URL (current)",
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _gameServerUrlCtrl,
              decoration: const InputDecoration(
                labelText: "Cisco Szabadulás Server URL (during game)",
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _teamNumberCtrl,
              decoration: const InputDecoration(
                labelText: "Csapatszám",
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _pcNumberCtrl,
              decoration: const InputDecoration(
                labelText: "Komputer szám",
              ),
            ),
            SizedBox(height: 25),
            IconButton(
              color: Colors.orange,
              onPressed: () {
                //TODO: Check if server url is valid
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Figyelem!"),
                    content: Text(
                      "Utolsó felhívás, helyesek az alábbi adatok?\n\nJelenlegi szerver url: ${_currServerUrlCtrl.text}\nJáték szerver url: ${_gameServerUrlCtrl.text}\nCsapatszám: ${_teamNumberCtrl.text}\nKomputer szám: ${_pcNumberCtrl.text}",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("OK"),
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
