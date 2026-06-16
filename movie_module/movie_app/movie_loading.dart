import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../movie_logics/movie_gridstyle_logic.dart';
import '../movie_logics/movie_theme_logic.dart';
import '../movie_logics/the_movie_logic.dart';
import '../movie_screens/parent_screen.dart';

class MovieLoading extends StatefulWidget {
  const MovieLoading({super.key});

  @override
  State<MovieLoading> createState() => _MovieLoadingState();
}

class _MovieLoadingState extends State<MovieLoading> {
  Future _loadCache() async {
    await Future.delayed(Duration(seconds: 3), () {});
    if (mounted) {
      await context.read<MovieThemeLogic>().readTheme();
    }
    if (mounted) {
      await context.read<MovieGridstyleLogic>().readGridstyle();
    }
    if (mounted) {
      await context.read<TheMovieLogic>().read();
    }
  }

  late Future _futureCache = _loadCache();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: FutureBuilder(
            future: _futureCache,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return _buildError(snapshot.error);
              }

              if (snapshot.connectionState == ConnectionState.done) {
                return ParentScreen();
              } else {
                return _buildLoading();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildError(Object? error) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Error ${error.toString()}"),
        FilledButton(
          onPressed: () {
            setState(() {
              _futureCache = _loadCache();
            });
          },
          child: Text("RETRY"),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("images/cards_showtimes.png", height: 300),
          CircularProgressIndicator(color: Colors.white),
        ],
      ),
    );
  }
}
