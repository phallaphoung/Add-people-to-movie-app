import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../movie_services/movie_service.dart';
import '../movie_models/person_detail_model.dart';

class PersonDetailScreen extends StatefulWidget {
  final int personId;

  const PersonDetailScreen(this.personId, {super.key});

  @override
  State<PersonDetailScreen> createState() => _PersonDetailScreenState();
}

class _PersonDetailScreenState extends State<PersonDetailScreen> {
  final MovieService _service = MovieService();
  late Future<PersonDetailModel> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = _service.getPersonDetail(widget.personId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Person Detail")),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _futureData = _service.getPersonDetail(widget.personId.toString());
          });
        },
        child: FutureBuilder<PersonDetailModel>(
          future: _futureData,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Error: ${snapshot.error}"),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () {
                        setState(() {
                          _futureData = _service.getPersonDetail(
                            widget.personId.toString(),
                          );
                        });
                      },
                      child: const Text("RETRY"),
                    ),
                  ],
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return _buildDetail(snapshot.data);
            } else {
              return _buildSkeletonLoading();
            }
          },
        ),
      ),
    );
  }

  Widget _buildDetail(PersonDetailModel? person) {
    if (person == null) return const Center(child: Icon(Icons.person));

    final path = "https://image.tmdb.org/t/p/w780/";

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      children: [
        if (person.profilePath != null)
          Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            height: 480,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: path + person.profilePath!,
                placeholder: (_, __) => Container(
                  color: Colors.grey.shade200,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.person, size: 50, color: Colors.grey),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

        Card(
          margin: const EdgeInsets.symmetric(vertical: 5),
          elevation: 0.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            child: Center(
              child: Text(
                person.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ),
        ),

        Card(
          margin: const EdgeInsets.symmetric(vertical: 5),
          elevation: 0.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Biography",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  person.biography.isNotEmpty
                      ? person.biography
                      : "No biography details added yet.",
                  style: const TextStyle(fontSize: 15, height: 1.4),
                ),
              ],
            ),
          ),
        ),

        Card(
          margin: const EdgeInsets.symmetric(vertical: 5),
          elevation: 0.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: const Icon(Icons.cake_rounded),
            title: Text(
              "Birthday: ${person.birthday?.toIso8601String().split('T')[0] ?? 'Unknown'}",
            ),
          ),
        ),

        Card(
          margin: const EdgeInsets.symmetric(vertical: 5),
          elevation: 0.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: const Icon(Icons.location_on_rounded),
            title: Text("Place of Birth: ${person.placeOfBirth ?? 'Unknown'}"),
          ),
        ),

        Card(
          margin: const EdgeInsets.symmetric(vertical: 5),
          elevation: 0.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: const Icon(Icons.star_rounded, color: Colors.amber),
            title: Text("Known For: ${person.knownForDepartment ?? 'Unknown'}"),
          ),
        ),
      ],
    );
  }

  Widget _buildSkeletonLoading() {
    return Skeletonizer(
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Container(
            height: 480,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 12),
          const Card(
            child: ListTile(
              title: Center(child: Text("Loading name labels...")),
            ),
          ),
          const Card(
            child: ListTile(
              title: Text(
                "Loading profile summaries descriptions long text contents...",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
