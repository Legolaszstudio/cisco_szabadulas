import 'package:cisco_szabadulas/helpers/check_conf/is_ip_conf_right.dart';
import 'package:cisco_szabadulas/helpers/debug_menu/debug_menu.dart';
import 'package:cisco_szabadulas/ui/stages/04/stage_four_two.dart';
import 'package:cisco_szabadulas/ui/widgets/ip_help.dart';
import 'package:flutter/material.dart';
import 'package:cisco_szabadulas/helpers/globals.dart' as globals;
import 'package:loader_overlay/loader_overlay.dart';

class StageFourOne extends StatefulWidget {
  const StageFourOne({super.key});

  @override
  State<StageFourOne> createState() => _StageFourOneState();
}

class _StageFourOneState extends State<StageFourOne> {
  String myIp = '192.168.${globals.teamNumber}.1';
  String myGw = '192.168.${globals.teamNumber}.254';

  @override
  void initState() {
    if (globals.pcNumber == 2) {
      myIp = '10.10.10.100';
      myGw = '10.10.10.${globals.teamNumber}';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text(
            'Cisco Szabadulás 4.1 - Negyedik stádium (Több hálózat)',
          ),
          onDoubleTap: () {
            showDebugMenu();
          },
        ),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            if (globals.pcNumber == 1)
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Text(
                  '''
      Ez a gép marad a belső 'saját hálózatunk' része
      
      Viszont ahhoz, hogy elérjük a többi hálózatot, be kell állítanunk, hogy hova küldje a nem ezen hálózatba tartozó adatokat. A routerre szeretnénk...
      (A postásnak adjuk a levelet, hogy kézbesítse.)
      
      Az IP marad ugyanaz: $myIp
      
      A maszk viszont legyen újból: 255.255.255.0
      (Ez azt jelenti, hogy ebben a hálózatban max 254 eszköz lehet....)
      
      Az átjárónk pedig legyen: $myGw
      Ez vagy az első vagy az utolsó cím szokott lenni, de mivel a gépünké már az első, ezért most utolsót használjuk, mint router cím.''',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            if (globals.pcNumber == 2)
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Text(
                  '''
      Ez a gép legyen az én gépem 'szimulációja', rakjuk valami teljesen másik hálózatba
      
      Az IP legyen mondjuk (Ez már nem 192.168. 😉): $myIp
      
      A maszk viszont legyen újból: 255.255.255.0
      (Ez azt jelenti, hogy ebben a hálózatban max 254 eszköz lehet....)
      
      Viszont ahhoz, hogy elérjük a többi hálózatot, be kell állítanunk, hogy hova küldje a nem ezen hálózatba tartozó adatokat. A routerre szeretnénk...
      (A postásnak adjuk a levelet, hogy kézbesítse.)
      
      Az átjárónk legyen: $myGw
      Az utolsó számjegy a csapatunk száma, mert nem kötelező az utolsó vagy első címet adni a routernek, csak szokás, ezért megtehetjük. 🤷
      ''',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            SizedBox(height: 10),
            IpHelp(
              myIp: myIp,
              myGw: myGw,
            ),
            SizedBox(height: 20),
            Text(
              '''
Kábelezésre fel!
Ezt a gépet a router ${globals.pcNumber == 1 ? 'Fe0/0' : 'Fe0/1'} csatlakozójába dugjuk be.
      ''',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            Container(
              constraints: BoxConstraints.expand(
                  height: MediaQuery.of(context).size.height * 0.6),
              child: Image(
                fit: BoxFit.scaleDown,
                image: AssetImage(
                    'assets/03eszkozok/routerPc${globals.pcNumber}.jpg'),
              ),
            ),
            SizedBox(height: 15),
            if (globals.pcNumber == 1)
              Text(
                '''
A gép hátuljából kilóg egy kék színű kábel, őt rollover-nek hívják és vele tudjuk a router-t beállítani.
Őt is dugjuk be az egyik rack fali csatlakozóba. Majd a router console-portjába is dugjuk be, ami olyan kék, mint maga a kábel.
Nehéz eltéveszteni 😉
      ''',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            if (globals.pcNumber == 1)
              Container(
                constraints: BoxConstraints.expand(
                    height: MediaQuery.of(context).size.height * 0.6),
                child: Image(
                  fit: BoxFit.scaleDown,
                  image: AssetImage('assets/03eszkozok/console.jpg'),
                ),
              ),
            SizedBox(height: 15),
            FractionallySizedBox(
              widthFactor: 0.5,
              child: TextButton.icon(
                icon: Icon(Icons.checklist),
                label: Text('Ellenőrzés'),
                onPressed: () async {
                  context.loaderOverlay.show();
                  bool ipCheckResult = await runIpCheck(
                    context,
                    ipToCheck: myIp,
                    gatewayToCheck: myGw,
                  );
                  context.loaderOverlay.hide();

                  if (ipCheckResult == false) return;

                  globals.currentStage = 4.2;
                  globals.prefs.setDouble('currentStage', 4.2);

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => StageFourTwo(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
