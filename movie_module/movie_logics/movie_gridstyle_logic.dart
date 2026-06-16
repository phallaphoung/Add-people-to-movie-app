import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MovieGridstyleLogic extends ChangeNotifier {
  bool _gridstyle = true;
  bool get gridstyle => _gridstyle;

  final _key = "MovieGridstyleLogic";
  final _storage = FlutterSecureStorage();

  Future readGridstyle() async {
    String cache = await _storage.read(key: _key) ?? "true";
    _gridstyle = bool.tryParse(cache) ?? true;
    notifyListeners();
  }

  void toggleStyle() {
    _gridstyle = !_gridstyle;
    notifyListeners();
    _storage.write(key: _key, value: _gridstyle.toString());
  }
}
