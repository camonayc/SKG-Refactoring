import 'package:flutter/material.dart';
import 'package:skg_refactoring/app/widgets/no_signal_screen.dart';

class GpsPage extends StatelessWidget {
  const GpsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: buildNoGps(context)));
  }
}
