import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cisco_szabadulas/helpers/globals.dart' as globals;
import 'package:cisco_szabadulas/ui/html/getCheckCodes.dart';
import 'package:flutter/material.dart';

import '../simple_alert.dart';

HttpClient client = HttpClient();

Future<bool> runHttpConnectivityCheck(BuildContext context,
    {required String destination, required double stageNum}) async {
  String checkResult = await checkHttpConnectivity(destination, stageNum);
  if (checkResult == 'TimeoutException') {
    showSimpleAlert(
      context: context,
      title: 'Hiba - A másik gép nem válaszol',
      content:
          'Minden jónak tűnik, de a másik géptől nem kapok választ 😢\nA másik gépen is minden jó? Minden beállítás helyes? Jó helyre van minden bedugva?\n\nHa dupla ellenőrzés után is fennáll a hiba, akkor nyugodtan kérj segítséget!',
    );
    return false;
  }

  if (checkResult.startsWith('Exception')) {
    showSimpleAlert(
      context: context,
      title: 'Hiba - A gép nem csatlakozik a hálózatra',
      content:
          'Egy bonyolult hibába ütköztem, de ez általában azt jelenti, hogy valamelyik kábel nincs jól bedugva...\n\nHa dupla ellenőrzés után is fennáll a hiba, akkor nyugodtan kérj segítséget!\n\nRészletek:\n$checkResult',
    );
    return false;
  }

  if (checkResult != 'OK') {
    showSimpleAlert(
      context: context,
      title: 'Hiba - Nem tudom mi történik 😅',
      content:
          'Ezt a hibát nem kellene sohasem látni...\nHaladéktalanul szólj a játékvezetőnek!\n\nRészletek:\n$checkResult',
    );
    return false;
  }

  return true;
}

Future<String> checkHttpConnectivity(
  String destination,
  double stageNum, {
  int? teamNumber,
  int? pcNumber,
}) async {
  if (globals.override_http_check) {
    if (!globals.override_http_check_permanent) {
      globals.override_http_check = false;
    }
    return 'OK';
  }

  String bodyResult = await getBody(destination);
  if (bodyResult == 'TimeoutException' || bodyResult.startsWith('Exception')) {
    return bodyResult;
  }

  int otherPcNum = globals.pcNumber!;
  if (otherPcNum == 1) {
    otherPcNum = 2;
  } else {
    otherPcNum = 1;
  }

  int teamNumToCheck = globals.teamNumber!;
  if (teamNumber != null) {
    teamNumToCheck = teamNumber;
  }

  int pcNumToCheck = otherPcNum;
  if (pcNumber != null) {
    pcNumToCheck = pcNumber;
  }

  switch (stageNum) {
    case 2:
      if (bodyResult.contains(getStageTwoCheckCode(
        teamNumToCheck,
        pcNumToCheck,
      ))) {
        return 'OK';
      } else {
        return 'WrongBody ' + bodyResult;
      }
    case 3:
      if (bodyResult.contains(getStageThreeCheckCode(
        teamNumToCheck,
        pcNumToCheck,
      ))) {
        return 'OK';
      } else {
        return 'WrongBody ' + bodyResult;
      }
    case 4:
      if (bodyResult.contains(getStageFourCheckCode(
        teamNumToCheck,
        pcNumToCheck,
      ))) {
        return 'OK';
      } else {
        return 'WrongBody ' + bodyResult;
      }
    case 5.0:
    case 5.1:
    case 5.2:
      String subStage = stageNum.toStringAsFixed(1).split('.')[1];
      if (bodyResult.contains(getStageFiveCheckCode(
        teamNumToCheck,
        pcNumToCheck,
        subStage,
      ))) {
        return 'OK';
      } else {
        return 'WrongBody ' + bodyResult;
      }
    case 100:
      //Hertelendi PC
      if (bodyResult.contains(getHertelendiCheckCode())) {
        return 'OK';
      } else {
        return 'WrongBody ' + bodyResult;
      }
  }

  return 'UnknownError';
}

Future<String> getBody(
  String destination, {
  String path = '/',
}) async {
  try {
    HttpClientRequest request = await client
        .get(
          Uri.parse(destination).host,
          8080,
          path,
        )
        .timeout(
          const Duration(
            seconds: 10,
          ),
        );
    HttpClientResponse response = await request.close().timeout(
          const Duration(
            seconds: 10,
          ),
        );
    final stringData = await response.transform(utf8.decoder).join();
    return stringData;
  } on TimeoutException catch (_) {
    return 'TimeoutException';
  } catch (e) {
    return 'Exception $e';
  }
}
