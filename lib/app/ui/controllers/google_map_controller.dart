import 'dart:developer';

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skg_refactoring/app/api/api_list_incidents.dart';
import 'package:skg_refactoring/app/models/incidents_model.dart';
import 'package:skg_refactoring/app/ui/controllers/filter_controller.dart';
import 'package:skg_refactoring/app/utils/hex_color.dart';

class MapGoogleController extends GetxController {
  static MapGoogleController initializeController() {
    try {
      MapGoogleController controller = Get.find<MapGoogleController>();
      return controller;
    } catch (e) {
      MapGoogleController controller = Get.put(MapGoogleController());
      return controller;
    }
  }

  final FilterController _filterController =
      FilterController.initializeController();

  final initialCamaraPosition =
      const CameraPosition(target: LatLng(4.671305, -74.107462), zoom: 11);

  RxMap<MarkerId, Marker> marker = <MarkerId, Marker>{}.obs;

  Set<Marker> get markers => marker.values.toSet();

  RxBool isLoading = false.obs;
  RxBool isTap = false.obs;
  RxBool isFilter = false.obs;

  RxList<Incidents> incidentes = <Incidents>[].obs;

  Incidents? _incidente;
  Incidents? get incidente => _incidente;

  RxString location = "".obs;
  RxInt orient = 0.obs;
  RxInt propertiesClass = 0.obs;
  RxString showDate = "".obs;
  RxString year = "".obs;
  RxString mounth = "".obs;
  RxString day = "".obs;

  RxList<Incidents> incidentesFilter = <Incidents>[].obs;

  Future<void> createMarkers() async {
    log("Cargando");
    try {
      await getIncidents();
      if (incidentes.isNotEmpty) {
        await _makeMarkers(incidentes);
        log("Carga completa");
      } else {
        log("no hay marcadores");
      }
    } catch (e) {
      log("Error createMarkers MapGoogleController: $e");
    }
    for (var e in marker.values) {
      log("marcador (${e.markerId}): ${e.position}");
    }
    // log("${marker.length}");
    // isLoading.value = false;
  }

  Future<void> getIncidents() async {
    incidentes.value = (await MyApiIncidents.instance.getListIncidents()) ?? [];
    _filterController.incidentes.value = incidentes.value;
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

  Future<void> _makeMarkers(List<Incidents> list) async {
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
      marker[markerId] = newMarker;
    }
  }

  Future<void> getIncidentsFilter() async {
    isLoading.value = true;
    log("${incidentes.length}");
    incidentesFilter.clear();

    if (showDate.value != "") {
      if (location.value != "" &&
          orient.value == 0 &&
          propertiesClass.value == 0) {
        incidentesFilter.value = incidentes
            .where((e) =>
                e.properties.location == location.value &&
                isDateEqual(e.properties.incidentTime))
            .toList();
        log("${incidentesFilter.length}");
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
        log("${incidentesFilter.length}");
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
        log("${incidentesFilter.length}");
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
        log("${incidentesFilter.length}");
      }
      if (location.value == "" &&
          orient.value != 0 &&
          propertiesClass.value == 0) {
        incidentesFilter.value = incidentes
            .where((e) =>
                isDateEqual(e.properties.incidentTime) &&
                e.properties.orient == orient.value)
            .toList();
        log("${incidentesFilter.length}");
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
        log("${incidentesFilter.length}");
      }
      if (location.value == "" &&
          orient.value == 0 &&
          propertiesClass.value != 0) {
        incidentesFilter.value = incidentes
            .where((e) =>
                isDateEqual(e.properties.incidentTime) &&
                e.properties.propertiesClass == propertiesClass.value)
            .toList();
        log("${incidentesFilter.length}");
      }
      incidentesFilter.value = incidentes
          .where((e) => isDateEqual(e.properties.incidentTime))
          .toList();
      log("${incidentesFilter.length}");
    }
    if (showDate.value == "") {
      if (location.value != "" &&
          orient.value == 0 &&
          propertiesClass.value == 0) {
        incidentesFilter.value = incidentes
            .where((e) => e.properties.location == location.value)
            .toList();
        log("${incidentesFilter.length}");
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
        log("${incidentesFilter.length}");
      }
      if (location.value != "" &&
          orient.value != 0 &&
          propertiesClass.value == 0) {
        incidentesFilter.value = incidentes
            .where((e) =>
                e.properties.location == location.value &&
                e.properties.orient == orient.value)
            .toList();
        log("${incidentesFilter.length}");
      }
      if (location.value != "" &&
          orient.value == 0 &&
          propertiesClass.value != 0) {
        incidentesFilter.value = incidentes
            .where((e) =>
                e.properties.location == location.value &&
                e.properties.propertiesClass == propertiesClass.value)
            .toList();
        log("${incidentesFilter.length}");
      }
      if (location.value == "" &&
          orient.value != 0 &&
          propertiesClass.value == 0) {
        incidentesFilter.value = incidentes
            .where((e) => e.properties.orient == orient.value)
            .toList();
        log("${incidentesFilter.length}");
      }
      if (location.value == "" &&
          orient.value != 0 &&
          propertiesClass.value != 0) {
        incidentesFilter.value = incidentes
            .where((e) =>
                e.properties.orient == orient.value &&
                e.properties.propertiesClass == propertiesClass.value)
            .toList();
        log("${incidentesFilter.length}");
      }
      if (location.value == "" &&
          orient.value == 0 &&
          propertiesClass.value != 0) {
        incidentesFilter.value = incidentes.where((e) {
          return e.properties.propertiesClass == propertiesClass.value;
        }).toList();
      }
    }

    try {
      if (incidentesFilter.isNotEmpty) {
        marker.clear();
        await _makeMarkers(incidentesFilter);
        log("Carga completa");
      } else {
        marker.clear();
        await _makeMarkers(incidentes);
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
    } catch (e) {
      log("Error createMarkers FilterController: $e");
    }
    location = "".obs;
    orient = 0.obs;
    propertiesClass = 0.obs;
    log("${incidentesFilter.length}");
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

  clear() {
    marker.clear();
    incidentesFilter.clear();
    incidentes.clear();
    location = "".obs;
    orient = 0.obs;
    propertiesClass = 0.obs;
    showDate = "".obs;
    year = "".obs;
    mounth = "".obs;
    day = "".obs;
  }
}
