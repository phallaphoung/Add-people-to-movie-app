import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:num_afternoon/movie_module/movie_screens/movie_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../movie_logics/movie_gridstyle_logic.dart';
import '../movie_logics/movie_theme_logic.dart';
import '../movie_logics/the_movie_logic.dart';
import '../movie_models/the_movie_model.dart';

class NowplayingScreen extends StatefulWidget {
  const NowplayingScreen({super.key});

  @override
  State<NowplayingScreen> createState() => _NowplayingScreenState();
}

class _NowplayingScreenState extends State<NowplayingScreen> {
  bool _showUpIcon = false;

  @override
  void initState() {
    super.initState();
    _scroller.addListener(() {
      if (_scroller.position.pixels < 500) {
        setState(() {
          _showUpIcon = false;
        });
      } else {
        setState(() {
          _showUpIcon = true;
        });
      }
    });
  }

  bool _gridStyle = false;

  @override
  Widget build(BuildContext context) {
    bool dark = context.watch<MovieThemeLogic>().dark;
    _gridStyle = context.watch<MovieGridstyleLogic>().gridstyle;
    return Scaffold(
      appBar: AppBar(title: Text("Now Playing")),
      floatingActionButton: _showUpIcon ? _buildFloating() : null,
      body: Center(child: _buildBody()),
    );
  }

  Widget _buildFloating() {
    return FloatingActionButton(
      shape: CircleBorder(),
      onPressed: () {
        _scroller.animateTo(
          0,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      },
      child: Icon(Icons.arrow_upward),
    );
  }

  Widget _buildBody() {
    bool isLoading = context.watch<TheMovieLogic>().isLoading;
    if (isLoading) {
      return _buildSkeletonizer();
    }

    Object? error = context.watch<TheMovieLogic>().error;
    if (error != null) {
      return _buildError(error);
    }

    TheMovie? movie = context.watch<TheMovieLogic>().theMovieModel;
    if (movie == null) {
      return Icon(Icons.list);
    } else {
      return RefreshIndicator(
        onRefresh: () async {
          context.read<TheMovieLogic>().setLoading();
          context.read<TheMovieLogic>().read();
        },
        child: _buildGridView(movie.results),
      );
    }
  }

  final _scroller = ScrollController();

  Widget _buildGridView(List<Result> items) {
    bool isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double screenWidth = MediaQuery.of(context).size.width;

    return GridView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth > 1200 ? (screenWidth - 1200) / 2 : 0,
      ),
      controller: _scroller,
      physics: BouncingScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _gridStyle ? (isLandScape ? 4 : 2) : 1,
        childAspectRatio: _gridStyle ? 3 / 5 : 3 / 3,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          onTap: () {
            //go to detail screen
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MovieDetailScreen(item.id.toString()),
              ),
            );
          },
          child: Card(
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: imageBase + item.posterPath,
                      placeholder: (_, _) => Container(color: Colors.grey),
                      errorWidget: (_, _, _) =>
                          Container(color: Colors.grey.shade800),
                      fit: BoxFit.cover,
                      width: double.maxFinite,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(item.title, maxLines: 1),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildError(Object error) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Error ${error.toString()}"),
        FilledButton(onPressed: () {}, child: Text("RETRY")),
      ],
    );
  }

  Widget _buildSkeletonizer() {
    bool isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double screenWidth = MediaQuery.of(context).size.width;

    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(),
      child: GridView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth > 1200 ? (screenWidth - 1200) / 2 : 0,
        ),
        controller: _scroller,
        physics: BouncingScrollPhysics(),
        itemCount: 20,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _gridStyle ? (isLandScape ? 4 : 2) : 1,
          childAspectRatio: _gridStyle ? 3 / 5 : 3 / 3,
        ),
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(8),
                    child: Container(color: Colors.grey.shade200),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "title sample text, text, text, and some text",
                    maxLines: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("price sample text", maxLines: 1),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
