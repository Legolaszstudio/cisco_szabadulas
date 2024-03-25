import 'package:cisco_szabadulas/helpers/check_conf/http_server.dart';
import 'package:cisco_szabadulas/helpers/simple_alert.dart';
import 'package:cisco_szabadulas/lockSystem/lock_system_screen.dart';
import 'package:cisco_szabadulas/ui/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:serial_port_win32/serial_port_win32.dart';
import '../helpers/globals.dart' as globals;

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  TextEditingController _teamNumberCtrl = TextEditingController();
  TextEditingController _pcNumberCtrl = TextEditingController(text: '1');
  TextEditingController _teamNameCtrl = TextEditingController();
  TextEditingController _interfaceNameCtrl = TextEditingController(
    text: globals.networkInterface,
  );
  TextEditingController _numberOfTeamsCtrl = TextEditingController(text: '4');
  TextEditingController _comPortCtrl = TextEditingController(text: 'COM3');

  @override
  void initState() {
    startServer('Testing').then((value) {
      globals.server = value;
      globals.httpServerVer = -1;
    });
    super.initState();
  }

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
              controller: _teamNameCtrl,
              decoration: const InputDecoration(
                labelText: 'Csapatnév',
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _interfaceNameCtrl,
              decoration: const InputDecoration(
                labelText: 'Hálózati interfész',
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _numberOfTeamsCtrl,
              decoration: const InputDecoration(
                labelText: 'Csapatok száma',
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _comPortCtrl,
              decoration: const InputDecoration(
                labelText: 'COM port',
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
                      'Helyesek az alábbi adatok?\n\nCsapatszám: ${_teamNumberCtrl.text}\nKomputer szám: ${_pcNumberCtrl.text}\nCsapatnév: ${_teamNameCtrl.text}\nHálózati interfész: ${_interfaceNameCtrl.text}\nCsapatok száma: ${_numberOfTeamsCtrl.text}\nCOM port: ${_comPortCtrl.text}',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          context.loaderOverlay.show();

                          if (globals.httpServerVer != 0) {
                            globals.server?.close();
                            globals.httpServerVer = 0;
                          }

                          globals.teamNumber = int.parse(_teamNumberCtrl.text);
                          globals.prefs.setInt(
                            'teamNumber',
                            int.parse(_teamNumberCtrl.text),
                          );

                          globals.numberOfTeams =
                              int.parse(_numberOfTeamsCtrl.text);
                          globals.prefs.setInt(
                            'numberOfTeams',
                            int.parse(_numberOfTeamsCtrl.text),
                          );

                          if (globals.teamNumber == -1) {
                            context.loaderOverlay.hide();

                            Navigator.of(context).pop();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => LockSystemScreen(),
                              ),
                            );
                            return;
                          }

                          final ports = SerialPort.getPortsWithFullMessages();
                          if (!ports.any(
                                (element) =>
                                    element.portName == _comPortCtrl.text,
                              ) &&
                              _pcNumberCtrl.text == '1') {
                            showSimpleAlert(
                              context: context,
                              title:
                                  'Hiba - Nem található a ${globals.comPort} port',
                              content:
                                  'Elérhető portok:\n\t-${ports.map((e) => "${e.portName} (${e.friendlyName})").join('\n\t-')}',
                            );
                            context.loaderOverlay.hide();
                            return;
                          }

                          globals.pcNumber = int.parse(_pcNumberCtrl.text);
                          globals.prefs.setInt(
                            'pcNumber',
                            int.parse(_pcNumberCtrl.text),
                          );

                          globals.teamName = _teamNameCtrl.text;
                          globals.prefs
                              .setString('teamName', _teamNameCtrl.text);

                          globals.networkInterface = _interfaceNameCtrl.text;
                          globals.prefs.setString(
                            'networkInterface',
                            _interfaceNameCtrl.text,
                          );

                          globals.comPort = _comPortCtrl.text;
                          globals.prefs.setString(
                            'comPort',
                            _comPortCtrl.text,
                          );

                          globals.prefs.setDouble('currentStage', 0);
                          globals.currentStage = 0;

                          context.loaderOverlay.hide();

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
