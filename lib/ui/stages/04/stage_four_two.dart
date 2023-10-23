import 'dart:convert';
import 'dart:io';
import 'package:cisco_szabadulas/helpers/debug_menu/debug_menu.dart';
import 'package:cisco_szabadulas/helpers/globals.dart' as globals;
import 'package:cisco_szabadulas/helpers/serial.dart';
import 'package:cisco_szabadulas/helpers/simple_alert.dart';
import 'package:cisco_szabadulas/ui/widgets/command_tutorial.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:serial_port_win32/serial_port_win32.dart';
import 'package:xterm/xterm.dart';

Process? serialPort;
List<Widget> stepsToConfigure = [
  CommandTutorial('enable', 'Belépni rendszergazda módba'),
];

class StageFourTwo extends StatefulWidget {
  const StageFourTwo({super.key});

  @override
  State<StageFourTwo> createState() => _StageFourTwoState();
}

class _StageFourTwoState extends State<StageFourTwo> {
  final terminal = Terminal(
    maxLines: 10000,
  );
  final terminalController = TerminalController();
  String lastLine = '';
  bool plinkConnected = false;
  int currentStep = 0;

  @override
  void initState() {
    currentStep = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (globals.pcNumber != 1) {
        terminal.write('Ez most nem működik\n');
        terminal.write('A másik gépen tudjátok a routert beállítani.\n');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    serialPort?.kill();
    super.dispose();
  }

  void sendCommand(String cmd) {
    terminal.textInput(cmd);
    terminal.keyInput(TerminalKey.returnKey);
  }

  void deleteLastLine() {
    terminal.keyInput(TerminalKey.keyC, ctrl: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text(
            'Cisco Szabadulás 4.2 - Negyedik stádium (Több hálózat)',
          ),
          onDoubleTap: () {
            showDebugMenu();
          },
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(height: 30),
          globals.pcNumber == 1
              ? FractionallySizedBox(
                  widthFactor: 0.5,
                  child: TextButton.icon(
                    icon: Icon(
                      plinkConnected
                          ? Icons.check
                          : Icons.connect_without_contact,
                    ),
                    label: Text(plinkConnected
                        ? 'Csatlakozva'
                        : 'Csatlakozás a router-ra'),
                    onPressed: () async {
                      if (plinkConnected) return;
                      context.loaderOverlay.show();
                      final ports = SerialPort.getPortsWithFullMessages();
                      if (!ports.any(
                        (element) => element.portName == globals.comPort,
                      )) {
                        context.loaderOverlay.hide();
                        showSimpleAlert(
                          context: context,
                          title:
                              'Hiba - Nem található a ${globals.comPort} port',
                          content:
                              'Gyorsan szólj a játékvezetőnek!\nEgy pillanat és javítjuk, bocsi 🥺\n\nElérhető portok:\n\t-${ports.map((e) => "${e.portName} (${e.friendlyName})").join('\n\t-')}',
                        );
                        return;
                      }

                      // ignore: unnecessary_null_comparison
                      if (serialPort != null) {
                        serialPort?.kill();
                        await Future.delayed(Duration(seconds: 3));
                      }

                      serialPort = await connectSerial();

                      int exitCode = await serialPort!.exitCode.timeout(
                        Duration(seconds: 3),
                        onTimeout: () => -1,
                      );
                      if (exitCode != -1) {
                        context.loaderOverlay.hide();
                        showSimpleAlert(
                          context: context,
                          title: 'Hiba - Plink nem tud elindulni',
                          content:
                              'A plink soros kapcsolat összeomlott, lehet egy másik program már használja?\nSzólj a játékvezetőnek lécci 🥺\nExit code: $exitCode',
                        );
                        return;
                      }

                      setState(() {
                        plinkConnected = true;
                      });
                      serialPort!.exitCode.then((value) {
                        setState(() {
                          plinkConnected = false;
                        });

                        terminal.write(
                          '\nPlink.exe has crashed; exitCode: $value\n',
                        );
                        showSimpleAlert(
                          context: context,
                          title: 'Hiba - Plink összeomlott',
                          content: 'A plink soros kapcsolat összeomlott.',
                        );
                      });

                      terminal.onOutput = (data) {
                        List<int> encoded = utf8.encode(data);
                        String encodedStr = encoded.join(',');
                        if ('13,10'.allMatches(encodedStr).length > 1 &&
                            globals.sanitizeInput) {
                          terminal.write('\r\nMultilining is disabled!\n\r');
                          deleteLastLine();
                          return;
                        }
                        if (((encoded.length == 1 && encoded[0] == 13) ||
                                encodedStr.endsWith('13,10')) &&
                            globals.sanitizeInput) {
                          BufferLine lastLineTerminal =
                              terminal.lines[terminal.lines.length - 1];
                          String lastLineTerminalStr =
                              lastLineTerminal.getText();
                          if (encodedStr.endsWith('13,10')) {
                            lastLineTerminalStr += data;
                          }
                          String lastLineOg = lastLineTerminalStr;
                          if (lastLineTerminalStr.split('>').length > 1) {
                            lastLineTerminalStr = lastLineTerminalStr
                                .split('>')
                                .sublist(1)
                                .join('>');
                          }
                          if (lastLineTerminalStr.split('#').length > 1) {
                            lastLineTerminalStr = lastLineTerminalStr
                                .split('#')
                                .sublist(1)
                                .join('#');
                          }
                          lastLineTerminalStr = lastLineTerminalStr.trim();
                          print('Command to be sent: ${lastLineTerminalStr}\n');
                          if (isUnsafeCommand(
                            lastLineTerminalStr.toLowerCase(),
                            lastLineOg.toLowerCase(),
                            terminal,
                          )) {
                            deleteLastLine();
                            return;
                          }
                        }
                        serialPort!.stdin.write(
                          data,
                        );
                      };

                      lastLine = '';
                      serialPort!.stdout.listen((binData) {
                        String data = ascii.decode(binData);
                        terminal.write(data);
                        if (data.contains('\n') || data.contains('\r')) {
                          lastLine = '';
                        }
                        lastLine += data;
                      });

                      await Future.delayed(Duration(seconds: 2));
                      serialPort!.stdin.writeln(' ');
                      serialPort!.stdin.writeln(' \n');
                      if (!globals.routerInit) {
                        serialPort!.stdin.writeln(' ');
                        await Future.delayed(Duration(seconds: 1));
                        serialPort!.stdin.writeln('no');
                        serialPort!.stdin.writeln(' \n');
                        await Future.delayed(Duration(seconds: 1));
                        print('Sent init commands');

                        await Future.delayed(Duration(seconds: 30));

                        int initTries = 0;
                        while (!(lastLine.contains('Router>') ||
                                lastLine.contains('Router#')) &&
                            initTries < 5) {
                          serialPort!.stdin.write(utf8.decode([13]));
                          await Future.delayed(Duration(seconds: 3));
                          print('Trying to init router, try #$initTries');
                          initTries++;
                        }

                        if (initTries >= 5) {
                          context.loaderOverlay.hide();
                          showSimpleAlert(
                            context: context,
                            title: 'Hiba - Router nem válaszol',
                            content:
                                'Nem sikerült a router-t inicializálni.\nSzólj a játékvezetőnek lécci 🥺',
                          );
                          for (int i = 0; i <= 20; i++) {
                            terminal.keyInput(TerminalKey.returnKey);
                          }
                          return;
                        }

                        for (int i = 0; i <= 20; i++) {
                          terminal.keyInput(TerminalKey.returnKey);
                        }

                        globals.sanitizeInput = false;
                        sendCommand('enable');
                        sendCommand('conf t');
                        sendCommand('no ip domain-lookup');
                        sendCommand(
                          'hostname Csapat${globals.teamNumber}Router',
                        );
                        sendCommand('line con 0');
                        sendCommand('logging synchronous');
                        sendCommand('no exec-timeout');
                        sendCommand('end');
                        sendCommand('exit');
                        terminal.keyInput(TerminalKey.returnKey);

                        globals.sanitizeInput = true;
                        globals.routerInit = true;
                        globals.prefs.setBool('routerInit', true);
                      } else {
                        for (int i = 0; i <= 20; i++) {
                          terminal.keyInput(TerminalKey.returnKey);
                        }
                      }

                      context.loaderOverlay.hide();
                    },
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Text('Most csak az első gépen van feladat.'),
                ),
          SizedBox(height: 30),
          FractionallySizedBox(
            widthFactor: 0.8,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: TerminalView(
                terminal,
                controller: terminalController,
                autofocus: true,
                readOnly: globals.pcNumber != 1,
                backgroundOpacity: 0.7,
                onSecondaryTapDown: (details, offset) async {
                  final selection = terminalController.selection;
                  if (selection != null) {
                    final text = terminal.buffer.getText(selection);
                    terminalController.clearSelection();
                    await Clipboard.setData(ClipboardData(text: text));
                  } else {
                    final data = await Clipboard.getData('text/plain');
                    final text = data?.text;
                    if (text != null) {
                      terminal.paste(text);
                    }
                  }
                },
              ),
            ),
          ),
          SizedBox(height: 25),
          globals.pcNumber == 1
              ? Text(
                  'Az alábbi parancsokat segítségével kellene a routert működésre bírni:',
                  textAlign: TextAlign.center,
                )
              : SizedBox(),
          SizedBox(height: 25),
          globals.pcNumber == 1
              ? Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    FractionallySizedBox(
                      widthFactor: 0.2,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            if (currentStep != 0) {
                              currentStep--;
                            }
                          });
                        },
                        child: Text('Vissza'),
                      ),
                    ),
                    stepsToConfigure[currentStep],
                    FractionallySizedBox(
                      widthFactor: 0.2,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            if (currentStep != stepsToConfigure.length - 1) {
                              currentStep++;
                            }
                          });
                        },
                        child: Text('Tovább'),
                      ),
                    ),
                  ],
                )
              : SizedBox(),
          SizedBox(height: 25),
          globals.pcNumber == 1
              ? Text(
                  'Parancsokat az ENTER lenyomásával lehet elküldeni.\nSegítséget a \'?\' gomb lenyomásával kaphatsz.\nHa elkezdesz gépelni egy parancsot, akkor azt a TAB lenyomásával be tudod fejezni.\n--More-- Többsoros kiírás esetén szóközzel lehet sorokat lépni, vagy ESC-vel kilépni.',
                  textAlign: TextAlign.center,
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
