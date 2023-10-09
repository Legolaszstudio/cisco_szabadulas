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
 *   ... Stage X;  
 */
late int? currentStage = -1;

Future<void> initGlobals() async {
  prefs = await SharedPreferences.getInstance();
  teamNumber = prefs.getInt('teamNumber');
  pcNumber = prefs.getInt('pcNumber');
  currentStage = prefs.getInt('currentStage') ?? -1;
}
