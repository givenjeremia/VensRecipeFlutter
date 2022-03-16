import 'package:flutter/material.dart';

class TemaChanger with ChangeNotifier {
  late ThemeData _temaData;
  TemaChanger(this._temaData);

  getTema() => _temaData;
  setTema(ThemeData tema) {
    _temaData = tema;

    notifyListeners();
  }
}
