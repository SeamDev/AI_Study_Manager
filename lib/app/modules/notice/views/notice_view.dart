import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/notice_controller.dart';

class NoticeView extends GetView<NoticeController> {
  const NoticeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NoticeView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'NoticeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
