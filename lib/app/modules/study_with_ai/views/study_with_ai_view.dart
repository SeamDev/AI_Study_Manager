import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/study_with_ai_controller.dart';

class StudyWithAiView extends GetView<StudyWithAiController> {
  const StudyWithAiView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StudyWithAiView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'StudyWithAiView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
