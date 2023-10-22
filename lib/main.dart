import 'package:cisco_szabadulas/helpers/globals.dart' as globals;
import 'package:cisco_szabadulas/ui/init_screen.dart';
import 'package:cisco_szabadulas/ui/stages/01/stage_one_one.dart';
import 'package:cisco_szabadulas/ui/stages/01/stage_one_two.dart';
import 'package:cisco_szabadulas/ui/stages/01/stage_one_zero.dart';
import 'package:cisco_szabadulas/ui/stages/02/stage_two_zero.dart';
import 'package:cisco_szabadulas/ui/stages/03/stage_three_zero.dart';
import 'package:cisco_szabadulas/ui/stages/04/stage_four_zero.dart';
import 'package:cisco_szabadulas/ui/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:window_size/window_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  globals.initGlobals();
  setWindowTitle('Cisco Szabadulás');
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
      case 1.1:
        screen = StageOneOne();
        break;
      case 1.2:
        screen = StageOneTwo(success: false);
        break;
      case 2:
      case 2.1:
      case 2.2:
        // This is on purpose, do not change, it will redirect to the correct page, needed for http srv
        screen = StageTwo();
        break;
      case 3:
      case 3.1:
      case 3.2:
      case 3.3:
        // This is on purpose, do not change, it will redirect to the correct page, needed for http srv
        screen = StageThree();
        break;
      case 4:
      case 4.1:
      case 4.2:
        // This is on purpose, do not change, it will redirect to the correct page, needed for http srv
        screen = StageFour();
        break;
    }
    return GlobalLoaderOverlay(
      useDefaultLoading: false,
      overlayColor: Color.fromARGB(128, 0, 0, 0),
      overlayWidget: Center(
        child: SpinKitPulsingGrid(
          color: Colors.orange,
        ),
      ),
      child: MaterialApp(
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
      ),
    );
  }
}
