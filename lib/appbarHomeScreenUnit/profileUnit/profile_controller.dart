import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:hafez_poems/appbarHomeScreenUnit/profileUnit/avatar_crop_screen.dart';
import 'package:hafez_poems/core/data/contracts/i_keyed_item_storage.dart';
import 'package:hafez_poems/core/data/contracts/i_read_status_storage.dart';
import 'package:hafez_poems/core/data/contracts/i_settings_storage.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/notification_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:hafez_poems/models/highlight_item.dart';
import 'package:hafez_poems/models/liked_item.dart';
import 'package:hafez_poems/models/saved_item.dart';

class ProfileController extends GetxController {
  late final IKeyedItemStorage<LikedItem> _likedStorage;
  late final IKeyedItemStorage<SavedItem> _savedStorage;
  late final IKeyedItemStorage<HighlightItem> _highlightStorage;
  late final IReadStatusStorage _readStatus;
  late final ISettingsStorage _settings;

  StreamSubscription<void>? _likedSubscription;
  StreamSubscription<void>? _savedSubscription;
  StreamSubscription<void>? _highlightSubscription;
  StreamSubscription<void>? _readStatusSubscription;

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

    _likedStorage = Get.find<IKeyedItemStorage<LikedItem>>();
    _savedStorage = Get.find<IKeyedItemStorage<SavedItem>>();
    _highlightStorage = Get.find<IKeyedItemStorage<HighlightItem>>();
    _readStatus = Get.find<IReadStatusStorage>();
    _settings = Get.find<ISettingsStorage>();

    final storedName = _settings.get<String>(_kName);
    userName.value = (storedName?.trim().isNotEmpty == true)
        ? storedName!.trim()
        : '';

    avatarPath.value = _settings.get<String>(_kAvatarPath)?.trim();

    final storedBio = _settings.get<String>(_kBio);
    bio.value = (storedBio?.trim().isNotEmpty == true)
        ? storedBio!.trim()
        : presetBios.first;

    final storedCustomBios = _settings.get<List>(_kCustomBios);
    if (storedCustomBios != null) {
      customBios.value = storedCustomBios.cast<String>();
    }

    bestStreak.value = _settings.getOrDefault<int>(_kBestStreak, 0);
    _updateStreak();
    _loadData();

    _likedSubscription = _likedStorage.watch().listen((_) => _loadData());
    _savedSubscription = _savedStorage.watch().listen((_) => _loadData());
    _highlightSubscription = _highlightStorage.watch().listen(
      (_) => _loadData(),
    );
    _readStatusSubscription = _readStatus.watch().listen((_) => _loadData());
  }

  Future<void> updateName(String newName) async {
    final name = newName.trim();
    if (name.isEmpty) return;
    userName.value = name;
    await _settings.put(_kName, name);
    await NotificationService.instance.scheduleDailyReminder();
  }

  Future<void> updateBio(String newBio) async {
    final trimmed = newBio.trim();
    if (trimmed.isEmpty) return;
    bio.value = trimmed;
    await _settings.put(_kBio, trimmed);
  }

  Future<void> addCustomBio(String newBio) async {
    final trimmed = newBio.trim();
    if (trimmed.isEmpty) return;
    if (!customBios.contains(trimmed)) {
      customBios.add(trimmed);
      await _settings.put(_kCustomBios, customBios.toList());
    }
    await updateBio(trimmed);
  }

  Future<void> removeCustomBio(String bioText) async {
    customBios.remove(bioText);
    await _settings.put(_kCustomBios, customBios.toList());
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
      await _settings.put(_kAvatarPath, savedFile.path);
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> _updateStreak() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final lastStr = _settings.get<String>(_kLastStreakDate);
    final savedStreak = _settings.getOrDefault<int>(_kStreakCount, 0);

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

    await _settings.put(_kStreakCount, streakCount.value);
    await _settings.put(_kLastStreakDate, today.toIso8601String());

    if (streakCount.value > bestStreak.value) {
      bestStreak.value = streakCount.value;
      await _settings.put(_kBestStreak, bestStreak.value);
    }
  }

  Future<void> removeAvatar() async {
    avatarPath.value = null;
    await _settings.delete(_kAvatarPath);
  }

  Future<void> dismissEditHint() async {
    if (!showEditHint.value) return;
    showEditHint.value = false;
    await _settings.put(_kHasSeenEditHint, true);
  }

  @override
  void onClose() {
    _likedSubscription?.cancel();
    _savedSubscription?.cancel();
    _highlightSubscription?.cancel();
    _readStatusSubscription?.cancel();
    super.onClose();
  }

  void _loadData() {
    final likedItems = _likedStorage.values().reversed.toList();
    final savedItems = _savedStorage.values().reversed.toList();
    final highlightItems = _highlightStorage.values().reversed.toList();

    likedCount.value = likedItems.length;
    savedCount.value = savedItems.length;
    highlightedCount.value = highlightItems.length;
    likedRatio.value = totalGhazals > 0 ? likedCount.value / totalGhazals : 0.0;
    savedRatio.value = totalGhazals > 0 ? savedCount.value / totalGhazals : 0.0;
    readCount.value = _readStatus.count;
    readRatio.value = totalGhazals > 0 ? readCount.value / totalGhazals : 0.0;

    recentLikedTitles.value = likedItems
        .map((e) => e.poemTitle.trim())
        .where((t) => t.isNotEmpty)
        .take(3)
        .toList();

    recentSavedTitles.value = savedItems
        .map((e) => e.poemTitle.trim())
        .where((t) => t.isNotEmpty)
        .take(3)
        .toList();

    recentHighlightTexts.value = highlightItems
        .map((e) => e.highlightedLine.trim())
        .where((t) => t.isNotEmpty)
        .take(3)
        .toList();

    mostReadTitle.value = _getMostRepeatedTitle([
      ...likedItems.map((e) => e.poemTitle.trim()),
      ...savedItems.map((e) => e.poemTitle.trim()),
      ...highlightItems.map((e) => e.poemTitle.trim()),
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
