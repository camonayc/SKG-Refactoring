import 'dart:convert';

class Localidad {
  Localidad({
    required this.id,
    required this.categoryType,
    required this.categoryState,
    required this.categoryName,
    this.parentId,
  });

  int id;
  int categoryType;
  bool categoryState;
  String categoryName;
  dynamic parentId;

  static Localidad fromJson(Map<String, dynamic> json) => Localidad(
        id: json["id"],
        categoryType: json["category_type"],
        categoryState: json["category_state"],
        categoryName: json["category_name"],
        parentId: json["parent_id"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "category_type": categoryType,
        "category_state": categoryState,
        "category_name": categoryName,
        "parent_id": parentId,
      };

  static List<Localidad> listLocalidadFromJson(List<dynamic> list) =>
      List<Localidad>.from(list.map((x) => Localidad.fromJson(x)));
}
