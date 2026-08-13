import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/academic_routine_controller.dart';

class AcademicRoutineView extends GetView<AcademicRoutineController> {
  const AcademicRoutineView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AcademicRoutineView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AcademicRoutineView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
