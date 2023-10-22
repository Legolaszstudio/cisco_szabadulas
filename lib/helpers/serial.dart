import 'package:cisco_szabadulas/helpers/globals.dart' as globals;
import 'dart:io';

Future<Process> connectSerial() async {
  String plinkPath =
      File(Directory.systemTemp.path + '\\plink\\plink.exe').path;
  Process process = await Process.start(
    plinkPath,
    ['-serial', globals.comPort],
  );
  print('Connected to: ' + plinkPath);
  return process;
}
