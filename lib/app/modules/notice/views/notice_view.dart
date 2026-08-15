import 'package:ai_study_manager/app/models/notice_model.dart';
import 'package:ai_study_manager/app/modules/notice/views/notice_section.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../utils/app_color.dart';
import '../controllers/notice_controller.dart';

class NoticeView extends GetView<NoticeController> {
  const NoticeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final controller = Get.find<NoticeController>();

        return ListView(
          children: [
            if (controller.today.isNotEmpty)
              NoticeSection(title: "Today", notices: controller.today),

            if (controller.yesterday.isNotEmpty)
              NoticeSection(title: "Yesterday", notices: controller.yesterday),

            if (controller.past.isNotEmpty)
              NoticeSection(title: "Past", notices: controller.past),
          ],
        );
      }),
    );
  }
}

Widget noticeCard(NoticeModel notice) {
  return Container(
    padding: const EdgeInsets.all(15),

    margin: const EdgeInsets.only(bottom: 12),

    decoration: BoxDecoration(
      color: AppColors.card,

      borderRadius: BorderRadius.circular(12),

      border: Border.all(color: AppColors.border),
    ),

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          notice.title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        Text(
          notice.description,
          style: const TextStyle(color: AppColors.secondaryText),
        ),

        if (notice.imageUrls.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: notice.imageUrls.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.5,
              ),
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    notice.imageUrls[index],
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) {
                      return Container(
                        color: AppColors.background,
                        child: const Icon(
                          Icons.broken_image_outlined,
                          color: AppColors.secondaryText,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        if (notice.links.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Text(
                'Related Links',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),

              ...notice.links.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      // launchUrl(Uri.parse(item.link));
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.link_rounded, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              item.label,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Icon(Icons.open_in_new_rounded, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    ),
  );
}
