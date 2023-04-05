import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skg_refactoring/app/routes/routes.dart';
import 'package:skg_refactoring/app/ui/controllers/get_data_controller.dart';
import 'package:skg_refactoring/app/ui/controllers/google_map_controller.dart';
import 'package:skg_refactoring/app/utils/hex_color.dart';
import 'package:skg_refactoring/app/widgets/custom_drawer.dart';
import 'package:skg_refactoring/app/widgets/loading_screen..dart';

class GoogleMapPage extends StatelessWidget {
  final MapGoogleController _controller =
      MapGoogleController.initializeController();

  GoogleMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        drawerEnableOpenDragGesture: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: IconThemeData(color: HexColor("#242C40"), size: 35),
          elevation: 0,
          backgroundColor: const Color.fromARGB(0, 255, 255, 255),
          actions: [
            IconButton(
              splashRadius: 1,
              splashColor: HexColor("#242C40"),
              onPressed: () {
                Get.offAllNamed(AppRoutes.HOME);
              },
              icon: const Icon(Icons.close),
            )
          ],
        ),
        drawer: CustomDrawer(),
        body: Stack(
          children: [
            Obx(
              () => _controller.isLoadin.value == true
                  ? buildLoadingScreen()
                  : SizedBox(
                      height: size.height,
                      width: size.width,
                      child: GoogleMap(
                        zoomControlsEnabled: false,
                        compassEnabled: false,
                        rotateGesturesEnabled: false,
                        initialCameraPosition:
                            _controller.initialCamaraPosition,
                        markers: _controller.markers,
                        onMapCreated: (GoogleMapController mapController) {},
                      ),
                    ),
            ),
            markerCardData(_controller, context)
          ],
        ));
  }
}

Obx markerCardData(MapGoogleController controller, BuildContext context) {
  final size = MediaQuery.of(context).size;
  return Obx(() => controller.isTap.value == true
      ? Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: double.infinity,
              height: size.height * 0.35,
              decoration: BoxDecoration(
                  color: HexColor("#242C40"),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(60),
                  )),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              controller.isTap.value = false;
                            },
                            icon: Icon(
                              Icons.close,
                              color: HexColor("#9FDF20"), //* Color verde
                            ))
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 40, right: 40, bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  titelAndDescription(
                                      title: "ID",
                                      description:
                                          "${controller.incidente?.properties.id}"),
                                  titelAndDescription(
                                      title: "Clase",
                                      description: getClase(controller
                                          .incidente?.properties.propertiesClass
                                          .toString())),
                                ],
                              ),
                              SizedBox(
                                width: 70,
                                height: 70,
                                child: Image.asset(
                                    "assets/images/alerta_inactiva_sin_fondo.png"),
                              )
                            ],
                          ),
                          titelAndDescription(
                              title: "Localidad",
                              description: getLocalidad(
                                  controller.incidente?.properties.location)),
                          titelAndDescription2(
                              title: "Dirección",
                              description:
                                  "${controller.incidente?.properties.address}"),
                          titelAndDescription(
                              title: "Fecha",
                              description: getDate(controller
                                  .incidente?.properties.incidentTime)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        )
      : Container());
}

Widget titelAndDescription(
    {required String title, required String description}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "$title:",
          maxLines: 2,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: HexColor("#E6EFFD")),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          description,
          style: TextStyle(fontSize: 16, color: HexColor("#E6EFFD")),
        )
      ],
    ),
  );
}

Widget titelAndDescription2(
    {required String title, required String description}) {
  String newS = "";
  if (description.length > 20) {
    newS = "${description.substring(0, 20)}...";
  } else {
    newS = description;
  }
  return Container(
    margin: const EdgeInsets.only(bottom: 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: newS.length <= 20
          ? [
              Text(
                "$title:",
                maxLines: 2,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: HexColor("#E6EFFD")),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                newS,
                maxLines: 3,
                softWrap: true,
                textWidthBasis: TextWidthBasis.parent,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 16,
                  color: HexColor("#E6EFFD"),
                ),
              )
            ]
          : [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$title:",
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: HexColor("#E6EFFD")),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    description,
                    maxLines: 3,
                    softWrap: true,
                    textWidthBasis: TextWidthBasis.parent,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 16,
                      color: HexColor("#E6EFFD"),
                    ),
                  )
                ],
              ),
            ],
    ),
  );
}

String getDate(int? dateIncident) {
  final date =
      DateTime.fromMillisecondsSinceEpoch((dateIncident)!, isUtc: true);

  return "${date.day < 9 ? "0${date.day}" : "${date.day}"}-${date.month < 9 ? "0${date.month}" : "${date.month}"}-${date.year} ${date.hour < 9 ? "0${date.hour}" : "${date.hour}"}:${date.minute < 9 ? "0${date.minute}" : "${date.minute}"}";
}

String getLocalidad(String? id) {
  final getData = GetDataController.initializeController();
  return (getData.localidades.where((p0) => p0.id.toString() == id).first)
      .categoryName;
}

String getClase(String? id) {
  final getData = GetDataController.initializeController();
  return (getData.clases.where((p0) => p0.id.toString() == id).first)
      .categoryName;
}
