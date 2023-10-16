import 'package:flutter/material.dart';

Future<void> showSimpleAlert({
  required BuildContext context,
  required String title,
  required String content,
}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(
        content,
      ),
      actions: [
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}
