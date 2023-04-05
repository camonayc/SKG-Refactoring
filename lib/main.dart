import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skg_refactoring/app/routes/route_pages.dart';
import 'package:skg_refactoring/app/routes/routes.dart';
import 'package:skg_refactoring/app/ui/controllers/gps_controller.dart';
import 'package:skg_refactoring/app/ui/controllers/request_permission_controller.dart';
import 'package:skg_refactoring/app/utils/hex_color.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(GPSController.initializeController());
    Get.put(RequestPermissionController.initializeController());

    // *Se establece la orientacion como vertical siempre, para evitar que se vea extraño al girar el telefono.
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    // *En este apartado se configuran los colores del la barra de notificaciones, así como los de la navegación.
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: HexColor('#242C40'),
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: HexColor('#242C40'),
        systemNavigationBarIconBrightness: Brightness.light));
    return LayoutBuilder(builder: (context, constraints) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // *Usado para los títulos, subtitulos y encabezados de las tablas.
          // Crear una clase que maneje los estilos con su respectiva fuente
          primaryTextTheme: GoogleFonts.montserratTextTheme(
            Theme.of(context).textTheme,
          ),
          canvasColor: HexColor('#00FFFFFF'),
          splashColor: HexColor('#E6EFFD'),
          hoverColor: HexColor('#E6EFFD'),
          /*FALTA AGREGAR #069169, #FFAB00, #4B4B4B, #F2F2F2*/
          primaryColor: HexColor('#242C40'),
          shadowColor: HexColor('#BABABA'),
          dividerColor: HexColor('#F6F8F9'),
          toggleButtonsTheme: ToggleButtonsThemeData(
            color: HexColor('#E6EFFD'),
          ),
          cardColor: HexColor('#242C40'),
          buttonTheme: ButtonThemeData(
            buttonColor: HexColor('#242C40'),
            disabledColor: HexColor('#BABABA'),
          ),
          errorColor: HexColor('#A80521'),
          // *Usado para los parrafos, captions, botones y campos de texto.
          textTheme: GoogleFonts.workSansTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        initialRoute: AppRoutes.HOME,
        routes: routes,
      );
    });
  }
}
