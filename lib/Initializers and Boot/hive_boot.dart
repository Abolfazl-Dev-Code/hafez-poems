import 'package:hafez_poems/appbarHomeScreenUnit/profileUnit/profile_controller.dart';
import 'package:hafez_poems/models/ghasayed_model.dart';
import 'package:hafez_poems/models/ghazal_model.dart';
import 'package:hafez_poems/models/ghataat_model.dart';
import 'package:hafez_poems/models/highlight_item.dart';
import 'package:hafez_poems/models/liked_item.dart';
import 'package:hafez_poems/models/montasab_model.dart';
import 'package:hafez_poems/models/other_poem_model.dart';
import 'package:hafez_poems/models/robaeyat_model.dart';
import 'package:hafez_poems/models/saved_item.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/bottomNavBar/user_actions_saver.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveBoot {
  static Future<Box<T>> openBoxSafely<T>(String name) async {
    try {
      return await Hive.openBox<T>(name);
    } catch (e) {
      if (Hive.isBoxOpen(name)) await Hive.box(name).close();
      await Hive.deleteBoxFromDisk(name);
      return await Hive.openBox<T>(name);
    }
  }

  static Future<void> init() async {
    // 1. اول Hive را آماده کن
    await Hive.initFlutter();

    // 2. Adapterها را register کن
    Hive.registerAdapter(LikedItemAdapter());
    Hive.registerAdapter(SavedItemAdapter());
    Hive.registerAdapter(HighlightItemAdapter());
    Hive.registerAdapter(GhazalAdapter());
    Hive.registerAdapter(GhataatModelAdapter());
    Hive.registerAdapter(GhasayedModelAdapter());
    Hive.registerAdapter(RobaeyatModelAdapter());
    Hive.registerAdapter(MontasabModelAdapter());
    Hive.registerAdapter(OtherPoemModelAdapter());

    Hive.openBox(ProfileController.readBoxName);

    // 3. همه Boxها را قبل از ساخت کنترلرها باز کن
    await Future.wait<Box>([
      openBoxSafely<LikedItem>(UserActionsSaver.likedBoxName),
      openBoxSafely<SavedItem>(UserActionsSaver.savedBoxName),
      openBoxSafely<HighlightItem>(UserActionsSaver.highlightBoxName),

      // فقط یکی برای پروفایل نگه دار
      openBoxSafely<dynamic>('profile_box'),
      openBoxSafely<Ghazal>('ghazals_box'),
      openBoxSafely<GhataatModel>('ghataat_box'),
      openBoxSafely<GhasayedModel>('qasaid_box'),
      openBoxSafely<RobaeyatModel>('robaeyat_box'),
      openBoxSafely<MontasabModel>('montasab_box'),
      openBoxSafely<OtherPoemModel>('other_poems_box'),
    ]);
  }
}
