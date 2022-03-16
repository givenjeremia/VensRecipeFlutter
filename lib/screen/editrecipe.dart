import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:vensrecipe_160419118_projectuas/class/class_categorylist.dart';
import 'package:vensrecipe_160419118_projectuas/class/class_recipe.dart';

class EditRecipe extends StatefulWidget {
  late final String recipe_id;
  EditRecipe({Key? key, required this.recipe_id}) : super(key: key);
  @override
  EditRecipeState createState() {
    return EditRecipeState();
  }
}

class EditRecipeState extends State<EditRecipe> {
  final _formKey = GlobalKey<FormState>();
  ClassRecipe? cr;
  TextEditingController _name_recipe = new TextEditingController();
  TextEditingController _desc_recipe = new TextEditingController();
  TextEditingController _ingredients = new TextEditingController();
  TextEditingController _cooking_method = new TextEditingController();

  Future<String> fetchData() async {
    print("Masuk Gays");
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419118/VensRecipe/recipe.php"),
        body: {'recipes_id': widget.recipe_id.toString()});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  late List? namaCate = [];
  bacaData() {
    fetchData().then((value) {
      Map json = jsonDecode(value);
      if (json['result'] == 'success') {
        cr = ClassRecipe.fromJson(json['data'][0]);
        setState(() {
          _name_recipe.text = cr!.name_recipe!;
          _desc_recipe.text = cr!.desc_recipe!;
          _ingredients.text = cr!.ingredients!;
          _cooking_method.text = cr!.cooking_method!;
        });
      } else {
        return CircularProgressIndicator();
      }
    });
  }

  //Update Recipe Fun
  void UpdateRecipe() async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.fun/flutter/160419118/VensRecipe/updaterecipe.php"),
        body: {
          'nama_recipes': cr!.name_recipe,
          'description_recipe': cr!.desc_recipe,
          'bahan_bahan': cr!.ingredients,
          'cara_memasak': cr!.cooking_method,
          'id_recipe': widget.recipe_id.toString()
        });
    if (response.statusCode == 200) {
      print(response.body);
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Success Change Recipe')));
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  //CMB

  Future<List> daftarCategory() async {
    Map json;
    print("Dattar " + widget.recipe_id.toString());
    final response = await http.post(
        Uri.parse(
            "https://ubaya.fun/flutter/160419118/VensRecipe/categorylist.php"),
        body: {'recipe_id': widget.recipe_id.toString()});
    if (response.statusCode == 200) {
      // print(response.body);
      json = jsonDecode(response.body);
      print(json['data']);
      return json['data'];
    } else {
      throw Exception('Failed to read API');
    }
  }

  Widget comboGenre = Text('Add Category');

  void generateComboGenre() {
    //widget function for city list
    var data = daftarCategory();
    print("Test");
    print(data);
    List<ClassCategoryList> category = [];
    data.then((value) {
      print(value);
      for (var cate in value) {
        print(cate);
        ClassCategoryList cc = ClassCategoryList.fromJson(cate);
        category.add(cc);
      }
      // print(category);
      // category = List<ClassCategoryList>.from(value.map((i) {
      //   return ClassCategoryList.fromJSON(i);
      // }));
      if (category != null) {
        comboGenre = DropdownButton(
            dropdownColor: Colors.black,
            hint: Text("Tambah Genre"),
            isDense: false,
            items: category.map((cate) {
              return DropdownMenuItem(
                child: Column(children: <Widget>[
                  Text(cate.name_category, overflow: TextOverflow.visible),
                ]),
                value: cate.id_category,
              );
            }).toList(),
            onChanged: (value) {
              print(value);
              addCategory(value);
            });
      } else {
        return CircularProgressIndicator();
      }
    });
  }

  void addCategory(categoryID) async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.fun/flutter/160419118/VensRecipe/addcategory.php"),
        body: {
          'category_id': categoryID.toString(),
          'recipe_id': widget.recipe_id.toString()
        });
    if (response.statusCode == 200) {
      print(response.body);
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Success Add Category')));
        setState(() {
          bacaData();
        });
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  void deleteCategory(categoryID) async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.fun/flutter/160419118/VensRecipe/deletecategory.php"),
        body: {
          'category_id': categoryID.toString(),
          'recipe_id': widget.recipe_id.toString()
        });
    if (response.statusCode == 200) {
      print(response.body);
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Success Delete Category')));
        setState(() {
          bacaData();
        });
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  void initState() {
    super.initState();
    bacaData();
    daftarCategory();
    setState(() {
      generateComboGenre();
    });
    // imageCache!.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Recipe"),
        ),
        body: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Name Recipe',
                        ),
                        onChanged: (value) {
                          cr!.name_recipe = value;
                        },
                        controller: _name_recipe,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name Recipe Dont Empty';
                          }
                          return null;
                        },
                      )),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Description Recipe',
                        ),
                        onChanged: (value) {
                          cr!.desc_recipe = value;
                        },
                        controller: _desc_recipe,
                      )),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Ingredients',
                        ),
                        onChanged: (value) {
                          cr!.ingredients = value;
                        },
                        controller: _ingredients,
                        keyboardType: TextInputType.multiline,
                        minLines: 4,
                        maxLines: 6,
                      )),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Cooking Metode',
                        ),
                        onChanged: (value) {
                          cr!.cooking_method = value;
                        },
                        controller: _cooking_method,
                        keyboardType: TextInputType.multiline,
                        minLines: 3,
                        maxLines: 6,
                      )),
                  Padding(
                      padding: EdgeInsets.all(10), child: Text("Category :")),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: cr!.category!.length == 0
                          ? Center(child: Text('Empty'))
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: cr!.category!.length,
                              itemBuilder: (BuildContext ctxt, int index) {
                                return new Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .center, //Center Row contents horizontally,
                                  crossAxisAlignment: CrossAxisAlignment
                                      .center, //Center Row contents vertically,
                                  children: [
                                    Text(cr!.category![index]['nama_category'] +
                                        "  "),
                                    ElevatedButton(
                                        onPressed: () {
                                          deleteCategory(cr!.category![index]
                                              ['idcategory']);
                                        },
                                        child: new Icon(Icons.delete))
                                  ],
                                );
                              })),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: comboGenre),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Harap Isian diperbaiki')));
                        } else {
                          UpdateRecipe();
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ),
                ]))));
  }
}
