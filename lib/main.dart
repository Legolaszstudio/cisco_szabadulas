import 'package:cisco_szabadulas/globals.dart' as globals;
import 'package:cisco_szabadulas/init_screen.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  globals.initGlobals();
  setWindowTitle("Cisco Szabadulás");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cisco Szabadulás',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.orange,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.black,
        ),
        useMaterial3: true,
      ),
      home: const InitScreen(),
    );
  }
}
