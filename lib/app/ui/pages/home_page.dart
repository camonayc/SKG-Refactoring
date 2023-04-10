import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skg_refactoring/app/routes/routes.dart';
import 'package:skg_refactoring/app/ui/controllers/get_data_controller.dart';
import 'package:skg_refactoring/app/ui/controllers/google_map_controller.dart';
import 'package:skg_refactoring/app/ui/controllers/gps_controller.dart';
import 'package:skg_refactoring/app/ui/controllers/home_controller.dart';
import 'package:skg_refactoring/app/ui/controllers/register_controller.dart';
import 'package:skg_refactoring/app/utils/hex_color.dart';
import 'package:skg_refactoring/app/widgets/loading_screen..dart';

class HomePage extends StatelessWidget {
  final HomeController _controller = HomeController.initializeController();
  final GetDataController _dataController =
      GetDataController.initializeController();
  final RegisterController _registerController =
      RegisterController.initializeController();
  final MapGoogleController _mapController =
      MapGoogleController.initializeController();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(() => _controller.isLoading.value == true ||
                  _dataController.dataLoading.value == true
              ? buildLoadingScreen()
              : buildHomePage())
        ],
      ),
    );
  }

  Center buildHomePage() {
    return Center(
      child: Container(
          height: double.infinity,
          width: double.infinity,
          color: HexColor("#1C2333"),
          child: SingleChildScrollView(
              child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.all(40),
                  width: double.infinity,
                  height: 100,
                  child: SvgPicture.asset(
                    "assets/icons/logo_home.svg",
                    color: HexColor("#9FDF20"),
                  )),
              Container(
                margin: const EdgeInsets.only(top: 60, bottom: 120),
                child: const Text(
                  "BIENVENIDO",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
              ReportButton(onPressed: () async {
                await _dataController.checkPlace();
                await _controller.goToRegisterPage();
                await _registerController.getListData();
              }),
              ViewButton(onPressed: () async {
                _controller.isLoading.value = true;
                _mapController.isTap.value = false;
                await _mapController.createMarkers();
                await _dataController.checkPlace();
                Get.toNamed(AppRoutes.MAP);
                _controller.isLoading.value = false;
              }),
            ],
          ))),
    );
  }
}

class ViewButton extends StatelessWidget {
  final Function() onPressed;
  const ViewButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 40),
      child: TextButton(
          style: ButtonStyle(
              fixedSize: MaterialStateProperty.resolveWith(
                  (states) => const Size(280, 50)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
              overlayColor: MaterialStateProperty.resolveWith(
                  (states) => HexColor("#1d1c2e")),
              backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => HexColor("#1d1c2e"))),
          onPressed: onPressed,
          child: Row(
            children: [
              Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: SvgPicture.asset(
                    "assets/icons/ver_incidencias.svg",
                    width: 30,
                    height: 30,
                    color: HexColor("#9FDF20"),
                    fit: BoxFit.cover,
                  )),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 10),
                child: Text(
                  "Ver incidentes",
                  style: TextStyle(fontSize: 16, color: HexColor("#9FDF20")),
                ),
              )
            ],
          )),
    );
  }
}

class ReportButton extends StatelessWidget {
  final Function() onPressed;
  const ReportButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 40),
      child: TextButton(
          style: ButtonStyle(
              fixedSize: MaterialStateProperty.resolveWith(
                  (states) => const Size(280, 50)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
              overlayColor: MaterialStateProperty.resolveWith(
                  (states) => HexColor("#1d1c2e")),
              backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => HexColor("#1d1c2e"))),
          onPressed: onPressed,
          child: Row(
            children: [
              Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: SvgPicture.asset(
                    "assets/icons/untitled.svg",
                    width: 30,
                    height: 30,
                    color: HexColor("#9FDF20"),
                    fit: BoxFit.cover,
                  )),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  "Reporte de incidentes",
                  style: TextStyle(fontSize: 16, color: HexColor("#9FDF20")),
                ),
              )
            ],
          )),
    );
  }
}
