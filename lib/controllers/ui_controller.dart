// lib/controllers/ui_controller.dart
import 'package:get/get.dart';

class UIController extends GetxController {
  // حالت اولیه بدون نمایش عکس (چشم خاموش)
  RxBool showImages = false.obs;

  void toggleImages() {
    showImages.value = !showImages.value;
  }
}
