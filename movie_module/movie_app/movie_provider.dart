import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../movie_logics/movie_gridstyle_logic.dart';
import '../movie_logics/movie_theme_logic.dart';
import '../movie_logics/the_movie_logic.dart';
import 'movie_loading.dart';

Widget movieProvider() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => MovieThemeLogic()),
      ChangeNotifierProvider(create: (context) => MovieGridstyleLogic()),
      ChangeNotifierProvider(create: (context) => TheMovieLogic()),
    ],
    child: MovieLoading(),
  );
}
