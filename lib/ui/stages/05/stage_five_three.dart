import 'dart:io';
import 'package:cisco_szabadulas/helpers/debug_menu/debug_menu.dart';
import 'package:cisco_szabadulas/ui/stages/05/the_end.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';
import 'package:cisco_szabadulas/helpers/globals.dart' as globals;
import 'stage_five_three_websrv.dart';

class StageFiveThree extends StatefulWidget {
  const StageFiveThree({super.key});

  @override
  State<StageFiveThree> createState() => _StageFiveThreeState();
}

class _StageFiveThreeState extends State<StageFiveThree>
    with TickerProviderStateMixin {
  late AnimationController blinkController;
  double fade(double value) =>
      2 * (0.5 - (0.5 - Curves.linear.transform(value)).abs());
  late AnimationController progressController;
  late AnimationController fadeOutController;
  late AnimationController fadeInController;

  void endCallback() {
    globals.currentStage = 5.4;
    globals.prefs.setDouble('currentStage', 5.4);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => TheEnd()),
    );
  }

  @override
  void initState() {
    setWindowTitle('Cisco Szabadulás - Ötödik stádium');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (globals.httpServerVer != 0) {
        await globals.server?.close();
      }
      startStageFiveThreeWebSrv(endCallback);
    });
    super.initState();
    blinkController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )
      ..forward()
      ..addListener(() {
        if (blinkController.isCompleted) {
          blinkController.repeat();
        }
      });
    progressController = AnimationController(
      duration: Duration(seconds: 15),
      vsync: this,
    )
      ..forward()
      ..addListener(() async {
        setState(() {});
        if (progressController.isCompleted) {
          await Future.delayed(Duration(seconds: 2));
          fadeOutController.forward();
        }
      });
    fadeOutController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    )..addListener(() {
        setState(() {});
        if (fadeOutController.isCompleted) {
          print('Start fade in');
          fadeInController.forward();
        }
      });
    fadeInController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });
    ;
  }

  @override
  void dispose() {
    blinkController.dispose();
    progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text(
            'Cisco Szabadulás 5.3 - Végső stádium (Támadás!)',
          ),
          onDoubleTap: () {
            showDebugMenu();
          },
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          AnimatedBuilder(
            animation: fadeOutController,
            builder: (context, child) {
              return Opacity(
                opacity: 1 - fadeOutController.value,
                child: child,
              );
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.8 *
                  (1 - fadeOutController.value),
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    AnimatedBuilder(
                      animation: blinkController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: fade(blinkController.value),
                          child: child,
                        );
                      },
                      child: Text(
                        'Feltörés folyamatban ${(progressController.value * 100).toStringAsFixed(1)}%',
                        style: TextStyle(fontSize: 30),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 10),
                    FractionallySizedBox(
                      widthFactor: 0.8,
                      child: LinearProgressIndicator(
                        value: progressController.value,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: fadeInController,
            builder: (context, child) {
              return Opacity(
                opacity: fadeInController.value,
                child: child,
              );
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Text(
                      'Beérkező üzenet:',
                      style: TextStyle(fontSize: 30),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Látom megtaláltátok a programot, amit elrejtettem! Nagyon ügyesek vagytok, sikeresen feltörtétek a gépemet! ✨\nSzerintem ezek közül valami érdekelhet:',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Az ajtónyitó rendszer a gépemen fut a 1234-es porton: ',
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                        GestureDetector(
                          onTap: () async {
                            await Process.start(
                              'C:\\Windows\\system32\\cmd.exe',
                              [
                                '/c',
                                'start microsoft-edge:http://10.100.100.100:1234/',
                              ],
                            );
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Text(
                              '10.100.100.100:1234',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.blue,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Text(
                          '  (<-- nyomj rá a megnyitáshoz)',
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    SelectableText(
                      'Mester jelszó: ********* (igen, 9db csillag, erre senki sem gondolna 😅)',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Központi szerver elérése: \\\\helium',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Felhasználó: Diak',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Jelszó: Diak2011',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15),
                    SelectableText(
                      'Petrik Azure AD jelszó: AzureAdJelszo2022MegMegParSzoPontosabban5',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15),
                    SelectableText(
                      'Router jelszó: MaciLaci2020',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15),
                    SelectableText(
                      'Wifi jelszó: LekvarosCsirke',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
