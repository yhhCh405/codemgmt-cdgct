import 'package:code_mgmt_cdgct/Models/movie.dart';
import 'package:code_mgmt_cdgct/Models/result.dart';
import 'package:code_mgmt_cdgct/Repositories/movies_repo.dart';
import 'package:code_mgmt_cdgct/Services/shared_pref_service.dart';
import 'package:code_mgmt_cdgct/Utils/extensions/movie_list_ext.dart';
import 'package:get/get.dart';

class MoviesVM extends GetxController {
  final upcomingMovies = Rxn<List<Movie>>();
  final popularMovies = Rxn<List<Movie>>();
  final MoviesRepo _moviesRepo = MoviesRepo();
  final RxBool isNoUpcomingVideo = false.obs;
  final RxBool isNoPopularVideo = false.obs;
  bool get hasPopularMovie =>
      popularMovies.value != null && popularMovies.value!.isNotEmpty;
  bool get hasUpcomingMovie =>
      upcomingMovies.value != null && upcomingMovies.value!.isNotEmpty;
  final errorPopularVideoMsg = RxnString();
  final errorUpcomingVideoMsg = RxnString();
  RxBool noMoreUpcomingVideos = false.obs;
  RxBool noMorePopularVideos = false.obs;

  init() {
    upcomingMovies.value ??= SharedPrefService.instance.getUpcomingMovies();
    popularMovies.value ??= SharedPrefService.instance.getPopularMovies();
  }

  Future<void> getUpcomingMovies() async {
    upcomingMovies.value ??= SharedPrefService.instance.getUpcomingMovies();
    Result res = await _fetchUpcomingMovies();
    if (!res.success) {
      errorUpcomingVideoMsg.value = res.errorMessage;
    }
  }

  Future<void> getPopularVideos() async {
    popularMovies.value ??= SharedPrefService.instance.getPopularMovies();
    Result res = await _fetchPopularMovies();
    if (!res.success) {
      errorPopularVideoMsg.value = res.errorMessage;
    }
  }

  Future<Result<void>> _fetchUpcomingMovies() async {
    final _res = await _moviesRepo.getUpComingMovies();
    if (_res.success) {
      if (_res.data != null) {
        (upcomingMovies.value ??= []).addAll(_res.data!);
        upcomingMovies.value = upcomingMovies.value!.trimDuplicates();
        SharedPrefService.instance.saveUpcomingMovies(upcomingMovies.value!);
      } else {
        if (upcomingMovies.value == null) isNoUpcomingVideo.value = true;
      }
    } else {
      errorUpcomingVideoMsg.value = _res.errorMessage;
    }
    return _res;
  }

  Future<Result<void>> _fetchPopularMovies() async {
    final _res = await _moviesRepo.getPopularMovies();
    if (_res.success) {
      if (_res.data != null) {
        (popularMovies.value ??= []).addAll(_res.data!);
        popularMovies.value = popularMovies.value!.trimDuplicates();
        SharedPrefService.instance.savePopularMovies(popularMovies.value!);
      } else {
        if (popularMovies.value == null) isNoPopularVideo.value = true;
      }
    } else {
      errorPopularVideoMsg.value = _res.errorMessage;
    }
    return _res;
  }
}
