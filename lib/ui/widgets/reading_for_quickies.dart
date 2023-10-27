import 'package:flutter/material.dart';

import 'drop_down_anim.dart';

class ReadingForQuickies extends StatefulWidget {
  const ReadingForQuickies({super.key});

  @override
  State<ReadingForQuickies> createState() => _ReadingForQuickiesState();
}

class _ReadingForQuickiesState extends State<ReadingForQuickies> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Text(
          'Olvasnivaló a gyorsaknak:',
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        AnimatedDropdown(
          title: 'Hogyan működik és mi az ip cím/subnet mask?',
          child: Padding(
            padding: const EdgeInsets.only(left: 50.0, right: 10),
            child: Text(
              '''
Az IP cím egy olyan cím, amivel a számítógépet azonosítani tudjuk a saját hálózatunkon, illetve segítségével másik hálózatokba is át tudunk jutni.

Az ipv4 cím, amiket most is használunk, 32 bit hosszú, és 8 bitekre van osztva, ez által 4 kisebb részre;
Mivel 8 bit értéke 0-255 között lehet, ezért az ip címek is ilyenek, pl:
0.0.0.0
255.255.255.255
10.110.15.8
stb...

Az ip viszont maszk nélkül nem sokat ér, hiszen a maszk határozza meg, hogy melyik része az ip címnek a hálózat, és melyik a számítógép címe.
A maszk is 32 bit hosszú, és 8 bitekre van osztva, de itt nem lehet akármi a szám, ha kettes számrendszerben írjuk le a maszkot akkor bal oldalt csupa egyesnek kell lennie, jobb oldalt pedig csupa nullásnak.
A maszkot szokták ezért úgy nevezett CIDR jelöléssel is jelölni, ami nem számokkal adja meg, hanem az elején található egyesek számával.

255.255.255.0 = /24 = 11111111.11111111.11111111.00000000
255.255.192.0 = /18 = 11111111.11111111.11000000.00000000

A maszk egy bináris és műveletet hajt végre az ip címmel, és az eredményül kapjuk meg a hálózat címét.
Az és művelet egy bitenkénti és művelet, tehát ha az egyik bit 1, a másik 0, akkor az eredmény 0, ha mindkettő 1, akkor 1.
pl: /24 esetén
11111111.11111111.11111111.00000000 = 255.255.255.0
11000000.10101010.00001010.00000000 = 192.168.10.92
-----------------------------------
11000000.10101010.00001010.00000000 = 192.168.10.0 <-- Hálózat címe


Vannak címek amik privátak, ezeket használjuk otthon, a többit az "internet" használja;
Ilyen privát címek a:



Létezik IPv6 is, mivel 2^32 cím az már kevés volt.
Az IPv6 ami már 128 bittel dologzik tehát 2^128 cím, ami már bőséges.
De ennél többet nem mondok, nézettek utána, ha érdekel ;)
''',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }
}

/* 
Mi az a maszk?
Miért pont 192.168... vagy 10...?
Otthon miért nem kell címet adnom?
Hogyan ellenőrzi a program a kapcsolatokat?
Hogyan írodott ez a progam?
Mi az ipv6?
 */