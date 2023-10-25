import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cisco_szabadulas/helpers/check_conf/http_client.dart';
import 'package:cisco_szabadulas/helpers/cidrToMask.dart';
import 'package:cisco_szabadulas/helpers/debug_menu/debug_menu.dart';
import 'package:cisco_szabadulas/helpers/globals.dart' as globals;
import 'package:cisco_szabadulas/helpers/serial.dart';
import 'package:cisco_szabadulas/helpers/simple_alert.dart';
import 'package:cisco_szabadulas/ui/stages/04/stage_four_three.dart';
import 'package:cisco_szabadulas/ui/widgets/command_tutorial.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:serial_port_win32/serial_port_win32.dart';
import 'package:xterm/xterm.dart';

Process? serialPort;
bool checkConfRanOnce = false;
bool stageComplete = false;
late String commandToConfigure;
void setCommandCallback(String cmd) {
  commandToConfigure = cmd;
}

List<CommandTutorial> stepsToConfigure = [
  CommandTutorial(
    'enable',
    'Belépni rendszergazda módba, a router neve után megjelenik egy #-t.\nEzt általában jelszóval le szoktuk védeni, de most az egyszerűség kedvéért nem.',
    setCommandCallback,
  ),
  CommandTutorial(
    'configure terminal',
    'Konfigurációs módba lépni, a router neve után megjelenik, hogy (config)#.\nItt tudjuk beállítani a router legfontosabb dolgait.',
    setCommandCallback,
  ),
  CommandTutorial(
    'interface fastEthernet 0/0',
    'Válasszuk ki az első gépnek az interfészjét, ezzel fogjuk a belső hálózatot szimulálni.\nA router neve után megjelenik egy (config-if)#.',
    setCommandCallback,
  ),
  CommandTutorial(
    'ip address 192.168.${globals.teamNumber}.254 255.255.255.0',
    'Állítsuk be ezen a porton mi lesz a router címe.\nHa egy hálózatban 1db router van, akkor vagy az első, vagy az utolsó címet szokás neki adni.\nMivel az első cím már a gépünké, ezért az utolsót használjuk.',
    setCommandCallback,
  ),
  CommandTutorial(
    'no shutdown',
    'Mivel alapból ki van kapcsolva ez a port, hogy gonosz emberek ne dugjanak bele semmit, ezért be kell kapcsolni.\nAzaz nem kikapcsolni. 🙃',
    setCommandCallback,
  ),
  CommandTutorial(
    'interface fastEthernet 0/1',
    'Válasszuk ki a másik az interfészt, ezzel fogjuk az ajtónyító hálózatot szimulálni.',
    setCommandCallback,
  ),
  CommandTutorial(
    'ip address 10.10.10.${globals.teamNumber} 255.255.255.0',
    'Állítsuk be ezen a porton is a címet, mivel itt több router is van, a csapatunk számát adjuk meg a router címének.',
    setCommandCallback,
  ),
  CommandTutorial(
    'no shutdown',
    'Mivel alapból ki van kapcsolva ez a port is, hogy gonosz emberek ebbe se dugjanak bele semmit, ezért be kell kapcsolni.\nAzaz nem kikapcsolni. 🙃',
    setCommandCallback,
  ),
  CommandTutorial(
    'exit',
    'Lépjünk vissza ki a konfigurációs módba. A router neve után \'(config)#\' található.',
    setCommandCallback,
  ),
  CommandTutorial(
    'ip route 0.0.0.0 0.0.0.0 10.10.10.254',
    'Állítsuk be, hogy majd élesben a routerünk az ismeretlen adatokat az utolsó címre továbbítsa, mivel a Petrikben a fő router mindig az utolsó címen van.',
    setCommandCallback,
  ),
  CommandTutorial(
    'exit',
    'Lépjünk vissza ki admin módba. A router neve után már csak egy \'#\' található.',
    setCommandCallback,
  ),
  CommandTutorial(
    'show ip interface brief',
    'Nézzük meg, hogy minden cím és kapcsolat jó-e.\nHa az összekötetés jó akkor a sorok végén azt kell látni, hogy \'up up\'\nFastEthernet 0/0 192.168.${globals.teamNumber}.254\nFastEthernet 0/1 10.10.10.${globals.teamNumber}',
    setCommandCallback,
  ),
  CommandTutorial(
    'Hiba esetén',
    'Ismételjük meg az ip address konfigurációt a megfelelő \'interface\'-en a helyes címmel.',
    setCommandCallback,
  ),
  CommandTutorial(
    'show ip route | include last resort',
    'Nézzük meg, hogy tényleg az átjáró tényleg a fő router (10.10.10.254)',
    setCommandCallback,
  ),
  CommandTutorial(
    'Hiba esetén',
    'Töröljük ki a hibás útvonalat a \'no ip route ...\' paranccsal (... helyére a rossz címeket helyetessítsétek be).\nMajd újra futassuk le az \'ip route\' parancsot a helyes címmel.',
    setCommandCallback,
  ),
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
  int stepBefore = 0;

  @override
  void initState() {
    currentStep = 0;
    commandToConfigure = '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (globals.pcNumber != 1) {
        terminal.write('\Ez most nem működik\n');
        terminal.write('\rA másik gépen tudjátok a routert beállítani.\n');
        terminal.write('\r\n');
        terminal.write(
          '\rHa a másik gépen sikerült a routert beállítani, akkor itt is tovább fogtok tudni lépni\n\r',
        );
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

  void nextStageDialog() {
    globals.stageFourEnd = DateTime.now().millisecondsSinceEpoch;
    globals.prefs.setInt('stageFourEnd', globals.stageFourEnd);
    print('Timing ended for stage 4: ${globals.stageFourEnd}');
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sikeres router konfiguráció 🎉'),
        content: Text('Nagyon ügyesek vagytok, ez volt a legnehezebb rész.'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              globals.currentStage = 4.3;
              globals.prefs.setDouble('currentStage', 4.3);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => StageFourThree(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> checkConfiguration() async {
    deleteLastLine();
    deleteLastLine();
    await Future.delayed(Duration(seconds: 3));
    deleteLastLine();
    sendCommand('show ip interface brief | include 0/0 ');
    await Future.delayed(Duration(seconds: 1));
    List<String> fa00 = terminal.lines[terminal.lines.length - 2]
        .getText()
        .replaceAll(RegExp(r'[ ]{2,}'), ' ')
        .split(' ');
    await Future.delayed(Duration(seconds: 1));
    sendCommand('show ip interface brief | include 0/1 ');
    await Future.delayed(Duration(seconds: 1));
    List<String> fa01 = terminal.lines[terminal.lines.length - 2]
        .getText()
        .replaceAll(RegExp(r'[ ]{2,}'), ' ')
        .split(' ');

    if (fa00.length != 7 ||
        fa01.length != 7 ||
        fa00[0] != 'FastEthernet0/0' ||
        fa01[0] != 'FastEthernet0/1') {
      showSimpleAlert(
        context: context,
        title: 'Hiba - Érvénytelen konfigurációs választ kaptam',
        content:
            'Próbáljátok meg mégegyszer, ha továbbra sem megy, akkor szóljatok a játékvezetőnek lécci 🥺',
      );
      context.loaderOverlay.hide();
      return;
    }

    if (fa00[1] != '192.168.${globals.teamNumber}.254' &&
        !globals.override_router_ip_check) {
      showSimpleAlert(
        context: context,
        title: 'Hiba - Nem jó címet konfiguráltál az f0/0 interfészen',
        content:
            'Semmi gond, nagy valószínúséggel csak elgépeltél valamit;\n\nA cím amit beállítottál: ${fa00[1]}\nA cím amit be kellett volna állítani: 192.168.${globals.teamNumber}.254\n\nHa dupla ellenőrzés után is fennáll a hiba, akkor nyugodtan kérj segítséget!',
      );
      context.loaderOverlay.hide();
      return;
    }

    if (fa01[1] != '10.10.10.${globals.teamNumber}' &&
        !globals.override_router_ip_check) {
      showSimpleAlert(
        context: context,
        title: 'Hiba - Nem jó címet konfiguráltál az f0/1 interfészen',
        content:
            'Semmi gond, nagy valószínúséggel csak elgépeltél valamit;\n\nA cím amit beállítottál: ${fa01[1]}\nA cím amit be kellett volna állítani: 10.10.10.${globals.teamNumber}\n\nHa dupla ellenőrzés után is fennáll a hiba, akkor nyugodtan kérj segítséget!',
      );
      context.loaderOverlay.hide();
      return;
    }

    deleteLastLine();
    sendCommand('show ip interface f0/0 | include Internet');
    await Future.delayed(Duration(seconds: 1));
    List<String> fa00Mask =
        terminal.lines[terminal.lines.length - 2].getText().split('/');
    await Future.delayed(Duration(seconds: 1));
    sendCommand('show ip interface f0/1 | include Internet');
    await Future.delayed(Duration(seconds: 1));
    List<String> fa01Mask =
        terminal.lines[terminal.lines.length - 2].getText().split('/');

    if (fa00Mask.length != 2 || fa01Mask.length != 2) {
      showSimpleAlert(
        context: context,
        title: 'Hiba - Érvénytelen konfigurációs választ kaptam',
        content:
            'Próbáljátok meg mégegyszer, ha továbbra sem megy, akkor szóljatok a játékvezetőnek lécci 🥺',
      );
      context.loaderOverlay.hide();
      return;
    }

    if (fa00Mask[1] != '24' && !globals.override_router_mask_check) {
      showSimpleAlert(
        context: context,
        title: 'Hiba - Hibás maszkot konfiguráltál az f0/0 interfészen',
        content:
            'Semmi gond, nagy valószínúséggel csak elgépeltél valamit;\n\nA mask amit beállítottál: ${cidrToMask(fa00Mask[1])}\nA mask amit be kellett volna állítani: 255.255.255.0\n\nHa dupla ellenőrzés után is fennáll a hiba, akkor nyugodtan kérj segítséget!',
      );
      context.loaderOverlay.hide();
      return;
    }

    if (fa01Mask[1] != '24' && !globals.override_router_mask_check) {
      showSimpleAlert(
        context: context,
        title: 'Hiba - Hibás maszkot konfiguráltál az f0/0 interfészen',
        content:
            'Semmi gond, nagy valószínúséggel csak elgépeltél valamit;\n\nA mask amit beállítottál: ${cidrToMask(fa00Mask[1])}\nA mask amit be kellett volna állítani: 255.255.255.0\n\nHa dupla ellenőrzés után is fennáll a hiba, akkor nyugodtan kérj segítséget!',
      );
      context.loaderOverlay.hide();
      return;
    }

    if (fa00[4] != 'up' && !globals.override_router_sh_check) {
      showSimpleAlert(
        context: context,
        title: 'Hiba - Az f0/0 interfész nincs bekapcsolva',
        content:
            'Semmi gond, nagy valószínúséggel csak kimaradt a \'no shutdown\'\n\nHa dupla ellenőrzés után is fennáll a hiba, akkor nyugodtan kérj segítséget!',
      );
      context.loaderOverlay.hide();
      return;
    }

    if (fa01[4] != 'up' && !globals.override_router_sh_check) {
      showSimpleAlert(
        context: context,
        title: 'Hiba - Az f0/1 interfész nincs bekapcsolva',
        content:
            'Semmi gond, nagy valószínúséggel csak kimaradt a \'no shutdown\'\n\nHa dupla ellenőrzés után is fennáll a hiba, akkor nyugodtan kérj segítséget!',
      );
      context.loaderOverlay.hide();
      return;
    }

    if (fa00[5] != 'up' && !globals.override_router_proto_check) {
      showSimpleAlert(
        context: context,
        title: 'Hiba - Az f0/0 interfész nincs bekötve',
        content:
            'Minden kábel jól be van dugva?\n\nHa dupla ellenőrzés után is fennáll a hiba, akkor nyugodtan kérj segítséget!',
      );
      context.loaderOverlay.hide();
      return;
    }

    if (fa01[5] != 'up' && !globals.override_router_proto_check) {
      showSimpleAlert(
        context: context,
        title: 'Hiba - Az f0/1 interfész nincs bekötve',
        content:
            'Minden kábel jól be van dugva?\n\nHa dupla ellenőrzés után is fennáll a hiba, akkor nyugodtan kérj segítséget!',
      );
      context.loaderOverlay.hide();
      return;
    }

    deleteLastLine();
    sendCommand('ena');
    sendCommand('show run | include ip route');
    await Future.delayed(Duration(seconds: 3));
    int lastI = 1;
    String lastLine = terminal.lines[terminal.lines.length - lastI].getText();
    while (!lastLine.contains('show run') && lastI < 10) {
      lastI++;
      lastLine = terminal.lines[terminal.lines.length - lastI].getText();
    }

    if (lastI != 3 && !globals.override_router_gw_check) {
      showSimpleAlert(
        context: context,
        title: 'Hiba - Valami nem stimmel az átjárókkal',
        content:
            '${lastI > 3 ? "Túl sok van beállítva.\nÚgy tudod kitörölni az összeset, hogy 'no ip route 0.0.0.0 0.0.0.0', és akkor újra tudsz próbálkozni" : "Nincsen egy sem beállítva."}\n\nHa dupla ellenőrzés után is fennáll a hiba, akkor nyugodtan kérj segítséget!',
      );
      context.loaderOverlay.hide();
      return;
    }

    List<String> gwRoute =
        terminal.lines[terminal.lines.length - 2].getText().split(' ');
    if ((gwRoute[2] != '0.0.0.0' || gwRoute[3] != '0.0.0.0') &&
        !globals.override_router_gw_check) {
      showSimpleAlert(
        context: context,
        title: 'Hiba - Ez nem egy \'Last Resort\' átjáró',
        content:
            'Ez az útvonal nem fog minden csomagot elkapni.\nA \'no ip route ${gwRoute[2]} ${gwRoute[3]}\' parancs segítségével ki tudod törölni ezt a hibás útvonalat, majd újrapróbálkozni.\n\nHa dupla ellenőrzés után is fennáll a hiba, akkor nyugodtan kérj segítséget!',
      );
      context.loaderOverlay.hide();
      return;
    }

    if (gwRoute[4] != '10.10.10.254' && !globals.override_router_gw_check) {
      showSimpleAlert(
        context: context,
        title: 'Hiba - Hibás \'Last Resort\' átjáró cím',
        content:
            'Ugyan minden csomagot továbbítunk, de nem jó helyre.\n\nAhova továbbítja a csomagokat: ${gwRoute[4]}\nAhova kellene továbbítani a csomagokat: 10.10.10.254\n\nA \'no ip route ${gwRoute[2]} ${gwRoute[3]}\' parancs segítségével ki tudod törölni ezt a hibás útvonalat, majd újrapróbálkozni.\n\nHa dupla ellenőrzés után is fennáll a hiba, akkor nyugodtan kérj segítséget!',
      );
      context.loaderOverlay.hide();
      return;
    }

    bool httpCheckResult = await runHttpConnectivityCheck(
      context,
      destination: 'http://10.10.10.100/',
      stageNum: 4,
    );

    if (httpCheckResult == false) {
      context.loaderOverlay.hide();
      return; // Something is not right, httpcheck function should handle error messages
    }

    context.loaderOverlay.hide();

    stageComplete = true;
    serialPort!.kill();

    nextStageDialog();
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
                        if (stageComplete) return;
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
                        if (encoded.length == 1 &&
                            encoded[0] == 26 &&
                            globals.sanitizeInput) {
                          //CTRL+Z
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
                          if (lastLineTerminalStr == commandToConfigure) {
                            setState(() {
                              if (currentStep != stepsToConfigure.length - 1) {
                                currentStep++;
                              }
                            });
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
                          for (int i = 0; i <= 25; i++) {
                            await Future.delayed(Duration(milliseconds: 50));
                            terminal.keyInput(TerminalKey.returnKey);
                          }
                          return;
                        }

                        for (int i = 0; i <= 25; i++) {
                          await Future.delayed(Duration(milliseconds: 50));
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
                        serialPort!.stdin.writeln(' \n');
                        await Future.delayed(Duration(milliseconds: 1500));
                        for (int i = 0; i <= 30; i++) {
                          for (int j = 0; j <= Random().nextInt(5); j++) {
                            terminal.keyInput(TerminalKey.space);
                          }
                          await Future.delayed(Duration(milliseconds: 50));
                          terminal.keyInput(TerminalKey.returnKey);
                        }
                        serialPort!.stdin.writeln(' \n');
                      }

                      context.loaderOverlay.hide();
                    },
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Text(
                    'Most csak az első gépen van feladat.',
                    textAlign: TextAlign.center,
                  ),
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
          globals.pcNumber != 1
              ? FractionallySizedBox(
                  widthFactor: 0.25,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextButton.icon(
                      label: Text('Tovább'),
                      icon: Icon(Icons.checklist),
                      onPressed: () async {
                        context.loaderOverlay.show();
                        bool httpCheckResult = await runHttpConnectivityCheck(
                          context,
                          destination:
                              'http://192.168.${globals.teamNumber}.1/',
                          stageNum: 4,
                        );

                        if (httpCheckResult == false) {
                          context.loaderOverlay.hide();
                          return; // Something is not right, httpcheck function should handle error messages
                        }

                        context.loaderOverlay.hide();
                        nextStageDialog();
                      },
                    ),
                  ),
                )
              : SizedBox(),
          checkConfRanOnce
              ? FractionallySizedBox(
                  widthFactor: 0.25,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextButton.icon(
                      label: Text('Ellenőrzés futtatása'),
                      icon: Icon(Icons.checklist),
                      onPressed: () {
                        context.loaderOverlay.show();
                        checkConfRanOnce = true;
                        checkConfiguration();
                      },
                    ),
                  ),
                )
              : SizedBox(),
          SizedBox(height: 25),
          globals.pcNumber == 1 && plinkConnected
              ? Text(
                  'Az alábbi parancsokat segítségével kellene a routert működésre bírni: ${currentStep + 1}/${stepsToConfigure.length}',
                  textAlign: TextAlign.center,
                )
              : SizedBox(),
          SizedBox(height: 25),
          globals.pcNumber == 1 && plinkConnected
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
                              stepBefore = currentStep--;
                            }
                          });
                        },
                        child: Text('Vissza'),
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      child: stepsToConfigure[currentStep],
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                    FractionallySizedBox(
                      widthFactor: 0.2,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            if (currentStep == stepsToConfigure.length - 1) {
                              context.loaderOverlay.show();
                              checkConfRanOnce = true;
                              checkConfiguration();
                            } else {
                              stepBefore = currentStep++;
                            }
                          });
                        },
                        child: Text(
                          currentStep == stepsToConfigure.length - 1
                              ? 'Kész'
                              : 'Tovább',
                        ),
                      ),
                    ),
                  ],
                )
              : SizedBox(),
          SizedBox(height: 25),
          globals.pcNumber == 1 && plinkConnected
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Text(
                    'Parancsokat az ENTER lenyomásával lehet elküldeni.\nSegítséget a \'?\' gomb lenyomásával kaphatsz.\nHa elkezdesz gépelni egy parancsot, akkor azt a TAB lenyomásával be tudod fejezni.\n--More-- Többsoros kiírás esetén szóközzel lehet sorokat lépni, vagy ESC-vel kilépni.',
                    textAlign: TextAlign.center,
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
