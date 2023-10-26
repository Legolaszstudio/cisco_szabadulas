import 'package:flutter/material.dart';

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
        Placeholder(),
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