// To parse this JSON data, do
//
//     final personModel = personModelFromJson(jsonString);

import 'dart:convert';

PersonModel personModelFromJson(String str) =>
    PersonModel.fromJson(json.decode(str));

String personModelToJson(PersonModel data) => json.encode(data.toJson());

class PersonModel {
  int page;
  List<Result> results;
  int totalPages;
  int totalResults;

  PersonModel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) => PersonModel(
    page: json["page"],
    results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
    totalPages: json["total_pages"],
    totalResults: json["total_results"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
    "total_pages": totalPages,
    "total_results": totalResults,
  };
}

class Result {
  bool adult;
  int gender;
  int id;
  KnownForDepartment knownForDepartment;
  String name;
  String originalName;
  double popularity;
  String? profilePath;
  List<KnownFor> knownFor;

  Result({
    required this.adult,
    required this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    this.profilePath,
    required this.knownFor,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    adult: json["adult"],
    gender: json["gender"],
    id: json["id"],
    knownForDepartment:
        knownForDepartmentValues.map[json["known_for_department"]] ??
        KnownForDepartment.ACTING,
    name: json["name"],
    originalName: json["original_name"],
    popularity: json["popularity"]?.toDouble(),
    profilePath: json["profile_path"],
    knownFor: List<KnownFor>.from(
      json["known_for"].map((x) => KnownFor.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "adult": adult,
    "gender": gender,
    "id": id,
    "known_for_department":
        knownForDepartmentValues.reverse[knownForDepartment],
    "name": name,
    "original_name": originalName,
    "popularity": popularity,
    "profile_path": profilePath,
    "known_for": List<dynamic>.from(knownFor.map((x) => x.toJson())),
  };
}

class KnownFor {
  bool adult;
  String? backdropPath;
  int id;
  String? name;
  String? originalName;
  String overview;
  String posterPath;
  MediaType mediaType;
  OriginalLanguage originalLanguage;
  List<int> genreIds;
  double popularity;
  DateTime? firstAirDate;
  bool softcore;
  double voteAverage;
  int voteCount;
  List<String>? originCountry;
  String? title;
  String? originalTitle;
  DateTime? releaseDate;
  bool? video;

  KnownFor({
    required this.adult,
    required this.backdropPath,
    required this.id,
    this.name,
    this.originalName,
    required this.overview,
    required this.posterPath,
    required this.mediaType,
    required this.originalLanguage,
    required this.genreIds,
    required this.popularity,
    this.firstAirDate,
    required this.softcore,
    required this.voteAverage,
    required this.voteCount,
    this.originCountry,
    this.title,
    this.originalTitle,
    this.releaseDate,
    this.video,
  });

  factory KnownFor.fromJson(Map<String, dynamic> json) => KnownFor(
    adult: json["adult"],
    backdropPath: json["backdrop_path"],
    id: json["id"],
    name: json["name"],
    originalName: json["original_name"],
    overview: json["overview"],
    posterPath: json["poster_path"],
    mediaType: mediaTypeValues.map[json["media_type"]] ?? MediaType.MOVIE,
    originalLanguage:
        originalLanguageValues.map[json["original_language"]] ??
        OriginalLanguage.EN,
    genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
    popularity: json["popularity"]?.toDouble(),
    firstAirDate: json["first_air_date"] == null
        ? null
        : DateTime.parse(json["first_air_date"]),
    softcore: json["softcore"],
    voteAverage: json["vote_average"]?.toDouble(),
    voteCount: json["vote_count"],
    originCountry: json["origin_country"] == null
        ? []
        : List<String>.from(json["origin_country"]!.map((x) => x)),
    title: json["title"],
    originalTitle: json["original_title"],
    releaseDate: json["release_date"] == null
        ? null
        : DateTime.parse(json["release_date"]),
    video: json["video"],
  );

  Map<String, dynamic> toJson() => {
    "adult": adult,
    "backdrop_path": backdropPath,
    "id": id,
    "name": name,
    "original_name": originalName,
    "overview": overview,
    "poster_path": posterPath,
    "media_type": mediaTypeValues.reverse[mediaType],
    "original_language": originalLanguageValues.reverse[originalLanguage],
    "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
    "popularity": popularity,
    "first_air_date":
        "${firstAirDate!.year.toString().padLeft(4, '0')}-${firstAirDate!.month.toString().padLeft(2, '0')}-${firstAirDate!.day.toString().padLeft(2, '0')}",
    "softcore": softcore,
    "vote_average": voteAverage,
    "vote_count": voteCount,
    "origin_country": originCountry == null
        ? []
        : List<dynamic>.from(originCountry!.map((x) => x)),
    "title": title,
    "original_title": originalTitle,
    "release_date":
        "${releaseDate!.year.toString().padLeft(4, '0')}-${releaseDate!.month.toString().padLeft(2, '0')}-${releaseDate!.day.toString().padLeft(2, '0')}",
    "video": video,
  };
}

enum MediaType { MOVIE, TV }

final mediaTypeValues = EnumValues({
  "movie": MediaType.MOVIE,
  "tv": MediaType.TV,
});

enum OriginalLanguage { CN, EN, JA, KO, TA, TR, ZH }

final originalLanguageValues = EnumValues({
  "cn": OriginalLanguage.CN,
  "en": OriginalLanguage.EN,
  "ja": OriginalLanguage.JA,
  "ko": OriginalLanguage.KO,
  "ta": OriginalLanguage.TA,
  "tr": OriginalLanguage.TR,
  "zh": OriginalLanguage.ZH,
});

enum KnownForDepartment { ACTING, DIRECTING }

final knownForDepartmentValues = EnumValues({
  "Acting": KnownForDepartment.ACTING,
  "Directing": KnownForDepartment.DIRECTING,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
