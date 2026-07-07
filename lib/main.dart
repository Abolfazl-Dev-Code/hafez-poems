import 'package:flutter/material.dart';
import 'package:hafez_poems/Initializers%20and%20Boot/app_initializer.dart';
import 'package:hafez_poems/Initializers%20and%20Boot/main_app.dart';

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

//! Urgent ---------
//todo: اخرین مصرع انتخاب شده منویی نمایش نمیده
//todo: فاصله اخرین مصرع باز شده یا هرکدام از مصرع ها که منوی ان باز شده با سینک شدن صدا جا به جا میشود
//todo: رنگ مصرع های انتخاب نشده با رنگ بکگراند اشعار در تم شب و روز یکی باشد
