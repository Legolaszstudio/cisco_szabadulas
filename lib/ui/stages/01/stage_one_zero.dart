import 'package:cisco_szabadulas/helpers/debug_menu/debug_menu.dart';
import 'package:cisco_szabadulas/helpers/file_deployment/file_deployer.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

class StageOne extends StatefulWidget {
  const StageOne({super.key});

  @override
  State<StageOne> createState() => _StageOneState();
}

class _StageOneState extends State<StageOne> {
  @override
  void initState() {
    setWindowTitle('Cisco Szabadulás - Első stádium');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fileDeployer();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text('Cisco Szabadulás - Első stádium'),
          onDoubleTap: () {
            showDebugMenu();
          },
        ),
      ),
    );
  }
}
