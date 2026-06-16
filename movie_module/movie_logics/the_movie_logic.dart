import 'package:flutter/material.dart';
import '../movie_models/the_movie_model.dart';
import '../movie_services/movie_service.dart';

class TheMovieLogic extends ChangeNotifier {
  TheMovie? _theMovieModel;
  TheMovie? get theMovieModel => _theMovieModel;

  final _service = MovieService();

  Object? _error;
  Object? get error => _error;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading() {
    _isLoading = true;
    notifyListeners();
  }

  Future read() async {
    await _service
        .readNowPlaying()
        .then((value) {
          _theMovieModel = value;
        })
        .onError((e, s) {
          _error = e;
        });
    _isLoading = false;
    notifyListeners();
  }
}
