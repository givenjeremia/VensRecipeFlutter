import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vensrecipe_160419118_projectuas/class/class_recipe.dart';
import 'detailrecipe.dart';

class Recipe extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RecipeState();
  }
}

class _RecipeState extends State<Recipe> {
  String _temp = 'waiting API respond…';
  String _txtcari = "";

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419118/VensRecipe/recipe.php"),
        body: {'cari': _txtcari});
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Load Recipe')));
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

      for (var recipe in json['data']) {
        ClassRecipe cr = ClassRecipe.fromJson(recipe);
        RECIPEs.add(cr);

        // RECIPEs.add(pm);
      }
      setState(() {
        // _temp = RECIPEs[0].title;
      });
    });
  }

  Widget DaftarRecipe(Recipes) {
    if (Recipes.length > 0) {
      return GridView.builder(
          itemCount: Recipes.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 4 / 3,
            crossAxisCount: 2,
          ),
          itemBuilder: (BuildContext ctxt, int index) {
            return Padding(
                padding: EdgeInsets.all(5),
                child: Card(
                    semanticContainer: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    clipBehavior: Clip.antiAlias,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                                child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        "https://ubaya.fun/flutter/160419118/VensRecipe/image/recipe/" +
                                            RECIPEs[index]
                                                .image_link
                                                .toString()),
                                    fit: BoxFit.fill),
                              ),
                            )),
                            Center(
                                child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      RECIPEs[index].name_recipe.toString(),
                                      style: TextStyle(fontSize: 18.0),
                                    ))),
                          ],
                        ))));
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
        // appBar: AppBar(title: const Text('Recipe')),
        body: ListView(children: <Widget>[
      TextFormField(
        decoration: const InputDecoration(
          icon: Icon(Icons.search),
          labelText: 'Input Name Recipe:',
        ),
        onFieldSubmitted: (value) {
          _txtcari = value;
          bacaData();
        },
      ),
      Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(bottom: 58),
        // width: MediaQuery.of(context).size.width,
        child: DaftarRecipe(RECIPEs),
      ),
      // Padding(
      //   padding: ,
      // )
    ]));
  }
}
