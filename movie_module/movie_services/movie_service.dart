import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../api_key.dart';
import '../movie_models/movie_detail_model.dart';
import '../movie_models/the_movie_model.dart';
import '../movie_models/person_model.dart';
import '../movie_models/person_detail_model.dart';

class MovieService {
  final _baseUrl = "https://api.themoviedb.org/3";

  Future<TheMovie> readNowPlaying() async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/movie/now_playing?page=1&api_key=$apiKey"),
      );
      if (response.statusCode == 200) {
        return compute(theMovieFromJson, response.body);
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<MovieDetail> getMovieDetail(String movieId) async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/movie/$movieId?api_key=$apiKey"),
      );
      if (response.statusCode == 200) {
        return compute(movieDetailFromJson, response.body);
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<PersonModel> getPopularPeople() async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/person/popular?api_key=$apiKey"),
      );
      if (response.statusCode == 200) {
        return compute(personModelFromJson, response.body);
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<PersonDetailModel> getPersonDetail(String personId) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/person/$personId?api_key=$apiKey"),
    );
    if (response.statusCode == 200) {
      return compute(personDetailModelFromJson, response.body);
    } else {
      throw Exception("Error: ${response.statusCode}");
    }
  }
}
