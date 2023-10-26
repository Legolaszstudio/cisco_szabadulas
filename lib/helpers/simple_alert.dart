import 'package:flutter/material.dart';

Future<void> showSimpleAlert({
  required BuildContext context,
  required String title,
  required String content,
  Function? okCallback,
  bool dismissable = true,
}) {
  return showDialog(
    context: context,
    barrierDismissible: dismissable,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: SelectableText(
          content,
        ),
      ),
      actions: [
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
            if (okCallback != null) okCallback();
          },
        ),
      ],
    ),
  );
}
