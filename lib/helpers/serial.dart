import 'package:cisco_szabadulas/helpers/globals.dart' as globals;
import 'dart:io';
import 'package:xterm/xterm.dart';

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

bool isUnsafeCommand(
  String cmd,
  String fullCmd,
  Terminal terminal,
) {
  if (cmd.startsWith('line')) {
    terminal.write(
      '\r\nLine configuration is disabled!\n\r',
    );
    return true;
  }
  if (cmd.startsWith('del') ||
      cmd.startsWith('er') ||
      cmd.startsWith('cop') ||
      cmd.startsWith('rm') ||
      cmd.startsWith('ren') ||
      cmd.startsWith('wr') ||
      cmd.startsWith('par') ||
      cmd.startsWith('ar') ||
      cmd.startsWith('for') ||
      cmd.startsWith('ta') ||
      cmd.startsWith('fs') ||
      cmd.startsWith('mk') ||
      cmd.startsWith('fi')) {
    terminal.write(
      '\r\nModifying filesystem is disabled!\n\r',
    );
    return true;
  }
  if (cmd.startsWith('relo') || cmd.startsWith('wa')) {
    terminal.write(
      '\r\nRebooting is disabled!\n\r',
    );
    return true;
  }
  if ((cmd.startsWith('ip') || cmd.startsWith('no ip')) &&
      (!cmd.startsWith('ip add') && !cmd.startsWith('no ip add')) &&
      (!cmd.startsWith('ip route') && !cmd.startsWith('no ip route'))) {
    terminal.write(
      '\r\nIp settings are disabled!\n\r',
    );
    return true;
  }
  if (cmd.startsWith('relo')) {
    terminal.write(
      '\r\nRebooting is disabled!\n\r',
    );
    return true;
  }
  if (cmd.startsWith('relo')) {
    terminal.write(
      '\r\nRebooting is disabled!\n\r',
    );
    return true;
  }
  if (cmd.startsWith('deb')) {
    terminal.write(
      '\r\nDebugging is disabled!\n\r',
    );
    return true;
  }
  if (cmd.startsWith('vl')) {
    terminal.write(
      '\r\nVlans are disabled!\n\r',
    );
    return true;
  }
  if (cmd.startsWith('ter')) {
    terminal.write(
      '\r\nTerminal settings are disabled!\n\r',
    );
    return true;
  }
  if (cmd.startsWith('setu')) {
    terminal.write(
      '\r\nUsing the wizard is disabled!\n\r',
    );
    return true;
  }
  if (cmd.startsWith('set') || cmd.startsWith('mi')) {
    terminal.write(
      '\r\nOS settings are disabled!\n\r',
    );
    return true;
  }
  if (cmd.startsWith('up') ||
      cmd.startsWith('bo') ||
      cmd.startsWith('au') ||
      (fullCmd.contains('(config)#') && cmd.startsWith('conf')) ||
      cmd.startsWith('sec')) {
    terminal.write(
      '\r\nModifying boot settings is disabled!\n\r',
    );
    return true;
  }
  if (cmd.startsWith('ho')) {
    terminal.write(
      '\r\nHostname modification is disabled!\n\r',
    );
    return true;
  }
  if (fullCmd.contains('(config)#') && cmd.startsWith('enable')) {
    terminal.write(
      '\r\nModifying passwords are disabled!\n\r',
    );
    return true;
  }
  if (cmd.startsWith('mem')) {
    terminal.write(
      '\r\nMemory settings are disabled!\n\r',
    );
    return true;
  }
  if (cmd.startsWith('pas')) {
    terminal.write(
      '\r\nPassword settings are disabled!\n\r',
    );
    return true;
  }
  if (cmd.startsWith('ser')) {
    terminal.write(
      '\r\nService settings are disabled!\n\r',
    );
    return true;
  }
  if (cmd.startsWith('use')) {
    terminal.write(
      '\r\nUser settings are disabled!\n\r',
    );
    return true;
  }
  if (cmd.startsWith('int') && fullCmd.contains('.')) {
    terminal.write(
      '\r\nSubinterfaces are disabled!\n\r',
    );
    return true;
  }
  return false;
}
