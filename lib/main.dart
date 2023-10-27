import 'package:cisco_szabadulas/helpers/globals.dart' as globals;
import 'package:cisco_szabadulas/lockSystem/lock_system_screen.dart';
import 'package:cisco_szabadulas/ui/init_screen.dart';
import 'package:cisco_szabadulas/ui/stages/01/stage_one_one.dart';
import 'package:cisco_szabadulas/ui/stages/01/stage_one_two.dart';
import 'package:cisco_szabadulas/ui/stages/01/stage_one_zero.dart';
import 'package:cisco_szabadulas/ui/stages/02/stage_two_zero.dart';
import 'package:cisco_szabadulas/ui/stages/03/stage_three_zero.dart';
import 'package:cisco_szabadulas/ui/stages/04/stage_four_zero.dart';
import 'package:cisco_szabadulas/ui/stages/05/stage_five_one.dart';
import 'package:cisco_szabadulas/ui/stages/05/stage_five_three.dart';
import 'package:cisco_szabadulas/ui/stages/05/stage_five_two.dart';
import 'package:cisco_szabadulas/ui/stages/05/stage_five_zero.dart';
import 'package:cisco_szabadulas/ui/stages/05/the_end.dart';
import 'package:cisco_szabadulas/ui/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:window_size/window_size.dart';

FocusNode focus = FocusNode();

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
      case 4.3:
        // This is on purpose, do not change, it will redirect to the correct page, needed for http srv
        screen = StageFour();
        break;
      case 5:
        screen = StageFive();
        break;
      case 5.1:
        screen = StageFiveOne();
        break;
      case 5.2:
        screen = StageFiveTwo();
        break;
      case 5.3:
        screen = StageFiveThree();
        break;
      case 5.4:
        screen = TheEnd();
        break;
    }
    if (globals.teamNumber == -1) {
      screen = LockSystemScreen();
    }
    return GlobalLoaderOverlay(
      useDefaultLoading: false,
      overlayColor: Color.fromARGB(128, 0, 0, 0),
      overlayWidget: RawKeyboardListener(
        focusNode: focus,
        child: IgnorePointer(
          child: Center(
            child: SpinKitPulsingGrid(
              color: Colors.orange,
            ),
          ),
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
