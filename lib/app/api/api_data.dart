import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:skg_refactoring/app/models/clase_model.dart';
import 'package:skg_refactoring/app/models/localidad_model.dart';
import 'package:skg_refactoring/app/models/orientacion_model.dart';

class MyApiData {
  MyApiData._internal();
  static final MyApiData _instance = MyApiData._internal();
  static MyApiData get instance => _instance;

  static String urlProduction =
      "https://history-service-dot-smart-helios-sit.appspot.com/sit/incidents/categories/type";
  static String urlDev =
      "https://history-service-dot-smart-helios-sit-qa-292412.uc.r.appspot.com/sit/incidents/categories/type";

  final Dio _dio = Dio(BaseOptions(baseUrl: urlProduction));

  Future<List<Localidad>?> getLocalidadList() async {
    try {
      final response = await _dio.get("/1");
      final data = Localidad.listLocalidadFromJson(response.data);
      log("Localidades: ${data.length}");
      if (data.isNotEmpty) {
        return data;
      } else {
        return [];
      }
    } catch (e) {
      log("$e");
      return [];
    }
  }

  Future<List<Clases>?> getClaseList() async {
    try {
      final response = await _dio.get("/2");
      final data = Clases.listClasesFromJson(response.data);
      log("Clases: ${data.length}");
      if (data.isNotEmpty) {
        return data;
      } else {
        return [];
      }
    } catch (e) {
      log("$e");
    }
  }

  Future<List<Orientacion>?> getOrientacionList() async {
    try {
      final response = await _dio.get("/14");
      final data = Orientacion.listOrientacionFromJson(response.data);
      log("Orientaciones: ${data.length}");
      if (data.isNotEmpty) {
        return data;
      } else {
        return [];
      }
    } catch (e) {
      log("$e");
    }
  }
}
