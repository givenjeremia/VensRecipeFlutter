class ClassRecipe {
  final int? idrecipes;
  String? username;
  String? name_recipe;
  String? desc_recipe;
  String? ingredients;
  String? cooking_method;
  String? image_link;
  final List? category;

  ClassRecipe({
    required this.idrecipes,
    required this.username,
    required this.name_recipe,
    required this.desc_recipe,
    required this.ingredients,
    required this.cooking_method,
    required this.image_link,
    required this.category,
  });
  factory ClassRecipe.fromJson(Map<String, dynamic> json) {
    return ClassRecipe(
      idrecipes: json['idrecipes'],
      username: json['username'],
      name_recipe: json['nama_recipes'],
      desc_recipe: json['description_recipe'],
      ingredients: json['bahan_bahan'],
      cooking_method: json['cara_memasak'],
      image_link: json['image_link'],
      category: json['category'],
    );
  }
}

List<ClassRecipe> RECIPEs = [];
