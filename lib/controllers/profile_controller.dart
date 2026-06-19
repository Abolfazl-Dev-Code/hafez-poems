import 'dart:io';
import 'dart:typed_data';
import 'package:hafez_poems/screens/avatar_crop_screen.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:hafez_poems/controllers/user_actions_controller.dart';
import 'package:hafez_poems/models/highlight_item.dart';
import 'package:hafez_poems/models/liked_item.dart';
import 'package:hafez_poems/models/saved_item.dart';

class ProfileController extends GetxController {
  late final Box<LikedItem> likedBox;
  late final Box<SavedItem> savedBox;
  late final Box<HighlightItem> highlightBox;
  late final Box profileBox;

  final userName = ''.obs;
  final avatarPath = RxnString();

  static const _kName = 'name';
  static const _kAvatarPath = 'avatarPath';

  final likedCount = 0.obs;
  final savedCount = 0.obs;
  final highlightedCount = 0.obs;

  final recentLikedTitles = <String>[].obs;
  final recentSavedTitles = <String>[].obs;
  final recentHighlightTexts = <String>[].obs;

  final mostReadTitle = ''.obs;
  final favoriteQuote = ''.obs;
  final notifEnabled = false.obs;
  final notifHour = 13.obs;
  final notifMinute = 0.obs;

  @override
  void onInit() {
    super.onInit();
    profileBox = Hive.box('profile_box');

    userName.value =
        (profileBox.get(_kName) as String?)?.trim().isNotEmpty == true
        ? (profileBox.get(_kName) as String).trim()
        : '';

    avatarPath.value = (profileBox.get(_kAvatarPath) as String?)?.trim();

    likedBox = Hive.box<LikedItem>(UserActionsController.likedBoxName);
    savedBox = Hive.box<SavedItem>(UserActionsController.savedBoxName);
    highlightBox = Hive.box<HighlightItem>(
      UserActionsController.highlightBoxName,
    );

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

  Future<void> removeAvatar() async {
    avatarPath.value = null;
    await profileBox.delete(_kAvatarPath);
  }

  @override
  void onClose() {
    likedBox.listenable().removeListener(_loadData);
    savedBox.listenable().removeListener(_loadData);
    highlightBox.listenable().removeListener(_loadData);
    super.onClose();
  }

  void _loadData() {
    final likedItems = likedBox.values.toList().reversed.toList();
    final savedItems = savedBox.values.toList().reversed.toList();
    final highlightItems = highlightBox.values.toList().reversed.toList();

    likedCount.value = likedItems.length;
    savedCount.value = savedItems.length;
    highlightedCount.value = highlightItems.length;

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
        : 'هنوز هایلایتی ثبت نشده است';
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
