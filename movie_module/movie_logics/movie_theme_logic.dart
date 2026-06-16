import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MovieThemeLogic extends ChangeNotifier{
  bool _dark = false;
  bool get dark => _dark;

  final _key = "MovieThemeLogic";
  final _storage = FlutterSecureStorage();

  Future readTheme() async{
    String cache = await _storage.read(key: _key) ?? "false";
    _dark = bool.tryParse(cache) ?? false;
    notifyListeners();
  }

  void toggleTheme(){
    _dark = !_dark;
    notifyListeners();
    _storage.write(key: _key, value: _dark.toString());
  }
}