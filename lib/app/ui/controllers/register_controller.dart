import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as mat;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as im;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skg_refactoring/app/api/api_post_new_incident.dart';
import 'package:skg_refactoring/app/models/clase_model.dart';
import 'package:skg_refactoring/app/models/localidad_model.dart';
import 'package:skg_refactoring/app/models/new_incident_model.dart';
import 'package:skg_refactoring/app/models/orientacion_model.dart';
import 'package:skg_refactoring/app/models/place_location_model.dart';
import 'package:skg_refactoring/app/routes/routes.dart';
import 'package:skg_refactoring/app/ui/controllers/get_data_controller.dart';
import 'package:skg_refactoring/app/utils/hex_color.dart';

class RegisterController extends GetxController {
  static RegisterController initializeController() {
    try {
      RegisterController controller = Get.find<RegisterController>();
      return controller;
    } catch (e) {
      RegisterController controller = Get.put(RegisterController());
      return controller;
    }
  }

  final GetDataController _getDataController =
      GetDataController.initializeController();

  RxList<Localidad> localidades = <Localidad>[].obs;
  RxList<Clases> clases = <Clases>[].obs;
  RxList<Orientacion> orientacion = <Orientacion>[].obs;

  RxBool isLoading = false.obs;
  RxBool thereIsPlace = false.obs;

  RxBool photoTake1 = false.obs;
  RxBool photoTake2 = false.obs;

  Rx<XFile> photo1 = XFile("").obs;
  Rx<XFile> photo2 = XFile("").obs;

  List<DropdownMenuItem> elementLocalidad = <DropdownMenuItem>[].obs;
  List<DropdownMenuItem> elementClases = <DropdownMenuItem>[].obs;
  List<DropdownMenuItem> elementOrientacion = <DropdownMenuItem>[].obs;

  RxString address = "No data".obs;
  RxString location = "".obs;
  RxString descriptionData = "".obs;
  RxInt orient = 0.obs;
  RxInt propertiesClass = 0.obs;
  RxList<String> photosInciden = <String>[].obs;

  RxString photo1_64 = "".obs;
  RxString photo2_64 = "".obs;

  Rx<Placemark> placeMarker = Placemark().obs;

  Position? _initialPosition;
  Position? get initialPosition => _initialPosition;

  PlaceLocation? _currerUserPlace;
  PlaceLocation? get currerUserPlace => _currerUserPlace;

  Future<void> getListData() async {
    isLoading.value = true;

    elementLocalidad = elementsLocalidad(_getDataController.localidades);
    elementClases = elementsClases(_getDataController.clases);
    elementOrientacion = elementsOrientacion(_getDataController.orientacion);

    address.value =
        "${_getDataController.placeMarker.value.street}, ${_getDataController.placeMarker.value.postalCode} ${_getDataController.placeMarker.value.administrativeArea}, ${_getDataController.placeMarker.value.country}";
    if (address.toLowerCase().contains("Bogotá".toLowerCase()) ||
        address.toLowerCase().contains("Cundinamarca".toLowerCase())) {
      thereIsPlace.value = true;
    }
    log(address.value);
    isLoading.value = false;
    update();
  }

  Future<void> createNewIndicent() async {
    isLoading.value = true;
    try {
      if (photo1.value.path != "" && photo2.value.path != "") {
        photo1_64.value = await convertToBase64(photo1.value.path);
        photo2_64.value = await convertToBase64(photo2.value.path);

        photosInciden.add(photo1_64.value);
        photosInciden.add(photo2_64.value);
      }
      if (photo1.value.path != "" && photo2.value.path == "") {
        photo1_64.value = await convertToBase64(photo1.value.path);

        photosInciden.add(photo1_64.value);
      }
      if (photo1.value.path == "" && photo2.value.path != "") {
        photo1_64.value = await convertToBase64(photo1.value.path);

        photosInciden.add(photo2_64.value);
      }

      final newIncident = NewIncident(
          type: "Feature",
          photos: photosInciden.value,
          geometry: Geometry(type: "Point", coordinates: [
            _getDataController.lng.value,
            _getDataController.lat.value
          ]),
          properties: Properties(
              incidentTime: DateTime.now().microsecondsSinceEpoch,
              address: address.value,
              description: descriptionData.value,
              location: location.value,
              orient: orient.value,
              propertiesClass: propertiesClass.value));
      var response = await MyApiNewIncident.instance
          .postNewIncident(newIncident: newIncident);
      if (response == 201) {
        log("Se subio correctamente");
        _getDataController.onInit();
        Get.offAllNamed(AppRoutes.HOME);
        Get.defaultDialog(
          title: "Incidente creado",
          middleText: "Sea ha creado correctamente el incidente",
          titleStyle: const TextStyle(color: Colors.white),
          middleTextStyle: const TextStyle(color: Colors.white),
          backgroundColor: HexColor("#242C40"),
        );
        clear();
        isLoading.value = false;
      } else {
        _getDataController.onInit();
        Get.offAllNamed(AppRoutes.HOME);
        Get.defaultDialog(
          title: "Error",
          middleText:
              "No se pudo subir el incidente, verifica que llenaste correctamente los campos",
          titleStyle: const TextStyle(color: Colors.white),
          middleTextStyle: const TextStyle(color: Colors.white),
          backgroundColor: HexColor("#242C40"),
        );
        clear();
        isLoading.value = false;
      }
    } catch (e) {
      log("Error createdNewIncident funtion: $e");
      _getDataController.onInit();
      Get.offAllNamed(AppRoutes.HOME);
      Get.defaultDialog(
        title: "Error",
        middleText: "Se produjo un error, por favor intente mas tarde",
        titleStyle: const TextStyle(color: Colors.white),
        middleTextStyle: const TextStyle(color: Colors.white),
        backgroundColor: HexColor("#242C40"),
      );

      clear();
      isLoading.value = false;
    }
    isLoading.value = false;
  }

  List<DropdownMenuItem> elementsLocalidad(List<Localidad> list) {
    List<DropdownMenuItem> newusers = [];

    for (var i = 0; i < list.length; i++) {
      newusers.add(DropdownMenuItem(
        value: list[i].id,
        child: Text(
          list[i].categoryName,
          style: TextStyle(color: HexColor("#E6EFFD")),
        ),
      ));
    }

    return newusers;
  }

  List<DropdownMenuItem> elementsClases(List<Clases> list) {
    List<DropdownMenuItem> newusers = [];

    for (var i = 0; i < list.length; i++) {
      newusers.add(DropdownMenuItem(
        value: list[i].id,
        child: Text(
          list[i].categoryName,
          style: TextStyle(color: HexColor("#E6EFFD")),
        ),
      ));
    }

    return newusers;
  }

  List<DropdownMenuItem> elementsOrientacion(List<Orientacion> list) {
    List<DropdownMenuItem> newusers = [];

    for (var i = 0; i < list.length; i++) {
      newusers.add(DropdownMenuItem(
        value: list[i].id,
        child: Text(
          list[i].categoryName,
          style: TextStyle(color: HexColor("#E6EFFD")),
        ),
      ));
    }

    return newusers;
  }

  Future<String> convertToBase64(String path) async {
    var pathDocument = (await pastJPGtoPNG(path)).path;
    if (pathDocument != "") {
      File documentFile = File(pathDocument);
      Uint8List documentBytes = await documentFile.readAsBytes();
      String base64String = base64.encode(documentBytes);
      return base64String;
    } else {
      return "";
    }
  }

  String getRandString(int len) {
    var random = mat.Random.secure();
    var values = List<int>.generate(len, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  Future<File> pastJPGtoPNG(String pathImage) async {
    Directory appDocDirectory = await getTemporaryDirectory();

    // Directory("${appDocDirectory.path}/${getRandString(5)}").create();

    im.Image image = im.decodeImage(File(pathImage).readAsBytesSync())!;

    // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
    im.Image thumbnail = im.copyResize(image, width: 1080, height: 1350);

    // Save the thumbnail as a PNG.
    var newImage = File('${appDocDirectory.path}/${getRandString(5)}.png')
      ..writeAsBytesSync(im.encodePng(thumbnail));
    log(newImage.path);
    return newImage;
  }

  clear() {
    isLoading = false.obs;
    thereIsPlace = false.obs;
    address = "No data".obs;
    location = "".obs;
    descriptionData = "".obs;
    orient = 0.obs;
    propertiesClass = 0.obs;
    photo1 = XFile("").obs;
    photo2 = XFile("").obs;
    photoTake1 = false.obs;
    photoTake2 = false.obs;
    photosInciden = <String>[].obs;

    log("Register Controller clear");
  }
}
