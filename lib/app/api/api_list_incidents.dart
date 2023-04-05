import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:skg_refactoring/app/models/incidents_model.dart';

class MyApiIncidents {
  MyApiIncidents._internal();
  static final MyApiIncidents _instance = MyApiIncidents._internal();
  static MyApiIncidents get instance => _instance;

  static String prodAPI =
      "http://34.173.111.166:9100/v1/incidents?closed=false";
  static String devAPI =
      "http://190.144.134.226:9100/v1/incidents?closed=false";

  final Dio _dio = Dio(BaseOptions(baseUrl: prodAPI));

  Future<List<Incidents>?> getListIncidents() async {
    try {
      final response = await _dio.get("");
      final data = Incidents.listLocalidadFromJson(response.data['features']);
      return data;
    } catch (e) {
      log("Api list incidents error: $e");
      return [];
    }
  }
}
