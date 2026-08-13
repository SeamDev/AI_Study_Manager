import 'package:get/get.dart';

import '../controllers/bus_schedule_controller.dart';

class BusScheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusScheduleController>(
      () => BusScheduleController(),
    );
  }
}
