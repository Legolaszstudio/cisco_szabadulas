import 'package:cisco_szabadulas/helpers/check_conf/http_client.dart';
import 'package:cisco_szabadulas/helpers/globals.dart' as globals;
import 'package:cisco_szabadulas/ui/init_screen.dart';
import 'package:cisco_szabadulas/ui/stages/stage_one.dart';
import 'package:cisco_szabadulas/ui/stages/stage_two.dart';
import 'package:cisco_szabadulas/ui/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';
import 'helpers/check_conf/http_server.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  globals.initGlobals();
  setWindowTitle('Cisco Szabadulás');
  await startServer('<h1>Cisco Szabadulás</h1>');
  print(
    await getBody(
      destination: 'http://localhost:8080',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Widget screen = InitScreen();
    switch (globals.currentStage) {
      case -1:
        screen = InitScreen();
        break;
      case 0:
        screen = StartScreen();
        break;
      case 1:
        screen = StageOne();
        break;
      case 2:
        screen = StageTwo();
        break;
    }
    return MaterialApp(
      title: 'Cisco Szabadulás',
      navigatorKey: globals.navigatorKey,
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
      home: screen,
    );
  }
}
