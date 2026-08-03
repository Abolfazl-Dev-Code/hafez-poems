import 'package:flutter/material.dart';
import 'package:hafez_poems/Initializers_and_Boot/app_initializer.dart';
import 'package:hafez_poems/Initializers_and_Boot/main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.run();
  runApp(const MainApp());
}

//? new futures ---------
//todo: افزودن بخش تا اینجا خوانده ام
//todo: بهبود ظاهری صفحه فال
//todo: افزودن بخش پادکست ها
//todo: تنظیم فونت رنگ و سایز متن در اشتراک گذاری مصرع
