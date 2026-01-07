import 'package:flutter/material.dart';
import 'package:pet_shop_app/core/app/app_initializer.dart';
import 'package:pet_shop_app/core/app/app_widget.dart';

void main() async {
  await AppInitializer.initialize();
  runApp(const AppWidget());
}
