import 'package:flutter/material.dart';
import 'package:skg_refactoring/app/routes/routes.dart';
import 'package:skg_refactoring/app/ui/pages/gps_page.dart';
import 'package:skg_refactoring/app/ui/pages/home_page.dart';
import 'package:skg_refactoring/app/ui/pages/map_filter_page.dart';
import 'package:skg_refactoring/app/ui/pages/map_page.dart';
import 'package:skg_refactoring/app/ui/pages/register_page.dart';
import 'package:skg_refactoring/app/ui/pages/splash_page.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  AppRoutes.SPLASH: (_) => SplashPage(),
  AppRoutes.MAP: (_) => GoogleMapPage(),
  AppRoutes.REGISTER: (_) => RegisterPage(),
  AppRoutes.HOME: (_) => HomePage(),
  AppRoutes.GPS: (_) => GpsPage(),
  AppRoutes.FILTER: (_) => MapFilterPage()
};
