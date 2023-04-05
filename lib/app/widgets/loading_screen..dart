import 'package:flutter/material.dart';
import 'package:skg_refactoring/app/utils/hex_color.dart';

Container buildLoadingScreen() {
  return Container(
    height: double.infinity,
    width: double.infinity,
    color: HexColor("#1C2333"),
    child: Center(
        child: CircularProgressIndicator(
      color: HexColor("#E6EFFD"),
    )),
  );
}
