import 'package:flutter/material.dart';
import 'package:cisco_szabadulas/helpers/globals.dart' as globals;

import '00_debug_selector.dart';

void showDebugMenu() {
  if (globals.navigatorKey.currentContext == null) {
    globals.log.e('showDebugMenu: navigatorKey.currentContext is null');
    return;
  }

  TextEditingController _passwordCtrl = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Do the verification
  showDialog(
    context: globals.navigatorKey.currentContext!,
    builder: (context) => AlertDialog(
      title: Text('Fejlesztői menü'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Kérem a jelszót 🔒'),
          Form(
            key: _formKey,
            child: TextFormField(
              autofocus: true,
              controller: _passwordCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Szuper titkos admin jelszó',
                errorStyle: TextStyle(color: Colors.red),
              ),
              onFieldSubmitted: (_) {
                if (_formKey.currentState!.validate()) {
                  Navigator.of(context).pop();
                  enterDebugMenu();
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kérem a jelszót';
                }
                if (value != globals.devPassword) {
                  return 'Hibás jelszó';
                }
                return null;
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop();
              enterDebugMenu();
            }
          },
          child: Text('OK'),
        ),
      ],
    ),
  );
  return;
}

void enterDebugMenu() {
  showDialog(
    context: globals.navigatorKey.currentContext!,
    builder: (context) => AlertDialog(
      title: Text('Fejlesztői menü'),
      content: DebugSelector(),
    ),
  );
}
