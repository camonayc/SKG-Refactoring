import 'dart:developer';

import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:skg_refactoring/app/api/api_data.dart';
import 'package:skg_refactoring/app/models/clase_model.dart';
import 'package:skg_refactoring/app/models/localidad_model.dart';
import 'package:skg_refactoring/app/models/orientacion_model.dart';
import 'package:skg_refactoring/app/ui/controllers/filter_controller.dart';
import 'package:skg_refactoring/app/ui/controllers/register_controller.dart';

class GetDataController extends GetxController {
  static GetDataController initializeController() {
    try {
      GetDataController controller = Get.find<GetDataController>();
      return controller;
    } catch (e) {
      GetDataController controller = Get.put(GetDataController());
      return controller;
    }
  }

  final FilterController _filterController =
      FilterController.initializeController();

  @override
  void onInit() async {
    super.onInit();
    await _getData();
  }

  final apiData = MyApiData.instance;

  RxBool dataLoading = false.obs;

  RxDouble lat = 0.0.obs;
  RxDouble lng = 0.0.obs;

  RxList<Localidad> localidades = <Localidad>[].obs;
  RxList<Clases> clases = <Clases>[].obs;
  RxList<Orientacion> orientacion = <Orientacion>[].obs;

  Rx<Placemark> placeMarker = Placemark().obs;

  Future<void> _getData() async {
    dataLoading.value = true;

    try {
      localidades.value = (await apiData.getLocalidadList()) ?? [];
      clases.value = (await apiData.getClaseList()) ?? [];
      orientacion.value = (await apiData.getOrientacionList()) ?? [];
      _filterController.localidades.value = localidades.value;
      _filterController.clases.value = clases.value;
      _filterController.orientacion.value = orientacion.value;
    } catch (e) {
      log("GetDataController: getData error -> $e");
    }
    dataLoading.value = false;
  }

  Future<void> checkPlace() async {
    final register = RegisterController.initializeController();
    try {
      placeMarker.value =
          (await placemarkFromCoordinates(lat.value, lng.value)).first;
      register.placeMarker.value = placeMarker.value;
      log("${register.placeMarker.value = placeMarker.value}");
    } catch (e) {
      log("Error checkPlace GetDataController: $e");
    }
  }
}
