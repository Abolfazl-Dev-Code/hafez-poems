import 'package:flutter/material.dart';
import 'package:hafez_poems/Initializers_and_Boot/app_initializer.dart';
import 'package:hafez_poems/Initializers_and_Boot/main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.run();
  runApp(const MainApp());
}

//? new futures ---------
//todo: باز طراحی نوبار
//todo: بهبود ظاهری صفحه اشعار
//todo: بهبود ظاهری صفحه فال
//todo: افزودن بخش پادکست ها
//todo: افزودن بخش کمک مشاعره از دیوان حافظ
//todo: تنظیم فونت رنگ و سایز متن در اشتراک گذاری مصرع
