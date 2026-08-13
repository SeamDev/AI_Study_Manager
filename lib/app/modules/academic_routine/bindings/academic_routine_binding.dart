import 'package:get/get.dart';

import '../controllers/academic_routine_controller.dart';

class AcademicRoutineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AcademicRoutineController>(
      () => AcademicRoutineController(),
    );
  }
}
