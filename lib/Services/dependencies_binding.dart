import 'package:code_mgmt_cdgct/ViewModels/movies_vm.dart';
import 'package:get/get.dart';

class DependenciesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MoviesVM>(() => MoviesVM()..init());
  }
}
