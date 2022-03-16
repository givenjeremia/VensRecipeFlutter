import 'package:vensrecipe_160419118_projectuas/screen/category.dart';

class ClassCategoryList {
  // ignore: non_constant_identifier_names
  final int id_category;
  // ignore: non_constant_identifier_names
  String name_category;
  // ignore: non_constant_identifier_names

  ClassCategoryList(
      // ignore: non_constant_identifier_names
      {required this.id_category,
      // ignore: non_constant_identifier_names
      required this.name_category});
  factory ClassCategoryList.fromJson(Map<String, dynamic> json) {
    return ClassCategoryList(
      id_category: json['idcategory'],
      name_category: json['nama_category'],
    );
  }

  static void fromJSON(i) {}
}
