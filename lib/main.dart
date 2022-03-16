import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vensrecipe_160419118_projectuas/screen/category.dart';
import 'package:vensrecipe_160419118_projectuas/screen/myrecipe.dart';
import 'package:vensrecipe_160419118_projectuas/screen/newrecipe.dart';
import 'package:vensrecipe_160419118_projectuas/screen/profile.dart';
import 'package:vensrecipe_160419118_projectuas/screen/recipe.dart';
import 'screen/login.dart';
import 'tema.dart';

String active_user = "";

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String username = prefs.getString("username") ?? '';
  return username;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    if (result == '')
      runApp(MyLogin());
    else {
      active_user = result;
      runApp(MyApp());
    }
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TemaChanger>(
      create: (context) => TemaChanger(ThemeData.dark()),
      child: new MaterialAppWithTema(),
    );
    // return MaterialApp(
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   home: MyHomePage(title: 'Flutter Demo Home Page'),
    // );
  }
}

class MaterialAppWithTema extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tema = Provider.of<TemaChanger>(context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Project UTS',
        theme: tema.getTema(),
        home: MyHomePage(title: 'Venz Recipe'),
        routes: {
          'category': (context) => Category(),
          'Recipe': (context) => Recipe(),
          'Profile': (context) => Profile(username: active_user),
          'NewRecipe': (context) => NewRecipe(username: active_user),
          'MyRecipe': (context) => MyRecipe(username: active_user),
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    Category(),
    Recipe(),
    Profile(username: active_user)
  ];

  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("username");
    main();
  }

  Widget myDrawer() {
    return Drawer(
      elevation: 16.0,
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
              accountName: Text(active_user),
              accountEmail: Text("$active_user@gmail.com"),
              currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage("https://i.pravatar.cc/150"))),
          ListTile(
              title: new Text("New Recipe"),
              leading: new Icon(
                Icons.add_circle_sharp,
                size: 40,
              ),
              onTap: () {
                Navigator.popAndPushNamed(context, "NewRecipe");
              }),
          ListTile(
              title: new Text("My Recipe"),
              leading: new Icon(Icons.my_library_books, size: 40),
              onTap: () {
                Navigator.popAndPushNamed(context, "MyRecipe");
              }),
          Divider(color: Colors.white, height: 5),
          ListTile(
              title: Text("Logout"),
              leading: Icon(Icons.logout),
              onTap: () {
                doLogout();
              })
        ],
      ),
    );
  }

  Widget nav() {
    return BottomNavigationBar(
        currentIndex: _currentIndex,
        fixedColor: Colors.pinkAccent,
        items: [
          BottomNavigationBarItem(
            label: "Category",
            icon: Icon(
              Icons.category,
              size: 20,
            ),
          ),
          BottomNavigationBarItem(
            label: "Search Recipe",
            icon: Icon(
              Icons.search,
              size: 20,
            ),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(
              Icons.person,
              size: 20,
            ),
          ),
        ],
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
        ),
        body: _screens[_currentIndex],
        drawer: myDrawer(),
        bottomNavigationBar: SizedBox(height: 58, child: nav())
        // nav(), // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
