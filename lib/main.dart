import 'package:flutter/material.dart';
import 'package:hafez_poems/Initializers%20and%20Boot/app_initializer.dart';
import 'package:hafez_poems/Initializers%20and%20Boot/main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.run();
  runApp(const MainApp());
}

//---------
//todo: جست و جویی که بیشترین همخوانی رو با کلمه یا جمله سرچ شده داره در بالا نمایش داده بشه
//todo: بهبود ظاهری صفحه اشعار
//todo: بهبود ظاهری صفحه فال
//todo: افزودن بخش پادکست ها
//todo: افزودن بخش کمک مشاعره از دیوان حافظ
//---------
