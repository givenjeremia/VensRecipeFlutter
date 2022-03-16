import 'package:vensrecipe_160419118_projectuas/screen/category.dart';

class ClassCategory {
  // ignore: non_constant_identifier_names
  final int? id_category;
  // ignore: non_constant_identifier_names
  String? name_category;
  // ignore: non_constant_identifier_names
  String? desc_category;
  String? image;

  ClassCategory(
      // ignore: non_constant_identifier_names
      {required this.id_category,
      // ignore: non_constant_identifier_names
      required this.name_category,
      // ignore: non_constant_identifier_names
      required this.desc_category,
      required this.image,});
  factory ClassCategory.fromJson(Map<String, dynamic> json) {
    return ClassCategory(
        id_category: json['idcategory'],
        name_category: json['nama_category'],
        desc_category: json['description_category'],
        image: json['image']);
  }

  static void fromJSON(i) {}
}

List<ClassCategory> CATEGORYs = [];
