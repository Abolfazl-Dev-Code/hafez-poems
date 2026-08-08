import 'package:flutter/material.dart';
import 'package:hafez_poems/Initializers_and_Boot/app_initializer.dart';
import 'package:hafez_poems/Initializers_and_Boot/main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.run();
  runApp(const MainApp());
}

//? new futures ---------
//! Bugs
//! یکی اینکه وقتی بزنی روی تا اینجا خوانده ام و صفحه رو باز و بسته کنی پاک میشه و از بین میره
//! دومی اینکه اگه شعر دیگه ای رو بزنی باز هم این یکی از بین میره
//todo: افزودن بخش پادکست ها
//todo: تنظیم فونت رنگ و سایز متن در اشتراک گذاری مصرع
