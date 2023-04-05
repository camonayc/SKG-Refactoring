class NewIncident {
  NewIncident({
    required this.properties,
    required this.geometry,
    required this.photos,
    required this.type,
  });

  Properties properties;
  Geometry geometry;
  List<String> photos;
  String type;

  static NewIncident fromJson(Map<String, dynamic> json) => NewIncident(
        properties: Properties.fromJson(json["properties"]),
        geometry: Geometry.fromJson(json["geometry"]),
        photos: List<String>.from(json["photos"].map((x) => x)),
        type: json["type"],
      );

  Map<String, dynamic> toMap() => {
        "properties": properties.toMap(),
        "geometry": geometry.toMap(),
        "photos": List<dynamic>.from(photos.map((x) => x)),
        "type": type,
      };
}

class Geometry {
  Geometry({
    required this.type,
    required this.coordinates,
  });

  String type;
  List<double> coordinates;

  static Geometry fromJson(Map<String, dynamic> json) => Geometry(
        type: json["type"],
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toMap() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
      };
}

class Properties {
  Properties({
    required this.propertiesClass,
    required this.location,
    required this.address,
    required this.orient,
    required this.description,
    required this.incidentTime,
  });

  int propertiesClass;
  String location;
  String address;
  int orient;
  String description;
  int incidentTime;

  static Properties fromJson(Map<String, dynamic> json) => Properties(
      propertiesClass: json["class"],
      location: json["location"],
      address: json["address"],
      orient: json["orient"],
      description: json["description"],
      incidentTime: json['incident_time']);

  Map<String, dynamic> toMap() => {
        "class": propertiesClass,
        "location": location,
        "address": address,
        "orient": orient,
        "description": description,
        'incident_time': incidentTime
      };
}
