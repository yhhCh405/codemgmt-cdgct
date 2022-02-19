import 'package:code_mgmt_cdgct/Services/dependencies_binding.dart';
import 'package:code_mgmt_cdgct/Services/hive_service.dart';
import 'package:code_mgmt_cdgct/Services/shared_pref_service.dart';
import 'package:code_mgmt_cdgct/Views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  await SharedPrefService.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: DependenciesBinding(),
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: HomeView(),
    );
  }
}
