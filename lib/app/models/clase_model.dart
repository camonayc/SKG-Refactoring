class Clases {
  Clases({
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

  static Clases fromJson(Map<String, dynamic> json) => Clases(
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

  static List<Clases> listClasesFromJson(List<dynamic> list) =>
      List<Clases>.from(list.map((x) => Clases.fromJson(x)));
}
