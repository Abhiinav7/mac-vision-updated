import 'package:flutter/material.dart';

const String commonUrl="https://iptv.macvision.global/API/";
const String getUrl="https://iptv.macvision.global/sub-admin/";


List<dynamic> images=[
  "assets/img/breakfast.jpg",
  "assets/img/lunch.jpg",
  "assets/img/dinner.jpg",
];
List<String> mess = [
  'Breakfast',
  'Lunch',
  'Dinner',
];
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
