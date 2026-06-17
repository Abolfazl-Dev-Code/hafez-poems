import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class PoemReaderController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxBool isLiked = false.obs;
  final RxBool isSaved = false.obs;
  final RxList<int> highlightedLines = <int>[].obs;

  Future<void> loadPoem(String id, String type) async {
    isLoading.value = true;
    isLoading.value = false;
  }

  void toggleLike(String id) {}
  void toggleHighlight(int index) {}
}
