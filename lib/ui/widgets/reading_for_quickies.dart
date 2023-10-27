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
----------------------------------------------------------------------
11000000.10101010.00001010.00000000 = 192.168.10.0 <-- Hálózat címe


Vannak címek amik privátak, ezeket használjuk otthon és itt is, a többit az "internet" használja;
Ilyen privát cím tartományok a:

192.168.0.0 - 192.168.255.255
10.0.0.0 - 10.255.255.255
172.16.00 - 172.31.255.255

Az iskola a 10-es hálózatot használja; 10.(elosztó szám).(terem szám).(gép szám)

Létezik IPv6 is, mivel 2^32 cím az már kevés volt.
Az IPv6 ami már 128 bittel dologzik tehát 2^128 cím, ami már bőséges.
De ennél többet nem mondok, nézettek utána, ha érdekel ;)
''',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
        AnimatedDropdown(
          title: 'Otthon miért nem kell (statikus) címet állítanom?',
          child: Padding(
            padding: const EdgeInsets.only(left: 50.0, right: 10),
            child: Text(
              '''
Otthon be van állítva a routeren DHCP, azaz a Dynamic Host Configuration Protocoll, ez felel azért, hogy amikor bedugod a gépedet akkor a router elmondja neki, hogy mi lesz az ő címe, maszkja és merre találja az átjárót.
''',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
        AnimatedDropdown(
          title:
              'Miért villog sárgán a switch egy darabig mielőtt zöldre vált?',
          child: Padding(
            padding: const EdgeInsets.only(left: 50.0, right: 10),
            child: Text(
              '''
A STP, azaz Spanning Tree Protocoll miatt, enek az a feladata, hogy megakadályoza, hogy hurok alakuljon ki a hálózatban, azaz valahol valami kétszer van bedugva, vagy vissza van dugva önmagába.
Erre azért van szükség, hogy ne alakuljon ki végtelen hurok, ahol a switch saját magának válaszolgat.
Illetve azért is, hogyha több útvonal létezik, akkor kiválassza a legmegfelelőbbet.
''',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
        AnimatedDropdown(
          title:
              'Hogyan ellenőrzi a program, hogy jól állítottam be az ip címeket?',
          child: Padding(
            padding: const EdgeInsets.only(left: 50.0, right: 10),
            child: Text(
              '''
A 'netsh interface ip dump' parancsot futattja le egy parancssorban, nyugodtan próbáld ki te is ;)
Nyiss egy parancssort, írd be a parancsot, enter és láss csodát
Itt látjuk az ip címeket, maskokat és a gateway-eket is
''',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
        AnimatedDropdown(
          title: 'Hogyan ellenőrzi a program, hogy jó-e az összekötetés?',
          child: Padding(
            padding: const EdgeInsets.only(left: 50.0, right: 10),
            child: Text(
              '''
A háttérben fut egy webszerver a 8080-as porton, nyiss egy böngészőt, és írd be, hogy "localhost:8080" (idézőjelek nélkül).
A program azt nézi, hogy ez a weboldal a megfelelő csapat és gép számmal megnyílik-e.
''',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
        AnimatedDropdown(
          title: 'Mit kell tudni erről a programról?',
          child: Padding(
            padding: const EdgeInsets.only(left: 50.0, right: 10),
            child: Text(
              '''
Ez a program flutter-ben írodott, a dart programnyelvben.
Teljes mértékben nyílt forráskódú, elérhető GitHub-on: Legolaszstudio/cisco_szabadulas néven

Amikor ezt írtam akkor 97 program fájlt tartalmazott, ami 7595 sort jelent.
Mindezt 56 óra programazással értük el, és kb ugyanennyi tervezéssel.

Miért pont flutter?
Mivel ezt már jól ismerjük a NovyNapló e-kréta kliensnek köszönhetően.
''',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
        AnimatedDropdown(
          title: 'Hogyan működik a console port?',
          child: Padding(
            padding: const EdgeInsets.only(left: 50.0, right: 10),
            child: Text(
              '''
A console port a régi nyomtatókhoz hasonlítható, betűket küld és fogad.
Ez a program egy PuTTY nevű segédprogrammal tud betűket irogatni erre a kábelre és fogadni is azokat.

Melyeket szépen átküldjük a felhasználói interfészünkre.

Továbbá, mint láthatjátok, a veszélyes parancsokat nem engedjük elküldeni (mint pl. újraindítás vagy a jelszavak módosítása), így is biztosítva, hogy ne tudjatok semmit elrontani 😅
Illetve amikor kiépül a kapcsolat, akkor beállítunk pár dolgot;

A router nevét CsapatXRouter-re.
A parancssorba való kiiratást átállítjuk szinkronos-ra, azaz ha valami üzenet érkezik, akkor az új sorba íródik.
Kikapcsoljuk az automatikus kijelentkezést, így ha sokáig nem írtok be semmit, akkor sem fog kiléptetni a router.
Illetve kikapcsoljuk a DNS-t (névfeloldást), hogy az elgépelt parancsokat ne weboldalként próbálja meg értelmezni.
''',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }
}
