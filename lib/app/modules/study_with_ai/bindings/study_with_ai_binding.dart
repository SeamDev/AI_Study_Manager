import 'package:get/get.dart';

import '../controllers/study_with_ai_controller.dart';

class StudyWithAiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudyWithAiController>(
      () => StudyWithAiController(),
    );
  }
}
