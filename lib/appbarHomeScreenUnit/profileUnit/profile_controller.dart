import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:hafez_poems/appbarHomeScreenUnit/profileUnit/avatar_crop_screen.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/bottomNavBar/user_actions_saver.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:hafez_poems/models/highlight_item.dart';
import 'package:hafez_poems/models/liked_item.dart';
import 'package:hafez_poems/models/saved_item.dart';

class ProfileController extends GetxController {
  late final Box<LikedItem> likedBox;
  late final Box<SavedItem> savedBox;
  late final Box<HighlightItem> highlightBox;
  late final Box readBox;
  late final Box profileBox;
  final streakCount = 0.obs;
  static const _kStreakCount = 'streakCount';
  static const _kLastStreakDate = 'lastStreakDate';
  final bestStreak = 0.obs;
  static const _kBestStreak = 'bestStreak';
  final bio = ''.obs;
  final customBios = <String>[].obs;

  static const _kBio = 'bio';
  static const _kCustomBios = 'customBios';

  static const List<String> presetBios = [
    'همراه غزل‌ها و بیت‌های ماندگار',
    'در جست‌وجوی معنا میان ابیات حافظ',
    'هر روز یک بیت، هر بیت یک دنیا',
    'عاشق کلام حافظ و رندی شیرازی',
    'دیوانه‌ی دیوان حافظ',
  ];
  final userName = ''.obs;
  final avatarPath = RxnString();

  static const _kName = 'name';
  static const _kAvatarPath = 'avatarPath';
  static const String readBoxName = 'read_poems_box';
  static const int totalGhazals = 495;
  static const _kHasSeenEditHint = 'hasSeenEditHint';

  final likedCount = 0.obs;
  final savedCount = 0.obs;
  final highlightedCount = 0.obs;

  final likedRatio = 0.0.obs;
  final savedRatio = 0.0.obs;
  final readCount = 0.obs;
  final readRatio = 0.0.obs;
  final showEditHint = false.obs;

  final recentLikedTitles = <String>[].obs;
  final recentSavedTitles = <String>[].obs;
  final recentHighlightTexts = <String>[].obs;

  final mostReadTitle = ''.obs;
  final favoriteQuote = ''.obs;

  @override
  void onInit() {
    super.onInit();
    profileBox = Hive.box('profile_box');

    userName.value =
        (profileBox.get(_kName) as String?)?.trim().isNotEmpty == true
        ? (profileBox.get(_kName) as String).trim()
        : '';

    avatarPath.value = (profileBox.get(_kAvatarPath) as String?)?.trim();
    bio.value = (profileBox.get(_kBio) as String?)?.trim().isNotEmpty == true
        ? (profileBox.get(_kBio) as String).trim()
        : presetBios.first;

    final storedCustomBios = profileBox.get(_kCustomBios);
    if (storedCustomBios is List) {
      customBios.value = storedCustomBios.cast<String>();
    }
    likedBox = Hive.box<LikedItem>(UserActionsSaver.likedBoxName);
    savedBox = Hive.box<SavedItem>(UserActionsSaver.savedBoxName);
    highlightBox = Hive.box<HighlightItem>(UserActionsSaver.highlightBoxName);
    readBox = Hive.box(readBoxName);
    bestStreak.value = profileBox.get(_kBestStreak, defaultValue: 0) as int;
    _updateStreak();
    _loadData();

    likedBox.listenable().addListener(_loadData);
    savedBox.listenable().addListener(_loadData);
    highlightBox.listenable().addListener(_loadData);
  }

  Future<void> updateName(String newName) async {
    final name = newName.trim();
    if (name.isEmpty) return;
    userName.value = name;
    await profileBox.put(_kName, name);
  }

  Future<void> updateBio(String newBio) async {
    final trimmed = newBio.trim();
    if (trimmed.isEmpty) return;
    bio.value = trimmed;
    await profileBox.put(_kBio, trimmed);
  }

  Future<void> addCustomBio(String newBio) async {
    final trimmed = newBio.trim();
    if (trimmed.isEmpty) return;
    if (!customBios.contains(trimmed)) {
      customBios.add(trimmed);
      await profileBox.put(_kCustomBios, customBios.toList());
    }
    await updateBio(trimmed);
  }

  Future<void> removeCustomBio(String bioText) async {
    customBios.remove(bioText);
    await profileBox.put(_kCustomBios, customBios.toList());
    if (bio.value == bioText) {
      await updateBio(presetBios.first);
    }
  }

  Future<void> pickAndSaveAvatar() async {
    try {
      final picker = ImagePicker();

      final XFile? picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 95,
      );
      if (picked == null) return;

      final Uint8List imageBytes = await File(picked.path).readAsBytes();

      final Uint8List? croppedBytes = await Get.to<Uint8List?>(
        () => AvatarCropScreen(imageBytes: imageBytes),
        transition: Transition.cupertino,
        fullscreenDialog: true,
      );

      if (croppedBytes == null) return;

      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.png';
      final filePath = p.join(appDir.path, fileName);

      final savedFile = await File(filePath).writeAsBytes(croppedBytes);

      avatarPath.value = savedFile.path;
      await profileBox.put(_kAvatarPath, savedFile.path);
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> _updateStreak() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final lastStr = profileBox.get(_kLastStreakDate) as String?;
    final savedStreak = profileBox.get(_kStreakCount, defaultValue: 0) as int;

    if (lastStr == null) {
      streakCount.value = 1;
    } else {
      final last = DateTime.parse(lastStr);
      final lastDay = DateTime(last.year, last.month, last.day);
      final diff = today.difference(lastDay).inDays;

      if (diff == 0) {
        streakCount.value = savedStreak;
      } else if (diff == 1) {
        streakCount.value = savedStreak + 1;
      } else {
        streakCount.value = 1;
      }
    }

    await profileBox.put(_kStreakCount, streakCount.value);
    await profileBox.put(_kLastStreakDate, today.toIso8601String());

    if (streakCount.value > bestStreak.value) {
      bestStreak.value = streakCount.value;
      await profileBox.put(_kBestStreak, bestStreak.value);
    }
  }

  Future<void> removeAvatar() async {
    avatarPath.value = null;
    await profileBox.delete(_kAvatarPath);
  }

  Future<void> dismissEditHint() async {
    if (!showEditHint.value) return;
    showEditHint.value = false;
    await profileBox.put(_kHasSeenEditHint, true);
  }

  @override
  void onClose() {
    likedBox.listenable().removeListener(_loadData);
    savedBox.listenable().removeListener(_loadData);
    highlightBox.listenable().removeListener(_loadData);
    readBox.listenable().removeListener(_loadData);
    super.onClose();
  }

  void _loadData() {
    final likedItems = likedBox.values.toList().reversed.toList();
    final savedItems = savedBox.values.toList().reversed.toList();
    final highlightItems = highlightBox.values.toList().reversed.toList();

    likedCount.value = likedItems.length;
    savedCount.value = savedItems.length;
    highlightedCount.value = highlightItems.length;
    likedRatio.value = totalGhazals > 0 ? likedCount.value / totalGhazals : 0.0;
    savedRatio.value = totalGhazals > 0 ? savedCount.value / totalGhazals : 0.0;
    readCount.value = readBox.keys.length;
    readRatio.value = totalGhazals > 0 ? readCount.value / totalGhazals : 0.0;

    recentLikedTitles.value = likedItems
        .map((e) => e.title.trim())
        .where((t) => t.isNotEmpty)
        .take(3)
        .toList();

    recentSavedTitles.value = savedItems
        .map((e) => e.title.trim())
        .where((t) => t.isNotEmpty)
        .take(3)
        .toList();

    recentHighlightTexts.value = highlightItems
        .map((e) => e.highlightedLine.trim())
        .where((t) => t.isNotEmpty)
        .take(3)
        .toList();

    mostReadTitle.value = _getMostRepeatedTitle([
      ...likedItems.map((e) => e.title.trim()),
      ...savedItems.map((e) => e.title.trim()),
      ...highlightItems.map((e) => e.ghazalTitle.trim()),
    ]);

    favoriteQuote.value = recentHighlightTexts.isNotEmpty
        ? recentHighlightTexts.first
        : 'هنوز برگزیده‌ی ثبت نشده است';
  }

  String _getMostRepeatedTitle(List<String> titles) {
    final clean = titles
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (clean.isEmpty) return '';

    final Map<String, int> freq = {};
    for (final t in clean) {
      freq[t] = (freq[t] ?? 0) + 1;
    }

    String best = '';
    int bestCount = 0;

    freq.forEach((k, v) {
      if (v > bestCount) {
        best = k;
        bestCount = v;
      }
    });

    return best;
  }
}
