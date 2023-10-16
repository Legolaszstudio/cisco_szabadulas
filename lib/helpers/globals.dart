import 'dart:io';

import 'package:cisco_szabadulas/helpers/check_conf/http_client.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final navigatorKey = GlobalKey<NavigatorState>();
const String devPassword = 'alma';

late SharedPreferences prefs;
late int? teamNumber;
late int? pcNumber;
/** 
 *  -1 = Init;  
 *   0 = Get ready;  
 *   ... Stage X.Y;  
 */
late double? currentStage = -1;
String networkInterface = 'Ethernet';
HttpServer? server;
/** 0 = Offline, X = Stage X */
int httpServerVer = 0;

//-------------- Overrides --------------
bool override_ip_check = false;
bool override_ip_check_permanent = false;
bool override_http_check = false;
bool override_http_check_permanent = false;

Future<void> initGlobals() async {
  client.connectionTimeout = const Duration(seconds: 15);

  prefs = await SharedPreferences.getInstance();
  teamNumber = prefs.getInt('teamNumber');
  pcNumber = prefs.getInt('pcNumber');
  currentStage = prefs.getDouble('currentStage') ?? -1;
  networkInterface = prefs.getString('networkInterface') ?? 'Ethernet';
}
