import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vensrecipe_160419118_projectuas/class/class_recipe.dart';
import 'package:accordion/accordion.dart';

class DetailRecipe extends StatefulWidget {
  final int recipe_id;
  DetailRecipe({Key? key, required this.recipe_id}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _DetailRecipeState();
  }
}

class _DetailRecipeState extends State<DetailRecipe> {
  ClassRecipe? cr;
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

  bacaData() {
    fetchData().then((value) {
      Map json = jsonDecode(value);
      print(json['data'][0]);
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
            Text(cr!.name_recipe!, style: TextStyle(fontSize: 25)),
            Image.network(
                "https://ubaya.fun/flutter/160419118/VensRecipe/image/recipe/" +
                    cr!.image_link!),
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
          ]));
    } else {
      return CircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Recipe'),
        ),
        body: ListView(children: <Widget>[tampilData()]));
  }
}
