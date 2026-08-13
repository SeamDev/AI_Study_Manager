import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/bus_schedule_controller.dart';

class BusScheduleView extends GetView<BusScheduleController> {
  const BusScheduleView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BusScheduleView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BusScheduleView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
