import 'dart:convert';
import 'dart:io';
import 'package:cisco_szabadulas/helpers/debug_menu/debug_menu.dart';
import 'package:cisco_szabadulas/helpers/globals.dart' as globals;
import 'package:cisco_szabadulas/helpers/serial.dart';
import 'package:cisco_szabadulas/helpers/simple_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:serial_port_win32/serial_port_win32.dart';
import 'package:xterm/xterm.dart';

Process? serialPort;

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

  @override
  void dispose() {
    serialPort?.kill();
    super.dispose();
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
                        if (encoded.length == 1 && encoded[0] == 13) {
                          BufferLine lastLineTerminal =
                              terminal.lines[terminal.lines.length - 1];
                          String lastLineTerminalStr =
                              lastLineTerminal.getText();
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
                          print('Command to be sent: ${lastLineTerminalStr}\n');
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

                      await Future.delayed(Duration(seconds: 1));
                      serialPort!.stdin.writeln(' ');
                      serialPort!.stdin.writeln(' \n');
                      globals.routerInit = false;
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

                        terminal.textInput('enable');
                        terminal.keyInput(TerminalKey.returnKey);
                        terminal.textInput('conf t');
                        terminal.keyInput(TerminalKey.returnKey);
                        terminal.textInput('no ip domain-lookup');
                        terminal.keyInput(TerminalKey.returnKey);
                        terminal.textInput('line con 0');
                        terminal.keyInput(TerminalKey.returnKey);
                        terminal.textInput('logging synchronous');
                        terminal.keyInput(TerminalKey.returnKey);
                        terminal.textInput('end');
                        terminal.keyInput(TerminalKey.returnKey);
                        terminal.textInput('exit');
                        terminal.keyInput(TerminalKey.returnKey);
                        terminal.keyInput(TerminalKey.returnKey);

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
              : SizedBox(),
          SizedBox(height: 30),
          FractionallySizedBox(
            widthFactor: 0.8,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: TerminalView(
                terminal,
                controller: terminalController,
                autofocus: true,
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
        ],
      ),
    );
  }
}
