import 'package:flutter/material.dart';
import 'package:hafez_poems/Initializers_and_Boot/app_initializer.dart';
import 'package:hafez_poems/Initializers_and_Boot/main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.run();
  runApp(const MainApp());
}

//? new futures ---------
//todo: بهبود ظاهری صفحه اشعار
//todo: بهبود ظاهری صفحه فال
//todo: افزودن بخش پادکست ها
//todo: افزودن بخش کمک مشاعره از دیوان حافظ
//todo: بخشی که کاربر از مصرع موردنظرش صدا را پخش کند
//todo: ایکون پاز و قزع صدا در بخش زندگینامه حافط چند ثانیه بعد از اسکرول خودکار محو شوند
