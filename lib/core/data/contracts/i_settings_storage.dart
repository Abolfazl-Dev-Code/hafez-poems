// lib/core/data/contracts/i_settings_storage.dart
//
// قرارداد ذخیره‌سازی برای تنظیمات و آمار عمومی پروفایل (نام، آواتار،
// بیوگرافی، streak و غیره). برخلاف سه اینترفیس دیگر، این یکی یک
// key-value store عمومی است، نه مجموعه‌ای از آیتم‌های تایپ‌شده.
//
// نکته‌ی طراحی: این اینترفیس عمداً watch() ندارد، چون در کد فعلی
// (profile_controller.dart) هیچ‌جا به تغییرات profileBox reactive گوش
// داده نمی‌شود — فقط liked/saved/highlight/read چنین رفتاری دارند.

abstract interface class ISettingsStorage {
  /// مقدار ذخیره‌شده برای این کلید را برمی‌گرداند، یا null اگر وجود
  /// نداشت (مثلاً avatarPath که ممکن است کاربر هنوز آواتاری ست نکرده
  /// باشد).
  T? get<T>(String key);

  /// مثل [get]، ولی وقتی کلید وجود نداشت، به‌جای null یک مقدار پیش‌فرض
  /// معنی‌دار برمی‌گرداند (مثلاً bestStreak که پیش‌فرضش صفر است).
  T getOrDefault<T>(String key, T defaultValue);

  /// مقداری را برای این کلید ذخیره/به‌روزرسانی می‌کند.
  Future<void> put(String key, dynamic value);

  /// مقدار این کلید را حذف می‌کند (مثلاً removeAvatar).
  Future<void> delete(String key);
}
