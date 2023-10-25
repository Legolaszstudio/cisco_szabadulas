import 'package:flutter/material.dart';
import '../globals.dart' as globals;

bool routerInit = false;
bool sanitizeInput = true;
bool override_router_ip_check = false;
bool override_router_mask_check = false;
bool override_router_sh_check = false;
bool override_router_proto_check = false;
bool override_router_gw_check = false;

void showStageFourDebugMenu(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Stage Four Debug Menu'),
      content: StageFourDebugMenu(),
      actions: [
        TextButton(
          onPressed: () {
            globals.routerInit = routerInit;
            globals.prefs.setBool('routerInit', routerInit);

            globals.sanitizeInput = sanitizeInput;
            globals.override_router_ip_check = override_router_ip_check;
            globals.override_router_mask_check = override_router_mask_check;
            globals.override_router_sh_check = override_router_sh_check;
            globals.override_router_proto_check = override_router_proto_check;
            globals.override_router_gw_check = override_router_gw_check;
            Navigator.of(context).pop();
          },
          child: Text('OK'),
        ),
      ],
    ),
  );
}

class StageFourDebugMenu extends StatefulWidget {
  const StageFourDebugMenu({super.key});

  @override
  State<StageFourDebugMenu> createState() => _StageFourDebugMenuState();
}

class _StageFourDebugMenuState extends State<StageFourDebugMenu> {
  @override
  void initState() {
    routerInit = globals.routerInit;
    sanitizeInput = globals.sanitizeInput;
    override_router_ip_check = globals.override_router_ip_check;
    override_router_mask_check = globals.override_router_mask_check;
    override_router_sh_check = globals.override_router_sh_check;
    override_router_proto_check = globals.override_router_proto_check;
    override_router_gw_check = globals.override_router_gw_check;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CheckboxListTile(
            title: Text('Router Initialized'),
            value: routerInit,
            onChanged: (newValue) {
              setState(() {
                routerInit = newValue!;
              });
            },
          ),
          CheckboxListTile(
            title: Text('Sanitize Input'),
            value: sanitizeInput,
            onChanged: (newValue) {
              setState(() {
                sanitizeInput = newValue!;
              });
            },
          ),
          Divider(),
          CheckboxListTile(
            title: Text('Override IP check'),
            value: override_router_ip_check,
            onChanged: (newValue) {
              setState(() {
                override_router_ip_check = newValue!;
              });
            },
          ),
          CheckboxListTile(
            title: Text('Override Mask check'),
            value: override_router_mask_check,
            onChanged: (newValue) {
              setState(() {
                override_router_mask_check = newValue!;
              });
            },
          ),
          CheckboxListTile(
            title: Text('Override SH check'),
            value: override_router_sh_check,
            onChanged: (newValue) {
              setState(() {
                override_router_sh_check = newValue!;
              });
            },
          ),
          CheckboxListTile(
            title: Text('Override Proto check'),
            value: override_router_proto_check,
            onChanged: (newValue) {
              setState(() {
                override_router_proto_check = newValue!;
              });
            },
          ),
          CheckboxListTile(
            title: Text('Override GW check'),
            value: override_router_gw_check,
            onChanged: (newValue) {
              setState(() {
                override_router_gw_check = newValue!;
              });
            },
          ),
        ],
      ),
    );
  }
}
