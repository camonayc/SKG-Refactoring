import 'dart:async';
import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart' as ss show ServiceStatus;
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skg_refactoring/app/models/place_location_model.dart';
import 'package:skg_refactoring/app/routes/routes.dart';
import 'package:skg_refactoring/app/ui/controllers/get_data_controller.dart';
import 'package:skg_refactoring/app/ui/controllers/home_controller.dart';

class GPSController extends GetxController {
  static GPSController initializeController() {
    try {
      GPSController controller = Get.find<GPSController>();
      return controller;
    } catch (e) {
      GPSController controller = Get.put(GPSController());
      return controller;
    }
  }

  final HomeController _homeController = HomeController.initializeController();

  RxBool isConnection = false.obs;

  @override
  void onInit() async {
    super.onInit();
    final status = await Geolocator.isLocationServiceEnabled();
    if (!status) {
      Get.offAllNamed(AppRoutes.GPS);
    }
    if (status) {
      await _init();
      _initialPosition = await Geolocator.getCurrentPosition();
      final permission = await Geolocator.isLocationServiceEnabled();
      log("$permission");
      if (permission) {
        final position = await Geolocator.getCurrentPosition();
        lat.value = position.latitude;
        lng.value = position.longitude;

        _dataController.lat.value = position.latitude;
        _dataController.lng.value = position.longitude;

        Geolocator.getPositionStream().listen((position) {
          lat.value = position.latitude;
          lng.value = position.longitude;

          _dataController.lat.value = position.latitude;
          _dataController.lng.value = position.longitude;

          // log("gps: $lat, $lng");
          // log("getData: ${_dataController.lat}, ${_dataController.lng}");
        });
      }
    }
    Geolocator.getServiceStatusStream().listen((event) async {
      if (event == ss.ServiceStatus.disabled) {
        log("Sin gps activelo");
        Get.offNamed(AppRoutes.GPS);
      }
      if (event == ss.ServiceStatus.enabled) {
        _homeController.isLoading.value = true;
        Get.offAllNamed(AppRoutes.HOME);
        await _init();
        _initialPosition = await Geolocator.getCurrentPosition();
        final permission = await Geolocator.isLocationServiceEnabled();
        log("$permission");
        if (permission) {
          final position = await Geolocator.getCurrentPosition();
          lat.value = position.latitude;
          lng.value = position.longitude;

          _dataController.lat.value = position.latitude;
          _dataController.lng.value = position.longitude;

          Geolocator.getPositionStream().listen((position) {
            lat.value = position.latitude;
            lng.value = position.longitude;

            _dataController.lat.value = position.latitude;
            _dataController.lng.value = position.longitude;

            // log("gps: $lat, $lng");
            // log("getData: ${_dataController.lat}, ${_dataController.lng}");
          });
        }

        log("gps: $lat, $lng");
        log("getData: ${_dataController.lat}, ${_dataController.lng}");
        log("gps conectado");
        _homeController.isLoading.value = false;
      }
      log("reques: $event");
    });
  }

  final GetDataController _dataController =
      GetDataController.initializeController();

  RxDouble lat = 0.0.obs;
  RxDouble lng = 0.0.obs;

  Position? _initialPosition;
  Position? get initialPosition => _initialPosition;

  PlaceLocation? _currerUserPlace;
  PlaceLocation? get currerUserPlace => _currerUserPlace;

  PermissionStatus? _permissionStatus;
  PermissionStatus? get permissionStatus => _permissionStatus;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> _init() async {
    setLoading(false);
    final permission = await Permission.location.request();
    _permissionStatus = permission;
    await _determinePosition();
    _initialPosition = await Geolocator.getCurrentPosition();
    update();
    await Future.delayed(const Duration(seconds: 2));
    setLoading(true);
  }

  setLoading(bool state) {
    _isLoading = state;
    update();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Geolocator.openLocationSettings();
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      // return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
