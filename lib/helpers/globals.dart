import 'dart:convert';
import 'dart:io';

import 'package:cisco_szabadulas/helpers/check_conf/http_client.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../lockSystem/lock_system_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final String devPassword = utf8.decode(
  [77, 97, 99, 105, 76, 97, 99, 105, 67, 105, 99, 107, 111],
);
//[97, 108, 109, 97]
//[77, 97, 99, 105, 76, 97, 99, 105, 67, 105, 99, 107, 111]
final String stageOnePassword = utf8.decode([99, 105, 115, 99, 111]);

late SharedPreferences prefs;
late int? teamNumber = 1;
late int? pcNumber = 1;
late int? numberOfTeams = 7;
late String? teamName = '';
/** 
 *  -1 = Init;  
 *   0 = Get ready;  
 *   ... Stage X.Y;  
 */
late double? currentStage = -1;
String networkInterface = 'Ethernet';
String comPort = 'COM3';
bool routerInit = false;
bool sanitizeInput = true;
HttpServer? server;
/** 0 = Offline, X = Stage X */
double httpServerVer = 0;

//-------------- Overrides --------------
bool override_ip_check = false;
bool override_ip_check_permanent = false;
bool override_http_check = false;
bool override_http_check_permanent = false;
bool override_ping_check = false;

bool override_router_ip_check = false;
bool override_router_mask_check = false;
bool override_router_sh_check = false;
bool override_router_proto_check = false;
bool override_router_gw_check = false;

//-------------- Timings ---------------
int timeForStageOne = 15; //Minutes

int stageOneStart = 0;
int stageOneEnd = 0;
int stageTwoStart = 0;
int stageTwoEnd = 0;
int stageThreeStart = 0;
int stageThreeEnd = 0;
int stageFourStart = 0;
int stageFourEnd = 0;
int stageFiveStart = 0;
int stageFiveSectionOneEnd = 0;
int stageFiveEnd = 0;

Map<String, dynamic> timingData = {};

Future<void> initGlobals() async {
  client.connectionTimeout = const Duration(seconds: 15);

  prefs = await SharedPreferences.getInstance();
  teamNumber = prefs.getInt('teamNumber') ?? 1;
  pcNumber = prefs.getInt('pcNumber') ?? 1;
  currentStage = prefs.getDouble('currentStage') ?? -1;
  networkInterface = prefs.getString('networkInterface') ?? 'Ethernet';
  teamName = prefs.getString('teamName') ?? '';
  numberOfTeams = prefs.getInt('numberOfTeams') ?? 7;
  comPort = prefs.getString('comPort') ?? 'COM3';
  routerInit = prefs.getBool('routerInit') ?? false;

  // Load timings
  stageOneStart = prefs.getInt('stageOneStart') ?? 0;
  stageOneEnd = prefs.getInt('stageOneEnd') ?? 0;
  stageTwoStart = prefs.getInt('stageTwoStart') ?? 0;
  stageTwoEnd = prefs.getInt('stageTwoEnd') ?? 0;
  stageThreeStart = prefs.getInt('stageThreeStart') ?? 0;
  stageThreeEnd = prefs.getInt('stageThreeEnd') ?? 0;
  stageFourStart = prefs.getInt('stageFourStart') ?? 0;
  stageFourEnd = prefs.getInt('stageFourEnd') ?? 0;
  stageFiveStart = prefs.getInt('stageFiveStart') ?? 0;
  stageFiveSectionOneEnd = prefs.getInt('stageFiveSectionOneEnd') ?? 0;
  stageFiveEnd = prefs.getInt('stageFiveEnd') ?? 0;

  timingData = jsonDecode(prefs.getString('timingData') ?? '{}');
  if (connectionStatus.length == 0) {
    for (int i = 1; i <= numberOfTeams!; i++) {
      connectionStatus['$i.1'] = 0;
      connectionStatus['$i.2'] = 0;
      if (timingData['$i.1'] != null) {
        connectionStatus['$i.1'] = 1;
      }
      if (timingData['$i.2'] != null) {
        connectionStatus['$i.2'] = 1;
      }
    }
  }
}
