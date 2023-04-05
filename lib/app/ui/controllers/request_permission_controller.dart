import 'dart:async';
import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart' as ss show ServiceStatus;
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skg_refactoring/app/routes/routes.dart';

class RequestPermissionController extends GetxController {
  static RequestPermissionController initializeController() {
    try {
      RequestPermissionController controller =
          Get.find<RequestPermissionController>();
      return controller;
    } catch (e) {
      RequestPermissionController controller =
          Get.put(RequestPermissionController());
      return controller;
    }
  }

  final Permission _locationPermission = Permission.location;

  // Permission get locationPermission => _locationPermission;

  // RequestPermissionController(this._locationPermission);

  final _streamController = StreamController<PermissionStatus>.broadcast();

  Stream<PermissionStatus> get onStatusChange => _streamController.stream;

  RxBool fromSettings = false.obs;

  @override
  void onInit() {
    check();
    listenGPS();
    listenGPSenable();
    super.onInit();
    // log("reques: request iniciado");
  }

  void listenGPSenable() {
    Geolocator.getServiceStatusStream().listen((event) async {
      if (event == ss.ServiceStatus.disabled) {
        log("Sin gps activelo");
      }
      if (event == ss.ServiceStatus.enabled) {
        log("Sin gps activelo");
      }
      log("reques: $event");
    });
  }

  void listenGPS() {
    _streamController.stream.listen((status) async {
      switch (status) {
        case PermissionStatus.granted:
          Get.offAllNamed(AppRoutes.HOME);
          break;
        case PermissionStatus.denied:
          Get.offAllNamed(AppRoutes.GPS);
          break;
        case PermissionStatus.permanentlyDenied:
          fromSettings.value = true;
          Get.offAllNamed(AppRoutes.GPS);
          // fromSettings.value = await openAppSettings();
          break;
        default:
          break;
      }
    });
  }

  Future<PermissionStatus> check() async {
    final status = await _locationPermission.status;
    return status;
  }

  Future<void> request() async {
    final status = await _locationPermission.request();
    _notify(status);
  }

  void _notify(PermissionStatus status) {
    if (!_streamController.isClosed && _streamController.hasListener) {
      _streamController.sink.add(status);
    }
  }

  void dispose() {
    _streamController.close();
  }
}
