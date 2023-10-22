import 'package:cisco_szabadulas/helpers/check_conf/http_server.dart';
import 'package:cisco_szabadulas/helpers/debug_menu/debug_menu.dart';
import 'package:cisco_szabadulas/ui/html/stage_three_html.dart';
import 'package:flutter/material.dart';
import 'package:cisco_szabadulas/helpers/globals.dart' as globals;
import 'package:window_size/window_size.dart';

class StageThree extends StatefulWidget {
  const StageThree({super.key});

  @override
  State<StageThree> createState() => _StageThreeState();
}

class _StageThreeState extends State<StageThree> {
  @override
  void initState() {
    setWindowTitle('Cisco Szabadulás - Harmadik stádium');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (globals.httpServerVer != 0) {
        await globals.server?.close();
      }
      globals.server = await startServer(stage_three_html());
      globals.httpServerVer = 3;
      if (globals.stageThreeStart == 0) {
        globals.stageThreeStart = DateTime.now().millisecondsSinceEpoch;
        globals.prefs.setInt('stageThreeStart', globals.stageThreeStart);
        print('Timing started for stage 3: ${globals.stageThreeStart}');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text(
            'Cisco Szabadulás 3.0 - Harmadik stádium (Egy nagy kapcsolat)',
          ),
          onDoubleTap: () {
            showDebugMenu();
          },
        ),
      ),
    );
  }
}
