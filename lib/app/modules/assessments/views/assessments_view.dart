import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/assessments_controller.dart';

class AssessmentsView extends GetView<AssessmentsController> {
  const AssessmentsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AssessmentsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AssessmentsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
