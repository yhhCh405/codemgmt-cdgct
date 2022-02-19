import 'dart:convert';

import 'package:code_mgmt_cdgct/Models/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static SharedPrefService _instance = SharedPrefService();
  static SharedPrefService get instance => _instance;
  late SharedPreferences _pref;

  Future<void> init() async {
    _pref = await SharedPreferences.getInstance();
  }

  Future<bool> saveUpcomingMovies(List<Movie> movies) async {
    return _pref.setString(
        "upComingMovies", jsonEncode(movies.map((e) => e.toMap()).toList()));
  }

  Future<bool> savePopularMovies(List<Movie> movies) async {
    return _pref.setString(
        "popularMovies", jsonEncode(movies.map((e) => e.toMap()).toList()));
  }

  List<Movie>? getUpcomingMovies() {
    String? s = _pref.getString("upComingMovies");
    if (s == null) return null;
    return (jsonDecode(s) as List).map((e) => Movie.fromJSON(e)).toList();
  }

  List<Movie>? getPopularMovies() {
    String? s = _pref.getString("popularMovies");
    if (s == null) return null;
    return (jsonDecode(s) as List).map((e) => Movie.fromJSON(e)).toList();
  }

  int? getUpComingMoviePage() {
    return _pref.getInt("upComingMoviePage");
  }

  int? getTotalUpComingMoviePage() {
    return _pref.getInt("totalUpComingMoviePage");
  }

  int? getPopularMoviePage() {
    return _pref.getInt("popularMoviePage");
  }

  int? getTotalPopularMoviePage() {
    return _pref.getInt("totalPopularMoviePage");
  }

  Future<bool> setUpComingMoviePage(int page) {
    return _pref.setInt("upComingMoviePage", page);
  }

  Future<bool> setTotalUpComingMoviePage(int page) {
    return _pref.setInt("totalUpComingMoviePage", page);
  }

  Future<bool> setPopularMoviePage(int page) {
    return _pref.setInt("popularMoviePage", page);
  }

  Future<bool> setTotalPopularMoviePage(int page) {
    return _pref.setInt("totalPopularMoviePage", page);
  }
}
