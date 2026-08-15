import 'package:ai_study_manager/app/modules/notice/views/notice_section.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/notice_controller.dart';

class NoticeView extends GetView<NoticeController> {
  const NoticeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final controller = Get.find<NoticeController>();

        return Container(
          margin: EdgeInsets.all(12),
          child: ListView(
            children: [
              if (controller.today.isNotEmpty)
                NoticeSection(title: "Today", notices: controller.today),
          
              if (controller.yesterday.isNotEmpty)
                NoticeSection(title: "Yesterday", notices: controller.yesterday),
          
              if (controller.past.isNotEmpty)
                NoticeSection(title: "Past", notices: controller.past),
            ],
          ),
        );
      }),
    );
  }
}
