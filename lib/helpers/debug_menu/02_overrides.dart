import 'package:flutter/material.dart';
import '../globals.dart' as globals;

bool ip_check_override = false;
bool ip_check_override_permanent = false;
bool http_check_override = false;
bool http_check_override_permanent = false;

void showOverridesDebugMenu(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Overrides Debug Menu'),
      content: OverridesDebugMenu(),
      actions: [
        TextButton(
          onPressed: () {
            globals.override_ip_check = ip_check_override;
            globals.override_ip_check_permanent = ip_check_override_permanent;
            globals.override_http_check = http_check_override;
            globals.override_http_check_permanent =
                http_check_override_permanent;
            Navigator.of(context).pop();
          },
          child: Text('Mentés'),
        ),
      ],
    ),
  );
}

class OverridesDebugMenu extends StatefulWidget {
  const OverridesDebugMenu({super.key});

  @override
  State<OverridesDebugMenu> createState() => _OverridesDebugMenuState();
}

class _OverridesDebugMenuState extends State<OverridesDebugMenu> {
  @override
  void initState() {
    ip_check_override = globals.override_ip_check;
    ip_check_override_permanent = globals.override_ip_check_permanent;
    http_check_override = globals.override_http_check;
    http_check_override_permanent = globals.override_http_check_permanent;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CheckboxListTile(
            value: ip_check_override,
            title: Text('IP check override'),
            onChanged: (newValue) {
              setState(() {
                ip_check_override = newValue!;
              });
            },
          ),
          CheckboxListTile(
            value: ip_check_override_permanent,
            title: Text('IP check override PERM'),
            onChanged: (newValue) {
              setState(() {
                ip_check_override_permanent = newValue!;
              });
            },
          ),
          CheckboxListTile(
            value: http_check_override,
            title: Text('HTTP check override'),
            onChanged: (newValue) {
              setState(() {
                http_check_override = newValue!;
              });
            },
          ),
          CheckboxListTile(
            value: http_check_override_permanent,
            title: Text('HTTP check override PERM'),
            onChanged: (newValue) {
              setState(() {
                http_check_override_permanent = newValue!;
              });
            },
          ),
        ],
      ),
    );
  }
}
