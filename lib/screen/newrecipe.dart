import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:numberpicker/numberpicker.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:vensrecipe_160419118_projectuas/main.dart';

class NewRecipe extends StatefulWidget {
  late final String username;
  NewRecipe({Key? key, required this.username}) : super(key: key);
  @override
  NewRecipeState createState() {
    return NewRecipeState();
  }
}

class NewRecipeState extends State<NewRecipe> {
  final _formKey = GlobalKey<FormState>();
  String _nama_recipes = "";
  String _description_recipe = "";
  String _ingredients = "";
  String _cooking_method = "";

  File? _image;
  File? _imageProses;
  void submit() async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.fun/flutter/160419118/VensRecipe/newrecipe.php"),
        body: {
          'username': widget.username.toString(),
          'nama_recipes': _nama_recipes,
          'description_recipe': _description_recipe,
          'bahan_bahan': _ingredients,
          'cara_memasak': _cooking_method,
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses Menambah Data')));
        int newID = json['id'];
        // Insert Image
        List<int> imageBytes = _imageProses!.readAsBytesSync();
        print(imageBytes);
        String base64Image = base64Encode(imageBytes);
        final response2 = await http.post(
            Uri.parse(
              'https://ubaya.fun/flutter/160419118/VensRecipe/uploadimage.php',
            ),
            body: {
              'id_recipe': newID.toString(),
              'image': base64Image,
            });
        if (response2.statusCode == 200) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(response2.body)));
        }
        //Back To Main
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyHomePage(
                      title: "Vens Recipe",
                    )));
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  //Foto Proses
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              color: Colors.black,
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      tileColor: Colors.white,
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Galeri'),
                      onTap: () {
                        _imgGaleri();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    tileColor: Colors.white,
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Kamera'),
                    onTap: () {
                      _imgKamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgGaleri() async {
    final picker = ImagePicker();
    final image = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 600,
        maxWidth: 600);
    // setState(() {
    _image = File(image!.path);
    prosesFoto();
    // });
  }

  _imgKamera() async {
    final picker = ImagePicker();
    final image =
        await picker.getImage(source: ImageSource.camera, imageQuality: 20);
    // setState(() {
    _image = File(image!.path);
    prosesFoto();
    // });
  }

  void prosesFoto() {
    Future<Directory?> extDir = getExternalStorageDirectory();
    extDir.then((value) {
      String _timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
      final String filePath = value!.path + '/${_timestamp()}.jpg';
      _imageProses = File(filePath);
      img.Image temp = img.readJpg(_image!.readAsBytesSync());
      img.Image temp2 = img.copyResize(temp, width: 480, height: 640);
      img.drawString(temp2, img.arial_24, 5, 600, DateTime.now().toString(),
          color: img.getColor(255, 49, 49));
      setState(() {
        _imageProses!.writeAsBytesSync(img.writeJpg(temp2));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("New Recipe"),
        ),
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Nama Recipes',
                    ),
                    onChanged: (value) {
                      _nama_recipes = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'nama_recipes can not be empty';
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
                      _description_recipe = value;
                    },
                  )),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'ingredients',
                    ),
                    onChanged: (value) {
                      _ingredients = value;
                    },
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: 10,
                  )),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Cooking Metod',
                    ),
                    onChanged: (value) {
                      _cooking_method = value;
                    },
                    keyboardType: TextInputType.multiline,
                    minLines: 4,
                    maxLines: 10,
                  )),
              Padding(
                padding: EdgeInsets.all(10),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    child: GestureDetector(
                      child: _imageProses != null
                          ? Image.file(
                              _imageProses!,
                              fit: BoxFit.fill,
                              height: 400,
                            )
                          : Image.network(
                              "https://ubaya.fun/flutter/160419118/VensRecipe/UI/add_image.png",
                              fit: BoxFit.fill,
                              height: 400,
                            ),
                      onTap: () {
                        _showPicker(context);
                      },
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Harap Isian diperbaiki')));
                    } else {
                      submit();
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        )));
  }
}
