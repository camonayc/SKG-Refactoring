import 'package:skg_refactoring/app/models/new_incident_model.dart';

final newIncident = NewIncident(
    type: "Feature",
    photos: [],
    geometry: Geometry(type: "Point", coordinates: [-74.056997, 4.686714]),
    properties: Properties(
        incidentTime: DateTime.now().microsecondsSinceEpoch,
        address: "New direction with incident time",
        description: "There is a new description with incident time",
        location: "75",
        orient: 140,
        propertiesClass: 4));