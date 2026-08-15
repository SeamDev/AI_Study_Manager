import 'package:ai_study_manager/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../utils/app_color.dart';

class DeadlineCard extends GetView<DashboardController> {
  const DeadlineCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Upcoming Deadlines',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Get.dialog(const DeadlineViewAll(), barrierDismissible: true);
                },
                child: Text(
                  'View All',
                  style: const TextStyle(color: AppColors.cyan, fontSize: 12),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          Obx(() {
            final incompleteDeadlines = controller.deadlines
                .where((deadline) => deadline['isComplete'] != true)
                .take(5)
                .toList();

            if (incompleteDeadlines.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Center(
                  child: Text(
                    'No upcoming deadlines',
                    style: TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: incompleteDeadlines.length,
              itemBuilder: (context, index) {
                final deadline = incompleteDeadlines[index];

                Color color;

                switch (deadline['priority']) {
                  case 'High':
                    color = AppColors.red;
                    break;
                  case 'Medium':
                    color = AppColors.yellow;
                    break;
                  case 'Low':
                    color = AppColors.blue;
                    break;
                  default:
                    color = AppColors.cyan;
                }

                return _deadline(
                  title: deadline['title'] ?? "",
                  code: deadline['code'] ?? "",
                  priority: deadline['priority'] ?? "",
                  date: deadline['date'] ?? "",
                  remaining: deadline['remaining'] ?? "",
                  color: color,
                  isComplete: deadline['isComplete'] ?? false,
                  onTap: () => controller.completeDeadline(index),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}

Widget _deadline({
  required String title,
  required String code,
  required String priority,
  required String date,
  required String remaining,
  required Color color,
  required bool isComplete,
  required VoidCallback onTap,
}) {
  return Container(
    height: 65,
    margin: const EdgeInsets.only(bottom: 3),
    decoration: BoxDecoration(
      border: Border(left: BorderSide(color: color, width: 2)),
    ),
    child: Row(
      children: [
        const SizedBox(width: 12),

        if (!isComplete)
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.secondaryText),
              ),
            ),
          ),

        const SizedBox(width: 12),

        Icon(Icons.calendar_month_rounded, color: color, size: 23),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  decoration: isComplete
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                code,
                style: TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 10,
                  decoration: isComplete
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: color.withOpacity(.12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(priority, style: TextStyle(color: color, fontSize: 10)),
        ),

        const SizedBox(width: 12),

        SizedBox(
          width: 78,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isComplete)
                Text(remaining, style: TextStyle(color: color, fontSize: 11)),
              Text(
                date,
                style: const TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),
      ],
    ),
  );
}

class DeadlineViewAll extends GetView<DashboardController> {
  const DeadlineViewAll({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(30),
      child: Container(
        width: 700,
        constraints: const BoxConstraints(maxHeight: 700),
        padding: const EdgeInsets.all(24),
        child: Obx(() {
          final pending = controller.deadlines
              .where((deadline) => deadline['isComplete'] != true)
              .toList();

          final completed = controller.deadlines
              .where((deadline) => deadline['isComplete'] == true)
              .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'All Deadlines',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView(
                  children: [
                    // ================= PENDING =================
                    const Text(
                      'Pending',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    if (pending.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Center(child: Text('No pending deadlines')),
                      )
                    else
                      ...pending.map((deadline) {
                        return _deadlineItem(deadline, context);
                      }),

                    const SizedBox(height: 30),

                    // ================= COMPLETED =================
                    const Text(
                      'Completed',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    if (completed.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Center(child: Text('No completed deadlines')),
                      )
                    else
                      ...completed.map((deadline) {
                        return _deadlineItem(deadline, context);
                      }),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _deadlineItem(Map<String, dynamic> deadline, BuildContext context) {
    Color color;

    switch (deadline['priority']) {
      case 'High':
        color = AppColors.red;
        break;
      case 'Medium':
        color = AppColors.yellow;
        break;
      case 'Low':
        color = AppColors.blue;
        break;
      default:
        color = AppColors.cyan;
    }

    final index = controller.deadlines.indexOf(deadline);

    return _deadline(
      title: deadline['title'] ?? '',
      code: deadline['code'] ?? '',
      priority: deadline['priority'] ?? '',
      date: deadline['date'] ?? '',
      remaining: deadline['remaining'] ?? '',
      color: color,
      isComplete: deadline['isComplete'] ?? false,
      onTap: () {
        controller.completeDeadline(index);
      },
    );
  }
}
