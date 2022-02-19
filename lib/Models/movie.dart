import 'package:code_mgmt_cdgct/Services/hive_service.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'movie.g.dart';

@HiveType(typeId: 0)
class Movie extends HiveObject with EquatableMixin {
  @HiveField(0)
  final bool? adult;
  @HiveField(1)
  final String? backdropPath;
  @HiveField(2)
  final List<int?>? genreIds;
  @HiveField(3)
  final int? id;
  @HiveField(4)
  final String? originalLanguage;
  @HiveField(5)
  final String? originalTitle;
  @HiveField(6)
  final String? overview;
  @HiveField(7)
  final double? popularity;
  @HiveField(8)
  final String? _posterPath;
  String? get posterPath {
    if (_posterPath == null) return null;
    if (_posterPath!.startsWith("http")) return _posterPath;
    return "https://image.tmdb.org/t/p/w185/" + _posterPath!;
  }

  String? get fullResPosterPath {
    if (_posterPath == null) return null;
    if (_posterPath!.startsWith("http")) return _posterPath;
    return "https://image.tmdb.org/t/p/original/" + _posterPath!;
  }

  @HiveField(9)
  final String? releaseDate;
  @HiveField(10)
  final String? title;
  @HiveField(11)
  final bool? video;
  @HiveField(12)
  final double? voteAverage;
  @HiveField(13)
  final double? voteCount;

  Movie(
      {this.adult,
      this.backdropPath,
      this.genreIds,
      this.id,
      this.originalLanguage,
      this.originalTitle,
      this.overview,
      this.popularity,
      String? posterPath,
      this.releaseDate,
      this.title,
      this.video,
      this.voteAverage,
      this.voteCount})
      : _posterPath = posterPath;

  Map<String, dynamic> toMap() {
    return {
      "adult": adult,
      "backdrop_path": backdropPath,
      "genre_ids": genreIds,
      "id": id,
      "original_language": originalLanguage,
      "original_title": originalTitle,
      "overview": overview,
      "popularity": popularity,
      "poster_path": _posterPath,
      "release_date": releaseDate,
      "title": title,
      "video": video,
      "vote_average": voteAverage,
      "vote_count": voteCount
    };
  }

  Movie.fromJSON(dynamic json)
      : adult = json["adult"],
        backdropPath = json["backdrop_path"],
        genreIds = (json["genre_ids"] as List<dynamic>?)
            ?.map((e) => e as int?)
            .toList(),
        id = json["id"],
        originalLanguage = json["original_language"],
        originalTitle = json["original_title"],
        overview = json["overview"],
        popularity = double.parse(json["popularity"].toString()),
        _posterPath = json["poster_path"],
        releaseDate = json["release_date"],
        title = json["title"],
        video = json["video"],
        voteAverage = double.parse(json["vote_average"].toString()),
        voteCount = double.parse(json["vote_count"].toString());

  @override
  List<Object?> get props => [id!];

  bool get isFavourite => HiveService.instance.isFavourite(this);
  Future<void> toggleFavourite() => HiveService.instance.toggleFavourite(this);
}
