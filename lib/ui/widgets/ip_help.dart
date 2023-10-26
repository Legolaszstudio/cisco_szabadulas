import 'package:flutter/material.dart';

import 'drop_down_anim.dart';

class IpHelp extends StatelessWidget {
  final String myIp;
  final String myMask;
  final String? myGw;

  const IpHelp({
    super.key,
    required String this.myIp,
    String this.myMask = '255.255.255.0',
    String? this.myGw,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.75,
      child: AnimatedDropdown(
        title:
            'Segítség ip beállításához (ha valami nem megy, akkor a játékvezetők is segítenek, csak szóljatok 😄)',
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              constraints: BoxConstraints.expand(
                  height: MediaQuery.of(context).size.height * 0.6),
              child: Image(
                fit: BoxFit.scaleDown,
                image: AssetImage('assets/02ipConfig/01.png'),
              ),
            ),
            SizedBox(height: 10),
            Text(
              '1. Jobb kat az internet ikonra\n2. Beállítások megnyitása\n3. Adapter beállítások módosítása',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Container(
              constraints: BoxConstraints.expand(
                  height: MediaQuery.of(context).size.height * 0.6),
              child: Image(
                fit: BoxFit.scaleDown,
                image: AssetImage('assets/02ipConfig/02.png'),
              ),
            ),
            SizedBox(height: 10),
            Text(
              '1. Jobb kat az ethernet interfészre\n2. Tulajdonságok, ha jelszót kér, akkor válasszuk a Diák felhasználót és csak IGEN-t nyomjunk, NE írjunk be jelszót!',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Container(
              constraints: BoxConstraints.expand(
                  height: MediaQuery.of(context).size.height * 0.6),
              child: Image(
                fit: BoxFit.scaleDown,
                image: AssetImage('assets/02ipConfig/03.png'),
              ),
            ),
            SizedBox(height: 10),
            Text(
              '''
      1. TCP/IPv4 -et kiválasztani
      2. Tulajdonságok (vagy dupla kattintás TCP/IPv4-re)
      3. Átállítani a pöttyöt a kézi cím beírásra

      4. Beírni az alábbi címet: $myIp
      És maszkot: $myMask ${myGw != null ? '\n      És átjárót: $myGw' : ''}
      
      5. OKzni minden ablakot.
      6. Megnyomni az alábbi ellenőrzés gombot;''',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
