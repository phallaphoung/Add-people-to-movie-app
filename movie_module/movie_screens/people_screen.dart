import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../movie_models/person_model.dart';
import '../movie_services/movie_service.dart';
import 'person_detail_screen.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  final MovieService _service = MovieService();
  late Future<PersonModel> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = _service.getPopularPeople();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Popular People",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<PersonModel>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(fontSize: 18),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final people = snapshot.data!.results;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: people.length,
            itemBuilder: (context, index) {
              final person = people[index];

              return Card(
                elevation: 1, // Subtle, clean shadow profile
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PersonDetailScreen(person.id),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: person.profilePath != null
                              ? CachedNetworkImageProvider(
                                  "https://image.tmdb.org/t/p/w500${person.profilePath}",
                                )
                              : null,
                          child: person.profilePath == null
                              ? const Icon(
                                  Icons.person,
                                  size: 32,
                                  color: Colors.grey,
                                )
                              : null,
                        ),

                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                person.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Popularity: ${person.popularity.toStringAsFixed(2)}",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.grey.shade400,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
