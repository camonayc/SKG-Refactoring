class PlaceLocation {
  PlaceLocation({
    required this.type,
    required this.query,
    required this.features,
    required this.attribution,
  });

  String type;
  List<double> query;
  List<FeaturePlace> features;
  String attribution;

  static PlaceLocation fromJson(Map<String, dynamic> json) => PlaceLocation(
        type: json["type"] ?? "",
        query: List<double>.from(json["query"].map((x) => x?.toDouble())),
        features: List<FeaturePlace>.from(
            json["features"].map((x) => FeaturePlace.fromJson(x))),
        attribution: json["attribution"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "type": type,
        "query": List<dynamic>.from(query.map((x) => x)),
        "features": List<dynamic>.from(features.map((x) => x.toMap())),
        "attribution": attribution,
      };
}

class FeaturePlace {
  FeaturePlace({
    required this.id,
    required this.type,
    required this.placeType,
    required this.relevance,
    required this.properties,
    required this.text,
    required this.placeName,
    required this.center,
    required this.geometry,
    required this.context,
  });

  String id;
  String type;
  List<String> placeType;
  int relevance;
  PropertiesPlace properties;
  String text;
  String placeName;
  List<double> center;
  GeometryPlace geometry;
  List<Context> context;

  static FeaturePlace fromJson(Map<String, dynamic> json) => FeaturePlace(
        id: json["id"] ?? "",
        type: json["type"] ?? "",
        placeType: List<String>.from(json["place_type"].map((x) => x)),
        relevance: json["relevance"] ?? "",
        properties: PropertiesPlace.fromJson(json["properties"]),
        text: json["text"] ?? "",
        placeName: json["place_name"] ?? "",
        center: List<double>.from(json["center"].map((x) => x?.toDouble())),
        geometry: GeometryPlace.fromJson(json["geometry"]),
        context: json["context"] != null
            ? List<Context>.from(
                json["context"].map((x) => Context.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "type": type,
        "place_type": List<dynamic>.from(placeType.map((x) => x)),
        "relevance": relevance,
        "properties": properties.toMap(),
        "text": text,
        "place_name": placeName,
        "center": List<dynamic>.from(center.map((x) => x)),
        "geometry": geometry.toMap(),
        "context": List<dynamic>.from(context.map((x) => x.toMap())),
      };
}

class Context {
  Context({
    required this.id,
    required this.mapboxId,
    required this.text,
    this.wikidata,
    this.shortCode,
  });

  String id;
  String mapboxId;
  String text;
  String? wikidata;
  String? shortCode;

  static Context fromJson(Map<String, dynamic> json) => Context(
        id: json["id"] ?? "",
        mapboxId: json["mapbox_id"] ?? "",
        text: json["text"] ?? "",
        wikidata: json["wikidata"] ?? "",
        shortCode: json["short_code"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "mapbox_id": mapboxId,
        "text": text,
        "wikidata": wikidata,
        "short_code": shortCode,
      };
}

class GeometryPlace {
  GeometryPlace({
    required this.type,
    required this.coordinates,
  });

  String type;
  List<double> coordinates;

  static GeometryPlace fromJson(Map<String, dynamic> json) => GeometryPlace(
        type: json["type"] ?? "",
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toMap() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
      };
}

class PropertiesPlace {
  PropertiesPlace({
    required this.accuracy,
  });

  String accuracy;

  static PropertiesPlace fromJson(Map<String, dynamic> json) => PropertiesPlace(
        accuracy: json["accuracy"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "accuracy": accuracy,
      };
}
