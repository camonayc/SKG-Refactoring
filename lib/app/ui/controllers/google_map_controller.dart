import 'dart:developer';

import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skg_refactoring/app/api/api_list_incidents.dart';
import 'package:skg_refactoring/app/models/incidents_model.dart';
import 'package:skg_refactoring/app/ui/controllers/filter_controller.dart';

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

  RxBool isLoadin = false.obs;
  RxBool isTap = false.obs;

  RxList<Incidents> incidentes = <Incidents>[].obs;

  Incidents? _incidente;
  Incidents? get incidente => _incidente;

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
    isLoadin.value = false;
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

  Set<Marker> getSetMarker(Map<MarkerId, Marker> markerMap) {
    return markerMap.values.toSet();
  }
}
