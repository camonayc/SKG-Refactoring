import 'package:flutter/material.dart';
import 'package:skg_refactoring/app/utils/hex_color.dart';

Container buildNoGps(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return Container(
    height: double.infinity,
    width: double.infinity,
    alignment: Alignment.center,
    padding:
        EdgeInsets.only(left: size.height * 0.02, right: size.height * 0.02),
    color: HexColor("#1C2333"),
    child: Container(
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      width: double.infinity,
      height: size.height * 0.2,
      decoration: BoxDecoration(
          boxShadow: const [BoxShadow(blurRadius: 1, color: Colors.white)],
          color: HexColor("#242C40"),
          borderRadius: BorderRadius.circular(12)),
      child: Text(
        "No tienes el GPS encendido.\nEs necesario tener activo el GPS para poder usar la aplicación, por favor enciendelo",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: HexColor("#E6EFFD"),
          fontSize: size.height * 0.03,
        ),
      ),
    ),
  );
}
