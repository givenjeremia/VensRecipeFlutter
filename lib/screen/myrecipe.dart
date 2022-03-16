import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vensrecipe_160419118_projectuas/class/class_recipe.dart';
import 'package:vensrecipe_160419118_projectuas/main.dart';
import 'package:vensrecipe_160419118_projectuas/screen/detailmyrecipe.dart';
import 'detailrecipe.dart';

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String username = prefs.getString("username") ?? '';
  return username;
}

class MyRecipe extends StatefulWidget {
  late final String username;
  MyRecipe({Key? key, required this.username}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _MyRecipeState();
  }
}

class _MyRecipeState extends State<MyRecipe> {
  String _temp = 'waiting API respond…';
  String active_user = "";
  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.fun/flutter/160419118/VensRecipe/myrecipe.php"),
        body: {'username': widget.username});

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Waiting')));
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

  // ignore: non_constant_identifier_names
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
                              builder: (context) => DetailMyRecipe(
                                  recipe_id: RECIPEs[index].idrecipes!,
                                  username: widget.username.toString()),
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
    checkUser().then((String result) {
      setState(() {
        active_user = result;
      });
    });
    bacaData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('My Recipe')),
        body: PageView(children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            // padding: EdgeInsets.only(bottom: 58),
            // width: MediaQuery.of(context).size.width,
            child: DaftarRecipe(RECIPEs),
          ),
          // Padding(
          //   padding: ,
          // )
        ]));
  }
}
