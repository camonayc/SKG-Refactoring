class IncidentData {
  IncidentData({
    required this.type,
    required this.features,
  });

  String type;
  List<Incidents> features;

  static IncidentData fromJson(Map<String, dynamic> json) => IncidentData(
        type: json["type"],
        features: List<Incidents>.from(
            json["features"].map((x) => Incidents.fromJson(x))),
      );

  Map<String, dynamic> toMap() => {
        "type": type,
        "features": List<dynamic>.from(features.map((x) => x.toMap())),
      };
}

class Incidents {
  Incidents({
    required this.properties,
    required this.geometry,
    required this.type,
  });

  Properties properties;
  Geometry geometry;
  String type;

  static List<Incidents> listLocalidadFromJson(List<dynamic> list) =>
      List<Incidents>.from(list.map((x) => Incidents.fromJson(x)));

  static Incidents fromJson(Map<String, dynamic> json) => Incidents(
        properties: Properties.fromJson(json["properties"]),
        geometry: Geometry.fromJson(json["geometry"]),
        type: json["type"],
      );

  Map<String, dynamic> toMap() => {
        "properties": properties.toMap(),
        "geometry": geometry.toMap(),
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
    required this.id,
    this.type,
    this.source,
    this.state,
    this.priority,
    this.gravity,
    required this.propertiesClass,
    this.object,
    this.actor,
    required this.location,
    this.idUser,
    this.nameUser,
    this.brokerId,
    this.implicated,
    required this.address,
    this.zoneId,
    required this.orient,
    this.requireSupport,
    this.idUserModified,
    this.nameUserModified,
    this.typeOthers,
    required this.description,
    required this.photo,
    required this.closed,
    required this.timeStamp,
    required this.updatedate,
    required this.incidentTime,
    required this.public,
  });

  int id;
  dynamic type;
  dynamic source;
  dynamic state;
  dynamic priority;
  dynamic gravity;
  int propertiesClass;
  dynamic object;
  dynamic actor;
  String location;
  dynamic idUser;
  dynamic nameUser;
  dynamic brokerId;
  dynamic implicated;
  String address;
  dynamic zoneId;
  int orient;
  dynamic requireSupport;
  dynamic idUserModified;
  dynamic nameUserModified;
  dynamic typeOthers;
  String description;
  bool photo;
  bool closed;
  int timeStamp;
  int updatedate;
  int incidentTime;
  bool public;

  static Properties fromJson(Map<String, dynamic> json) => Properties(
        id: json["id"],
        type: json["type"],
        source: json["source"],
        state: json["state"],
        priority: json["priority"],
        gravity: json["gravity"],
        propertiesClass: json["class"],
        object: json["object"],
        actor: json["actor"],
        location: json["location"],
        idUser: json["id_user"],
        nameUser: json["name_user"],
        brokerId: json["broker_id"],
        implicated: json["implicated"],
        address: json["address"],
        zoneId: json["zone_id"],
        orient: json["orient"],
        requireSupport: json["require_support"],
        idUserModified: json["id_user_modified"],
        nameUserModified: json["name_user_modified"],
        typeOthers: json["type_others"],
        description: json["description"],
        photo: json["photo"],
        closed: json["closed"],
        timeStamp: json["time_stamp"],
        updatedate: json["updatedate"],
        incidentTime: json["incident_time"],
        public: json["public"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "type": type,
        "source": source,
        "state": state,
        "priority": priority,
        "gravity": gravity,
        "class": propertiesClass,
        "object": object,
        "actor": actor,
        "location": location,
        "id_user": idUser,
        "name_user": nameUser,
        "broker_id": brokerId,
        "implicated": implicated,
        "address": address,
        "zone_id": zoneId,
        "orient": orient,
        "require_support": requireSupport,
        "id_user_modified": idUserModified,
        "name_user_modified": nameUserModified,
        "type_others": typeOthers,
        "description": description,
        "photo": photo,
        "closed": closed,
        "time_stamp": timeStamp,
        "updatedate": updatedate,
        "incident_time": incidentTime,
        "public": public,
      };
}
