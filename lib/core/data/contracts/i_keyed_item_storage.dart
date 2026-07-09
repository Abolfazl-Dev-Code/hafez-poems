// lib/core/data/contracts/i_keyed_item_storage.dart
//
// قرارداد ذخیره‌سازی برای مجموعه‌ای از آیتم‌های کلید-دار (liked, saved,
// highlighted lines). هر سه‌ی این‌ها الگوی یکسانی دارند: بر اساس یک کلید
// رشته‌ای (مثلاً id غزل، یا ترکیب id+lineIndex برای highlight) یک آیتم
// تایپ‌شده ذخیره/حذف/خوانده می‌شود.
//
// این اینترفیس generic است (روی T) تا هم برای LikedItem، هم SavedItem، هم
// HighlightItem قابل استفاده باشد بدون تکرار کد.

abstract interface class IKeyedItemStorage<T> {
  /// آیا آیتمی با این کلید وجود دارد؟ (مثلاً برای isLiked/isSaved)
  bool containsKey(String key);

  /// آیتم مربوط به این کلید را برمی‌گرداند، یا null اگر وجود نداشت.
  T? get(String key);

  /// آیتم را با این کلید ذخیره/به‌روزرسانی می‌کند.
  Future<void> put(String key, T value);

  /// آیتم مربوط به این کلید را حذف می‌کند.
  Future<void> delete(String key);

  /// همه‌ی آیتم‌های موجود را برمی‌گرداند (مثلاً برای getAllLikedGhazals
  /// یا شمارش تعداد در ProfileController).
  List<T> values();

  /// هر تغییری (افزودن/حذف/به‌روزرسانی) یک رویداد در این stream منتشر
  /// می‌کند. جایگزین Hive's `.listenable()` است؛ کد بالادستی (مثل
  /// ProfileController) به‌جای listenable مستقیم Hive، این stream را
  /// گوش می‌دهد و از جزئیات Hive بی‌خبر می‌ماند.
  Stream<void> watch();

  /// همه‌ی آیتم‌ها را یک‌جا پاک می‌کند (برای «پاک کردن کامل داده‌ها» در
  /// تنظیمات).
  Future<void> clear();
}
