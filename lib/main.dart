import 'package:flutter/material.dart';
import 'package:hafez_poems/Initializers%20and%20Boot/app_initializer.dart';
import 'package:hafez_poems/Initializers%20and%20Boot/main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.run();
  runApp(const MainApp());
}
