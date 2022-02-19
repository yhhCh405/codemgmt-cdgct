import 'package:code_mgmt_cdgct/Models/movie.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static final HiveService _instance = HiveService();
  static HiveService get instance => _instance;

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(MovieAdapter());
    await Hive.openBox<Movie>("fav_movies");
  }

  Future<void> toggleFavourite(Movie movie) {
    if (isFavourite(movie)) {
      return removeFavourite(movie);
    } else {
      return Hive.box<Movie>("fav_movies").put(movie.id, movie);
    }
  }

  Future<void> removeFavourite(Movie movie) {
    return Hive.box<Movie>("fav_movies").delete(movie.id);
  }

  bool isFavourite(Movie movie) {
    return Hive.box<Movie>("fav_movies").get(movie.id) != null;
  }
}
