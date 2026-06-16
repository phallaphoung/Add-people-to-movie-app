import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../movie_models/movie_detail_model.dart';
import '../movie_services/movie_service.dart';

class MovieDetailScreen extends StatefulWidget {
  final String movieId;

  const MovieDetailScreen(this.movieId, {super.key});

  @override
  State<MovieDetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<MovieDetailScreen> {
  final MovieService _service = MovieService();
  late Future<MovieDetail> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = _service.getMovieDetail(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Movie Detail")),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Center(
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _futureData = _service.getMovieDetail(widget.movieId);
          });
        },
        child: FutureBuilder<MovieDetail>(
          future: _futureData,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Error ${snapshot.error.toString()}"),
                  FilledButton(
                    onPressed: () {
                      setState(() {
                        _futureData = _service.getMovieDetail(widget.movieId);
                      });
                    },
                    child: const Text("RETRY"),
                  ),
                ],
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return _buildListView(snapshot.data);
            } else {
              return _buildSkeletonLoading();
            }
          },
        ),
      ),
    );
  }

  Widget _buildListView(MovieDetail? item) {
    if (item == null) {
      return Center(child: const Icon(Icons.list));
    }

    final path = "https://image.tmdb.org/t/p/w500/";

    return ListView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: const EdgeInsets.all(8),
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: CachedNetworkImage(
            imageUrl: path + item.posterPath,
            placeholder: (_, __) => Container(color: Colors.grey),
            errorWidget: (_, __, ___) => Container(color: Colors.grey.shade800),
            fit: BoxFit.cover,
            width: double.maxFinite,
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.movie),
            title: Text(item.title),
          ),
        ),
        Card(child: ListTile(title: Text(item.overview))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Card(
            child: ListTile(
              leading: const Icon(Icons.date_range),
              title: Text(
                "${item.releaseDate.day}/${item.releaseDate.month}/${item.releaseDate.year}",
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSkeletonLoading() {
    return Skeletonizer(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(8),
        children: [
          Container(height: 600, width: double.maxFinite, color: Colors.amber),
          const Card(
            child: ListTile(
              leading: Icon(Icons.movie),
              title: Text("asdsad as dsa dsa d"),
            ),
          ),
          const Card(
            child: ListTile(
              title: Text("as d sad sad asd sad asd asd sa das das"),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Card(
              child: ListTile(
                leading: Icon(Icons.date_range),
                title: Text("asd asda sd asd asd "),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
