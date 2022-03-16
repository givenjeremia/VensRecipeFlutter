import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:vensrecipe_160419118_projectuas/class/class_categorylist.dart';
import 'package:vensrecipe_160419118_projectuas/class/class_profile.dart';
import 'package:vensrecipe_160419118_projectuas/class/class_recipe.dart';
import 'package:vensrecipe_160419118_projectuas/main.dart';

class Profile extends StatefulWidget {
  late final String username;
  Profile({Key? key, required this.username}) : super(key: key);
  @override
  ProfileState createState() {
    return ProfileState();
  }
}

class ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  ClassProfile? cp;
  TextEditingController _username = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _nama = new TextEditingController();
  TextEditingController _birthday = new TextEditingController();

  Future<String> fetchData() async {
    print("Masuk Gays");
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419118/VensRecipe/profile.php"),
        body: {'username': widget.username.toString()});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    fetchData().then((value) {
      Map json = jsonDecode(value);
      if (json['result'] == 'success') {
        cp = ClassProfile.fromJson(json['data'][0]);
        setState(() {
          _username.text = cp!.username!;
          _nama.text = cp!.name!;
          _password.text = cp!.password!;
          _birthday.text = cp!.birthday!;
        });
      } else {
        return CircularProgressIndicator();
      }
    });
  }

  //Update Recipe
  void UpdateProfile() async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.fun/flutter/160419118/VensRecipe/profileupdate.php"),
        body: {
          'password': cp!.password,
          'nama': cp!.name,
          'tanggal_lahir': cp!.birthday,
          'username': widget.username.toString()
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Success Change Profile')));
        main();
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  void initState() {
    super.initState();
    bacaData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: _formKey,
            child: PageView(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xff88D8C7).withOpacity(0.2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            enabled: false,
                            decoration: const InputDecoration(
                              labelText: 'Username',
                            ),
                            onChanged: (value) {
                              cp!.username = value;
                            },
                            controller: _username,
                          )),
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                            ),
                            onChanged: (value) {
                              cp!.password = value;
                            },
                            controller: _password,
                          )),
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Nama',
                            ),
                            onChanged: (value) {
                              cp!.name = value;
                            },
                            controller: _nama,
                          )),
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Birth Day',
                                ),
                                onChanged: (value) {
                                  cp!.birthday = value;
                                },
                                controller: _birthday,
                              )),
                              Padding(padding: EdgeInsets.all(5)),
                              ElevatedButton(
                                  onPressed: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2200))
                                        .then((value) {
                                      setState(() {
                                        _birthday.text =
                                            value.toString().substring(0, 10);
                                      });
                                    });
                                  },
                                  child: Icon(
                                    Icons.calendar_today_sharp,
                                    color: Colors.white,
                                    size: 24.0,
                                  ))
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            UpdateProfile();
                          },
                          child: Text('Change'),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )));
  }
}
