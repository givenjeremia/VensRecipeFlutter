import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vensrecipe_160419118_projectuas/class/class_recipe.dart';
import 'package:accordion/accordion.dart';
import 'package:vensrecipe_160419118_projectuas/screen/editrecipe.dart';
import 'package:vensrecipe_160419118_projectuas/screen/myrecipe.dart';
import 'package:vensrecipe_160419118_projectuas/screen/newrecipe.dart';

class DetailMyRecipe extends StatefulWidget {
  final int recipe_id;
  final String username;
  DetailMyRecipe({Key? key, required this.recipe_id, required this.username})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _DetailMyRecipeState();
  }
}

class _DetailMyRecipeState extends State<DetailMyRecipe> {
  var cr;
  @override
  void initState() {
    super.initState();
    bacaData();
    imageCache!.clear();
  }

  Future<String> fetchData() async {
    print(widget.recipe_id.toString());
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419118/VensRecipe/recipe.php"),
        body: {'recipes_id': widget.recipe_id.toString()});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  //Fun Delete
  void delete(int id, String recipe) async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.fun/flutter/160419118/VensRecipe/deleterecipe.php"),
        body: {
          'recipe_id': id.toString(),
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Recipe ' + recipe + " Is Success Delete")));
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    fetchData().then((value) {
      Map json = jsonDecode(value);
      print(json['data']);
      cr = ClassRecipe.fromJson(json['data'][0]);

      setState(() {});
    });
  }

  Future onGoBack(dynamic value) async {
    print("masuk goback");
    setState(() {
      bacaData();
    });
  }

  Widget tampilData() {
    if (cr != null) {
      return Card(
          elevation: 10,
          margin: EdgeInsets.all(10),
          child: Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(cr!.name_recipe!, style: TextStyle(fontSize: 25)),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                child: Image.network(
                    "https://ubaya.fun/flutter/160419118/VensRecipe/image/recipe/" +
                        cr!.image_link!),
              ),
            ),

            Padding(
                padding: EdgeInsets.all(10),
                child: Text(cr!.desc_recipe!, style: TextStyle(fontSize: 15))),
            Padding(padding: EdgeInsets.all(10), child: Text("Category :")),
            Padding(
                padding: EdgeInsets.all(10),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: cr!.category!.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return new Text(
                        cr!.category![index]['nama_category'],
                        textAlign: TextAlign.center,
                      );
                    })),
            Accordion(
              maxOpenSections: 2,
              leftIcon: Icon(Icons.book, color: Colors.white),
              children: [
                AccordionSection(
                  isOpen: false,
                  header: Text(
                    'Ingredients',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: Text(
                    cr!.ingredients!,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                AccordionSection(
                  isOpen: false,
                  header: Text('Cooking Method'),
                  content: Text(
                    cr!.cooking_method!,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            //Button Action
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, //Center Row contents horizontally,
              crossAxisAlignment:
                  CrossAxisAlignment.center, //Center Row contents vertically,
              children: [
                ElevatedButton(
                  child: Icon(Icons.edit_outlined),
                  onPressed: () {
                    print(cr!.idrecipes!);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditRecipe(
                              recipe_id: widget.recipe_id.toString())),
                    ).then(onGoBack);
                  },
                ),
                Padding(padding: EdgeInsets.all(5)),
                ElevatedButton(
                    onPressed: () {
                      delete(cr!.idrecipes!, cr!.name_recipe!);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyRecipe(
                                  username: widget.username.toString())));
                    },
                    child: new Icon(Icons.delete))
              ],
            )
          ]));
    } else {
      return CircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detail My Recipe'),
        ),
        body: ListView(children: <Widget>[tampilData()]));
  }
}
