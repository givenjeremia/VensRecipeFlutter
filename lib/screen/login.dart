import 'dart:convert';
// import 'dart:html';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../tema.dart';
import '../main.dart';

class MyLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TemaChanger>(
      create: (context) => TemaChanger(ThemeData.dark()),
      child: new MaterialAppWithTema(),
    );
  }
}

class MaterialAppWithTema extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tema = Provider.of<TemaChanger>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Project UAS',
      theme: tema.getTema(),
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  late String _username;
  late String _user_password;
  String error_login = "";

  //REGISTER
  final _controllerdate = TextEditingController();
  late String _usernameRegis;
  late String _user_passwordRegis;
  late String _name;

  int page = 1;
  PageController controller = PageController(initialPage: 0);
  void doLogin() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419118/VensRecipe/login.php"),
        body: {'username': _username, 'password': _user_password});
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("username", json['user_name']);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Login Succecc')));
        main();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Login Failed , Username Or Password Wrong')));
      }
    } else {
      throw Exception('Failed to read API');
    }
    main();
  }

  void doRegister() async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.fun/flutter/160419118/VensRecipe/register.php"),
        body: {
          'nama': _name,
          'username': _usernameRegis,
          'password': _user_passwordRegis,
          'tanggal_lahir': _controllerdate.text
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Success Register')));
        setState(() {
          controller = PageController(initialPage: 0);
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed Register')));
      }
    } else {
      throw Exception('Failed to read API');
    }
    // main();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('Vens Recipe'),
        ),
        body: SingleChildScrollView(
            child: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    "https://ubaya.fun/flutter/160419118/VensRecipe/login--2.jpg"),
                fit: BoxFit.fitHeight),
          ),
          child: PageView(
            controller: controller,
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
                child: Column(children: [
                  SizedBox(
                      height: size.height / 3,
                      child: Container(
                        child: RotateAnimatedTextKit(
                          text: ["  WELCOME  ", "  TO  ", "  VENS RECIPE  "],
                          textStyle: TextStyle(
                              fontSize: 30.0,
                              backgroundColor: Color(0xff88D8C7),
                              color: Colors.black),
                          duration: Duration(seconds: 3),
                          isRepeatingAnimation: true,
                          repeatForever: true,
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          fillColor: Colors.black,
                          filled: true,
                          labelText: 'Username',
                          labelStyle: TextStyle(color: Colors.white),
                          hintText: 'Enter valid Username',
                          hintStyle: TextStyle(color: Colors.white)),
                      onChanged: (v) {
                        _username = v;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    //padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          fillColor: Colors.black,
                          filled: true,
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.white),
                          hintStyle: TextStyle(color: Colors.white),
                          hintText: 'Enter secure password'),
                      onChanged: (v) {
                        _user_password = v;
                      },
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        height: 50,
                        width: 300,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20)),
                        child: ElevatedButton(
                          onPressed: () {
                            doLogin();
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        height: 50,
                        width: 300,
                        child: Text(
                          "Don't Have Account ?",
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Swipe To Register ",
                            style: TextStyle(fontSize: 20),
                          ),
                          Icon(
                            Icons.arrow_right_alt_outlined,
                            size: 20,
                          )
                        ],
                      ))
                ]),
              ),

              //Register Page

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
                child: Column(children: [
                  SizedBox(
                      height: size.height / 6,
                      child: Container(
                        child: RotateAnimatedTextKit(
                          text: [
                            "  REGISTER  ",
                            "  ACCOUNT  ",
                            "  VENS RECIPE  "
                          ],
                          textStyle: TextStyle(
                              fontSize: 30.0,
                              backgroundColor: Color(0xff88D8C7),
                              color: Colors.black),
                          duration: Duration(seconds: 3),
                          isRepeatingAnimation: true,
                          repeatForever: true,
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          fillColor: Colors.black,
                          filled: true,
                          labelText: 'Name',
                          labelStyle: TextStyle(color: Colors.white),
                          hintText: 'Enter valid Name',
                          hintStyle: TextStyle(color: Colors.white)),
                      onChanged: (v) {
                        _name = v;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          fillColor: Colors.black,
                          filled: true,
                          labelText: 'Username',
                          labelStyle: TextStyle(color: Colors.white),
                          hintText: 'Enter valid Username',
                          hintStyle: TextStyle(color: Colors.white)),
                      onChanged: (v) {
                        _usernameRegis = v;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    //padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          fillColor: Colors.black,
                          filled: true,
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.white),
                          hintStyle: TextStyle(color: Colors.white),
                          hintText: 'Enter secure password'),
                      onChanged: (v) {
                        _user_passwordRegis = v;
                      },
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              child: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              fillColor: Colors.black,
                              filled: true,
                              labelText: 'Birth Day',
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            controller: _controllerdate,
                          )),
                          Padding(padding: EdgeInsets.only(right: 2)),
                          ElevatedButton(
                              onPressed: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2024))
                                    .then((value) {
                                  setState(() {
                                    _controllerdate.text =
                                        value.toString().substring(0, 10);
                                  });
                                });
                              },
                              child: Icon(
                                Icons.calendar_view_day,
                                color: Colors.white,
                                size: 24.0,
                              ))
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        height: 50,
                        width: 300,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20)),
                        child: ElevatedButton(
                          onPressed: () {
                            doRegister();
                          },
                          child: Text(
                            'Register',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        height: 50,
                        width: 300,
                        child: Text(
                          "Do You Have Account ?",
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_left_outlined,
                            size: 20,
                          ),
                          Text(
                            "Swipe To Login ",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ))
                ]),
              )
            ],
          ),
        )));
  }
}
