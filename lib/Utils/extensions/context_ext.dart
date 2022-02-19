import 'package:flutter/material.dart';

extension contextExt on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
  Future<T?> next<T>(Widget screen) =>
      Navigator.push<T>(this, MaterialPageRoute(builder: (context) => screen));

  void back<T>([T? result]) => Navigator.pop<T>(this, result);

  void unFocus() => FocusScope.of(this).unfocus();
}
