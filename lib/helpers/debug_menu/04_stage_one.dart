import 'package:cisco_szabadulas/helpers/file_deployment/file_deployer.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

void showStageOneDebugMenu(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Stage One Debug Menu'),
      content: StageOneDebugMenu(),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('OK'),
        ),
      ],
    ),
  );
}

class StageOneDebugMenu extends StatefulWidget {
  const StageOneDebugMenu({super.key});

  @override
  State<StageOneDebugMenu> createState() => _StageOneDebugMenuState();
}

class _StageOneDebugMenuState extends State<StageOneDebugMenu> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            width: 250,
            child: TextButton(
              style: ButtonStyle(
                shadowColor: MaterialStateProperty.all(Colors.orange),
                side: MaterialStateProperty.all(
                  BorderSide(color: Colors.orange),
                ),
              ),
              child: Text('ReDeploy Mail'),
              onPressed: () async {
                context.loaderOverlay.show();
                await fileDeployer();
                context.loaderOverlay.hide();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 3),
                    backgroundColor: Colors.green,
                    content: Text('Mail redeployed!'),
                  ),
                );
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
