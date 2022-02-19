import 'package:code_mgmt_cdgct/Models/movie.dart';
import 'package:code_mgmt_cdgct/Models/result.dart';
import 'package:code_mgmt_cdgct/Repositories/base_connect.dart';
import 'package:code_mgmt_cdgct/Services/shared_pref_service.dart';
import 'package:code_mgmt_cdgct/ViewModels/movies_vm.dart';
import 'package:get/get_connect.dart';
import 'package:get/instance_manager.dart';

class MoviesRepo extends BaseConnect {
  int? _upcomingMoviePage = SharedPrefService.instance.getUpComingMoviePage();
  int? _totalUpcomingMoviePages =
      SharedPrefService.instance.getTotalUpComingMoviePage();
  int? _popularMoviePage = SharedPrefService.instance.getPopularMoviePage();
  int? _totalPopularMoviePages =
      SharedPrefService.instance.getTotalPopularMoviePage();

  Future<Result<List<Movie>>> getUpComingMovies({int? page}) async {
    Map<String, dynamic>? _params;
    if (page != null) {
      _params = {"page": page};
    } else if (_upcomingMoviePage != null &&
        _totalUpcomingMoviePages != null &&
        _upcomingMoviePage! < _totalUpcomingMoviePages!) {
      _params = {"page": (_upcomingMoviePage! + 1).toString()};
    }
    _params = addAuthorizationParams(_params);
    Response resp = await get("https://api.themoviedb.org/3/movie/upcoming",
        query: _params);
    if (resp.statusCode == 200) {
      _upcomingMoviePage = resp.body['page'];
      _totalUpcomingMoviePages = resp.body["total_pages"];
      if (_upcomingMoviePage != null) {
        SharedPrefService.instance.setUpComingMoviePage(_upcomingMoviePage!);
      }
      if (_totalUpcomingMoviePages != null) {
        SharedPrefService.instance
            .setTotalUpComingMoviePage(_totalUpcomingMoviePages!);
      }
      if (_upcomingMoviePage == _totalUpcomingMoviePages) {
        Get.find<MoviesVM>().noMoreUpcomingVideos.value = true;
      }
      return Result.success(
          data: (resp.body["results"] as List)
              .map((e) => Movie.fromJSON(e))
              .toList());
    } else if (resp.statusCode == 401) {
      return Result.error(resp.body["error_message"] ??
          resp.body["status_message"] ??
          "Unknown Error");
    } else {
      return Result.error(resp.body["status_message"] ?? "Unknown Error");
    }
  }

  Future<Result<List<Movie>>> getPopularMovies({int? page}) async {
    Map<String, dynamic>? _params;
    if (page != null) {
      _params = {"page": page};
    } else if (_popularMoviePage != null &&
        _totalPopularMoviePages != null &&
        _popularMoviePage! < _totalPopularMoviePages!) {
      _params = {"page": (_popularMoviePage! + 1).toString()};
    }

    _params = addAuthorizationParams(_params);
    Response resp =
        await get("https://api.themoviedb.org/3/movie/popular", query: _params);
    if (resp.statusCode == 200) {
      _popularMoviePage = resp.body['page'];
      _totalPopularMoviePages = resp.body["total_pages"];
      if (_popularMoviePage != null) {
        SharedPrefService.instance.setPopularMoviePage(_popularMoviePage!);
      }
      if (_totalPopularMoviePages != null) {
        SharedPrefService.instance
            .setTotalPopularMoviePage(_totalPopularMoviePages!);
      }
      if (_popularMoviePage == _totalPopularMoviePages) {
        Get.find<MoviesVM>().noMorePopularVideos.value = true;
      }
      return Result.success(
          data: (resp.body["results"] as List)
              .map((e) => Movie.fromJSON(e))
              .toList());
    } else if (resp.statusCode == 401) {
      return Result.error(resp.body["error_message"] ??
          resp.body["status_message"] ??
          "Unknown Error");
    } else {
      return Result.error(resp.body?["status_message"] ?? "Unknown Error");
    }
  }
}
