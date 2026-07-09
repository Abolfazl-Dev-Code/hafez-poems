// lib/core/data/hive/hive_box_utils.dart
//
// تابع مشترک برای باز کردن ایمن باکس‌های Hive.
//
// این منطق عیناً از openBoxSafely در hive_boot.dart گرفته شده (نمی‌خواستیم
// این رفتار محافظتی از قبل موجود را در طول refactor از دست بدهیم): اگر
// فایل باکس روی دیسک خراب یا ناسازگار باشد (مثلاً بعد از تغییر ساختار
// مدل)، به‌جای کرش کردن کل اپ، باکس را پاک و از نو می‌سازد.
//
// چهار کلاس Hive*Storage همگی از همین یک تابع استفاده می‌کنند تا این
// منطق در چهار جای مختلف تکرار نشود.

import 'package:hive_flutter/hive_flutter.dart';

Future<Box<T>> openHiveBoxSafely<T>(String name) async {
  try {
    return await Hive.openBox<T>(name);
  } catch (e) {
    if (Hive.isBoxOpen(name)) await Hive.box(name).close();
    await Hive.deleteBoxFromDisk(name);
    return await Hive.openBox<T>(name);
  }
}
