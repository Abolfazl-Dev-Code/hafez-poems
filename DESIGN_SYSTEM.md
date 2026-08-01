# Design System — اشعار حافظ (Hafez Poems)

مستند سیستم طراحی بر اساس فایل‌های موجود در `lib/theme/` و الگوهای مصرف‌شده در سراسر پروژه.

## 1. رنگ‌ها (`AppColors`)

### Light Theme

| نقش            | متغیر           | مقدار           |
| -------------- | --------------- | --------------- |
| Primary        | `primary`       | `#6E473B`       |
| Secondary      | `secondary`     | `#03A9F4`       |
| Accent         | `accent`        | `#FFC107`       |
| Success        | `success`       | `#4CAF50`       |
| Warning        | `warning`       | `#FF9800`       |
| Error          | `error`         | `#F44336`       |
| Background     | `background`    | `#E1D4C2`       |
| Surface        | `surface`       | `#F5EFE6`       |
| Text Primary   | `textPrimary`   | `#291C0E`       |
| Text Secondary | `textSecondary` | `#A78D78`       |
| Border         | `border`        | `#BEB5A9`       |
| Icon           | `icon`          | `#6E473B`       |
| Shadow         | `shadow`        | `#291C0E` @ 10% |

### Dark Theme

| نقش            | متغیر               | مقدار           |
| -------------- | ------------------- | --------------- |
| Primary        | `darkPrimary`       | `#D2B49C`       |
| Secondary      | `darkSecondary`     | `#4FC3F7`       |
| Accent         | `darkAccent`        | `#FFD54F`       |
| Background     | `darkBackground`    | `#1E1712`       |
| Surface        | `darkSurface`       | `#2A211B`       |
| Text Primary   | `darkTextPrimary`   | `#F5EFE6`       |
| Text Secondary | `darkTextSecondary` | `#D0C2B2`       |
| Border         | `darkBorder`        | `#4A3A30`       |
| Icon           | `darkIcon`          | `#F5EFE6`       |
| Shadow         | `darkShadow`        | `#000000` @ 20% |

پالت با الهام از رنگ‌های خاک، چوب و کاغذ کهنه (تم "دیوان حافظ") ساخته شده؛ در حالت تیره primary/secondary/accent روشن‌تر می‌شوند تا کنتراست حفظ شود.

## 2. تایپوگرافی (`AppTextStyles`)

فونت: **Vazir** (تنها فونت پروژه، برای فارسی/RTL).

| Style                | Size | Weight          | رنگ پیش‌فرض      |
| -------------------- | ---- | --------------- | ---------------- |
| `titleLarge`         | 22   | Bold            | textPrimary      |
| `titleMedium`        | 18   | SemiBold (w600) | textPrimary      |
| `titleMediumSetting` | 18   | SemiBold        | settingColorText |
| `bodyLarge`          | 16   | Regular         | textPrimary      |
| `bodyMedium`         | 12   | Regular         | textSecondary    |
| `bodyMediumSetting`  | 12   | Regular         | settingColorText |
| `button`             | 16   | SemiBold        | white            |
| `caption`            | 12   | Regular         | textSecondary    |

نکته: نسخه فایل‌ها بین `'vazir'` و `'Vazir'` ناسازگار است (۲۳ در برابر ۱۲ مورد) — پیشنهاد: یکسان‌سازی به `AppTextStyles.fontFamily` در همه‌جا به‌جای رشتهٔ خام.

## 3. Spacing Scale (پیشنهادی، بر پایه مقادیر پراستفاده فعلی)

مقادیر فعلی EdgeInsets در کل پروژه پراکنده و بدون سیستم‌اند (۴، ۸، ۱۲، ۱۴، ۱۶، ۱۸، ۲۰، ۳۲...). پیشنهاد یکسان‌سازی حول یک مقیاس 4px:

```
xs  = 4
sm  = 8
md  = 12
lg  = 16
xl  = 20
xxl = 32
```

## 4. Radius Scale

مقادیر پراستفاده فعلی: 12، 14، 16، 20 (بیشترین تکرار). پیشنهاد استاندارد:

```
radiusSm  = 8    // چیپ‌ها، تگ‌ها
radiusMd  = 12   // دکمه‌ها، اینپوت‌ها (مطابق ElevatedButton و InputDecoration فعلی)
radiusLg  = 16   // کارت‌ها
radiusXl  = 20   // شیت‌ها، دیالوگ‌ها، کارت‌های بزرگ
radiusPill = 100 // آواتار / دکمه‌های کاملاً گرد
```

## 5. کامپوننت‌ها

### Buttons

`ElevatedButton`: پس‌زمینه `primary` (لایت) / `darkPrimary` (دارک)، متن `button` style، `radiusMd` (12).

### Inputs

پرشده (`filled: true`)، پس‌زمینه `surface`/`darkSurface`، border رنگ `border`/`darkBorder`، حالت focus با رنگ primary و ضخامت 2، radius 12.

### Switch

Thumb/Track بر پایه `WidgetStateProperty` — انتخاب‌شده = primary، غیرفعال = border/textPrimary بسته به تم.

### AppBar

بدون سایه (`elevation: 0`)، پس‌زمینه هم‌رنگ background/darkBackground، عنوان وسط‌چین (`centerTitle: true`).

### Cards / Shadow

سایه پیشنهادی برای کارت‌ها: `AppColors.shadow` (لایت) یا `darkShadow` (تیره) با blur 8–12 و offset (0,2)، هماهنگ با ۱۷ مورد استفاده فعلی `BoxShadow` در پروژه (که فعلاً رنگ‌بندی یکسانی ندارند — پیشنهاد: همه به `AppColors.shadow` ارجاع بدهند).

## 6. آیکون‌ها (`AppIcons`)

آیکون‌های انیمیشنی Lottie (`.json`) در `assets/icons/animatedIcons/`، دسته‌بندی‌شده بر اساس محل مصرف (AppBar، Greeting، Navigation، PoemScreen). نام‌گذاری بر اساس رنگ زمینه (`black-*` برای پس‌زمینه روشن، `white-*` برای تیره/پرکنتراست).

## 7. مدیریت تم (`ThemeController`)

`GetX`-based، حالت در `SharedPreferences` (`is_dark_mode`) ذخیره و در بوت اپ بازیابی می‌شود. سوییچ تم با `toggleTheme` / `setLightTheme` / `setDarkTheme`.

## 8. جهت و زبان

اپ کاملاً RTL و فارسی است؛ هر ویجت متنی یا Row جدید باید صراحتاً رفتار RTL (`TextDirection`, `MainAxisAlignment` معکوس در صورت نیاز) را در نظر بگیرد، چون در ThemeData مقداری برای Directionality تنظیم نشده و باید در سطح `MaterialApp` کنترل شود.

## 9. توصیه‌های یکسان‌سازی

1. یکسان‌سازی `fontFamily` (حذف رشته خام `'Vazir'`/`'vazir'`، استفاده از `AppTextStyles.fontFamily`).
2. تعریف کلاس‌های `AppSpacing` و `AppRadius` برای جایگزینی اعداد خام پراکنده.
3. مرکزی‌سازی `BoxShadow` در یک `AppShadows` بر پایه `AppColors.shadow`/`darkShadow`.
4. افزودن `elevatedButtonTheme`، `switchTheme` و `inputDecorationTheme` بیشتر (مثلاً `textButtonTheme`, `cardTheme`, `bottomSheetTheme`) برای کاهش استایل‌دهی دستی در ویجت‌ها.
