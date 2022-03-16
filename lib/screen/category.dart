import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vensrecipe_160419118_projectuas/main.dart';
import 'package:vensrecipe_160419118_projectuas/screen/recipecategory.dart';
import '../class/class_category.dart';

class Category extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Category();
  }
}

class _Category extends State<Category> {
  String _temp = 'waiting API respond…';
  String _txtcari = "";

  Future<String> fetchData() async {
    final response = await http.post(Uri.parse(
        "https://ubaya.fun/flutter/160419118/VensRecipe/categories.php"));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    CATEGORYs.clear();
    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      for (var mov in json['data']) {
        ClassCategory ct = ClassCategory.fromJson(mov);
        CATEGORYs.add(ct);
      }
      setState(() {
        // _temp = CATEGORYs[0].title;
      });
    });
  }

  Widget DaftarClassCategory(PopMovs) {
    if (PopMovs != null) {
      return GridView.builder(
          itemCount: PopMovs.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 10 / 16,
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
                              builder: (context) => RecipeCategory(
                                  category_id: CATEGORYs[index].id_category!),
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
                                        "https://ubaya.fun/flutter/160419118/VensRecipe/" +
                                            CATEGORYs[index].image.toString()),
                                    fit: BoxFit.fill),
                              ),
                            )),
                            Center(
                                child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      CATEGORYs[index].name_category.toString(),
                                      style: TextStyle(fontSize: 18.0),
                                    ))),
                            Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  CATEGORYs[index].desc_category.toString(),
                                  style: TextStyle(fontSize: 15.0),
                                )),
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
        // appBar:
        //     AppBar(centerTitle: true, title: const Text('Categories Recipe')),
        body: PageView(children: [
      Container(
        // width:  MediaQuery.of(context).size.width,
        child: DaftarClassCategory(CATEGORYs),
      )
    ]));
  }
}
