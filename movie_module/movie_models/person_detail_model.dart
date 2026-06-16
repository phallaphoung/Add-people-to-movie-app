// To parse this JSON data, do
//
//     final personDetail = personDetailModelFromJson(jsonString);

import 'dart:convert';

PersonDetailModel personDetailModelFromJson(String str) =>
    PersonDetailModel.fromJson(json.decode(str));

String personDetailModelToJson(PersonDetailModel data) =>
    json.encode(data.toJson());

class PersonDetailModel {
  final bool adult;
  final List<String> alsoKnownAs;
  final String biography;
  final DateTime? birthday;
  final String? deathday;
  final int gender;
  final String? homepage;
  final int id;
  final String? imdbId;
  final String knownForDepartment;
  final String name;
  final String? placeOfBirth;
  final double popularity;
  final String? profilePath;

  PersonDetailModel({
    required this.adult,
    required this.alsoKnownAs,
    required this.biography,
    this.birthday,
    this.deathday,
    required this.gender,
    this.homepage,
    required this.id,
    this.imdbId,
    required this.knownForDepartment,
    required this.name,
    this.placeOfBirth,
    required this.popularity,
    this.profilePath,
  });

  factory PersonDetailModel.fromJson(Map<String, dynamic> json) =>
      PersonDetailModel(
        adult: json["adult"],
        alsoKnownAs: List<String>.from(json["also_known_as"].map((x) => x)),
        biography: json["biography"] ?? "",
        birthday: json["birthday"] == null
            ? null
            : DateTime.tryParse(json["birthday"]),
        deathday: json["deathday"],
        gender: json["gender"],
        homepage: json["homepage"],
        id: json["id"],
        imdbId: json["imdb_id"],
        knownForDepartment: json["known_for_department"],
        name: json["name"],
        placeOfBirth: json["place_of_birth"],
        popularity: (json["popularity"] ?? 0).toDouble(),
        profilePath: json["profile_path"],
      );

  Map<String, dynamic> toJson() => {
    "adult": adult,
    "also_known_as": alsoKnownAs,
    "biography": biography,
    "birthday": birthday?.toIso8601String(),
    "deathday": deathday,
    "gender": gender,
    "homepage": homepage,
    "id": id,
    "imdb_id": imdbId,
    "known_for_department": knownForDepartment,
    "name": name,
    "place_of_birth": placeOfBirth,
    "popularity": popularity,
    "profile_path": profilePath,
  };
}
