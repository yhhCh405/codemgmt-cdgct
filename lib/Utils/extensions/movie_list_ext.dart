import 'package:code_mgmt_cdgct/Models/movie.dart';

extension MovieListExt on List<Movie> {
  List<Movie> trimDuplicates() {
    return toSet().toList();
  }
}
