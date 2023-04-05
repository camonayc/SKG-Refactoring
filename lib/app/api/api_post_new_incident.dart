import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:skg_refactoring/app/models/new_incident_model.dart';

class MyApiNewIncident {
  MyApiNewIncident._internal();
  static final MyApiNewIncident _instance = MyApiNewIncident._internal();
  static MyApiNewIncident get instance => _instance;

  static String prodAPI =
      "http://34.173.111.166:9100/v1/incidents?closed=false";
  static String devAPI =
      "http://190.144.134.226:9100/v1/incidents?closed=false";

  final Dio _dio = Dio(BaseOptions(baseUrl: prodAPI));

  Future<int?> postNewIncident({required NewIncident newIncident}) async {
    try {
      final response = await _dio.post("", data: newIncident.toMap());
      log("${response.statusCode}");
      if (response.statusCode == 201) {
        return response.statusCode;
      } else {
        return null;
      }
    } catch (e) {
      log("$e");
      return null;
    }
  }
}
