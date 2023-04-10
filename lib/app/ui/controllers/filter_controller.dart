import 'dart:developer';

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skg_refactoring/app/models/clase_model.dart';
import 'package:skg_refactoring/app/models/localidad_model.dart';
import 'package:skg_refactoring/app/models/orientacion_model.dart';
import 'package:skg_refactoring/app/routes/routes.dart';
import 'package:skg_refactoring/app/utils/hex_color.dart';

import '../../models/incidents_model.dart';

class FilterController extends GetxController {
  static FilterController initializeController() {
    try {
      FilterController controller = Get.find<FilterController>();
      return controller;
    } catch (e) {
      FilterController controller = Get.put(FilterController());
      return controller;
    }
  }

  RxBool showFilter = false.obs;
  RxBool isLoading = false.obs;
  RxBool isTap = false.obs;
  RxBool noIncidents = false.obs;

  RxMap<MarkerId, Marker> marker = <MarkerId, Marker>{}.obs;

  Set<Marker> get markers => marker.values.toSet();

  RxList<Localidad> localidades = <Localidad>[].obs;
  RxList<Clases> clases = <Clases>[].obs;
  RxList<Orientacion> orientacion = <Orientacion>[].obs;

  RxString location = "".obs;
  RxInt orient = 0.obs;
  RxInt propertiesClass = 0.obs;
  RxString showDate = "".obs;
  RxString year = "".obs;
  RxString mounth = "".obs;
  RxString day = "".obs;

  RxList<Incidents> incidentes = <Incidents>[].obs;

  RxList<Incidents> incidentesFilter = <Incidents>[].obs;

  Incidents? _incidente;
  Incidents? get incidente => _incidente;

  final initialCamaraPosition =
      const CameraPosition(target: LatLng(4.671305, -74.107462), zoom: 10.5);

  Set<Marker> getSetMarker(Map<MarkerId, Marker> markerMap) {
    return markerMap.values.toSet();
  }

  Future<Map<MarkerId, Marker>?> getIncidentsFilter() async {
    Map<MarkerId, Marker> newMarker = <MarkerId, Marker>{};
    isLoading.value = true;
    // Get.toNamed(AppRoutes.FILTER);
    log("${incidentes.length}");

    if (showDate.value != "") {
      if (location.value != "" &&
          orient.value == 0 &&
          propertiesClass.value == 0) {
        incidentesFilter.value = incidentes
            .where((e) =>
                e.properties.location == location.value &&
                isDateEqual(e.properties.incidentTime))
            .toList();
      }
      if (location.value != "" &&
          orient.value != 0 &&
          propertiesClass.value != 0) {
        incidentesFilter.value = incidentes
            .where((e) =>
                isDateEqual(e.properties.incidentTime) &&
                e.properties.location == location.value &&
                e.properties.orient == orient.value &&
                e.properties.propertiesClass == propertiesClass.value)
            .toList();
      }
      if (location.value != "" &&
          orient.value != 0 &&
          propertiesClass.value == 0) {
        incidentesFilter.value = incidentes
            .where((e) =>
                isDateEqual(e.properties.incidentTime) &&
                e.properties.location == location.value &&
                e.properties.orient == orient.value)
            .toList();
      }
      if (location.value != "" &&
          orient.value == 0 &&
          propertiesClass.value != 0) {
        incidentesFilter.value = incidentes
            .where((e) =>
                isDateEqual(e.properties.incidentTime) &&
                e.properties.location == location.value &&
                e.properties.propertiesClass == propertiesClass.value)
            .toList();
      }
      if (location.value == "" &&
          orient.value != 0 &&
          propertiesClass.value == 0) {
        incidentesFilter.value = incidentes
            .where((e) =>
                isDateEqual(e.properties.incidentTime) &&
                e.properties.orient == orient.value)
            .toList();
      }
      if (location.value == "" &&
          orient.value != 0 &&
          propertiesClass.value != 0) {
        incidentesFilter.value = incidentes
            .where((e) =>
                isDateEqual(e.properties.incidentTime) &&
                e.properties.orient == orient.value &&
                e.properties.propertiesClass == propertiesClass.value)
            .toList();
      }
      if (location.value == "" &&
          orient.value == 0 &&
          propertiesClass.value != 0) {
        incidentesFilter.value = incidentes
            .where((e) =>
                isDateEqual(e.properties.incidentTime) &&
                e.properties.propertiesClass == propertiesClass.value)
            .toList();
      }
      incidentesFilter.value = incidentes
          .where((e) => isDateEqual(e.properties.incidentTime))
          .toList();
    }
    if (showDate.value == "") {
      if (location.value != "" &&
          orient.value == 0 &&
          propertiesClass.value == 0) {
        incidentesFilter.value = incidentes
            .where((e) => e.properties.location == location.value)
            .toList();
      }
      if (location.value != "" &&
          orient.value != 0 &&
          propertiesClass.value != 0) {
        incidentesFilter.value = incidentes
            .where((e) =>
                e.properties.location == location.value &&
                e.properties.orient == orient.value &&
                e.properties.propertiesClass == propertiesClass.value)
            .toList();
      }
      if (location.value != "" &&
          orient.value != 0 &&
          propertiesClass.value == 0) {
        incidentesFilter.value = incidentes
            .where((e) =>
                e.properties.location == location.value &&
                e.properties.orient == orient.value)
            .toList();
      }
      if (location.value != "" &&
          orient.value == 0 &&
          propertiesClass.value != 0) {
        incidentesFilter.value = incidentes
            .where((e) =>
                e.properties.location == location.value &&
                e.properties.propertiesClass == propertiesClass.value)
            .toList();
      }
      if (location.value == "" &&
          orient.value != 0 &&
          propertiesClass.value == 0) {
        incidentesFilter.value = incidentes
            .where((e) => e.properties.orient == orient.value)
            .toList();
      }
      if (location.value == "" &&
          orient.value != 0 &&
          propertiesClass.value != 0) {
        incidentesFilter.value = incidentes
            .where((e) =>
                e.properties.orient == orient.value &&
                e.properties.propertiesClass == propertiesClass.value)
            .toList();
      }
      if (location.value == "" &&
          orient.value == 0 &&
          propertiesClass.value != 0) {
        incidentesFilter.value = incidentes
            .where((e) => e.properties.propertiesClass == propertiesClass.value)
            .toList();
      }
    }

    try {
      if (incidentesFilter.isNotEmpty) {
        newMarker = await _makeMarkers(list: incidentesFilter);
        log("Carga completa");
        return newMarker;
      } else {
        log("no hay marcadores");
        Get.defaultDialog(
          title: "Sin incidentes",
          middleText: "No se encontraron incidentes con esas características",
          titleStyle: const TextStyle(color: Colors.white),
          middleTextStyle: const TextStyle(color: Colors.white),
          backgroundColor: HexColor("#242C40"),
        );
      }
      isLoading.value = false;
      return newMarker;
    } catch (e) {
      log("Error createMarkers FilterController: $e");
    }
    location = "".obs;
    orient = 0.obs;
    propertiesClass = 0.obs;
    log("${incidentesFilter.length}");
    return newMarker;
  }

  Future<Uint8List> assetToBytes(String path, {int width = 60}) async {
    final byteData = await rootBundle.load(path);
    final bytes = byteData.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(bytes, targetWidth: width);
    final frame = await codec.getNextFrame();
    final newByteData =
        await frame.image.toByteData(format: ui.ImageByteFormat.png);
    return newByteData!.buffer.asUint8List();
  }

  Future<Map<MarkerId, Marker>> _makeMarkers(
      {required List<Incidents> list}) async {
    Map<MarkerId, Marker> markerss = {};
    final icon = BitmapDescriptor.fromBytes(
        await assetToBytes("assets/images/alerta_inactiva_sin_fondo.png"));
    for (Incidents e in list) {
      log("${e.geometry.coordinates}");
      final markerId = MarkerId(e.properties.id.toString());
      final newMarker = Marker(
          icon: icon,
          markerId: markerId,
          position:
              LatLng(e.geometry.coordinates[1], e.geometry.coordinates[0]),
          onTap: () async {
            isTap.value = false;
            isTap.value = true;
            _incidente = e;
            log("$isTap");
          });
      markerss[markerId] = newMarker;
    }
    return markerss;
  }

  bool isDateEqual(int dateInMili) {
    final date = DateTime.fromMillisecondsSinceEpoch((dateInMili), isUtc: true);
    if (date.day.toString() == day.value &&
        date.month.toString() == mounth.value &&
        date.year.toString() == year.value) {
      return true;
    } else {
      return false;
    }
  }

  clearData() {
    incidentesFilter = <Incidents>[].obs;
    marker = <MarkerId, Marker>{}.obs;
    noIncidents = false.obs;
    showDate = "".obs;
  }
}
