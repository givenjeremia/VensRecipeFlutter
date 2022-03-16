import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vensrecipe_160419118_projectuas/class/class_recipe.dart';
import 'package:vensrecipe_160419118_projectuas/screen/detailrecipe.dart';

class RecipeCategory extends StatefulWidget {
  final int category_id;
  RecipeCategory({Key? key, required this.category_id}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _RecipeCategoryState();
  }
}

class _RecipeCategoryState extends State<RecipeCategory> {
  String _temp = 'waiting API respond…';
  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419118/VensRecipe/recipe.php"),
        body: {'category_id': widget.category_id.toString()});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    RECIPEs.clear();
    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      for (var mov in json['data']) {
        ClassRecipe cr = ClassRecipe.fromJson(mov);
        RECIPEs.add(cr);
      }
      setState(() {
        // _temp = PMs[0].title;
      });
    });
  }

  Widget DaftarRecipeCategory(recipecategory) {
    if (recipecategory != null) {
      return ListView.builder(
          itemCount: recipecategory.length,
          itemBuilder: (BuildContext ctxt, int index) {
            print(RECIPEs[index].image_link);
            return new Card(
                child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailRecipe(
                              recipe_id: RECIPEs[index].idrecipes!),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: 44,
                              minHeight: 44,
                              maxWidth: 44,
                              maxHeight: 44,
                            ),
                            child: Image.network(
                                "https://ubaya.fun/flutter/160419118/VensRecipe/image/recipe/" +
                                    RECIPEs[index].image_link.toString(),
                                fit: BoxFit.cover),
                          ),
                          title: GestureDetector(
                              child:
                                  Text(RECIPEs[index].name_recipe.toString()),
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) =>
                                //         DetailPop(movie_id: PMs[index].id!),
                                //   ),
                                // );
                              }),
                          subtitle: Text(RECIPEs[index].desc_recipe.toString()),
                        ),
                      ],
                    )));
          });
    } else {
      return CircularProgressIndicator();
    }
  }

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Recipe Category')),
        body: PageView(children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            child: DaftarRecipeCategory(RECIPEs),
          ),
        ]));
  }
}
