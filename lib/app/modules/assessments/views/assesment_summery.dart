import 'package:ai_study_manager/app/modules/assessments/controllers/assessments_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/theme.dart';

class AssesmentSummery extends GetView<AssessmentsController> {
  const AssesmentSummery({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GridView.count(
        shrinkWrap: true,

        physics: const NeverScrollableScrollPhysics(),

        crossAxisCount: 4,

        crossAxisSpacing: 14,
        childAspectRatio: 3,

        children: [
          _summaryCard(
            Icons.assignment,
            "Total",
            controller.assessments.length.toString(),
            "All Assignments",
            AppColors.blue,
          ),

          _summaryCard(
            Icons.access_time,
            "Pending",
            controller.pendingCount.toString(),
            "Awaiting Submission",
            AppColors.orange,
          ),

          _summaryCard(
            Icons.check_circle,
            "Completed",
            controller.completedCount.toString(),
            "Submitted",
            AppColors.green,
          ),

          _summaryCard(
            Icons.error,
            "Overdue",
            controller.overdueCount.toString(),
            "Past Due Date",
            AppColors.red,
          ),
        ],
      );
    });
  }

  Widget _summaryCard(
    IconData icon,
    String title,
    String count,
    String subtitle,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppColors.card,

        borderRadius: BorderRadius.circular(10),

        border: Border.all(color: color.withValues(alpha: .5)),
      ),

      child: Row(
        children: [
          Container(
            width: 72,

            height: 72,

            decoration: BoxDecoration(
              color: color.withValues(alpha: .15),

              borderRadius: BorderRadius.circular(8),
            ),

            child: Icon(icon, color: color, size: 36),
          ),

          const SizedBox(width: 14),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(title, style: TextStyle(color: color, fontSize: 18)),

              Text(
                count,

                style: const TextStyle(
                  color: AppColors.text,

                  fontSize: 26,

                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(subtitle, style: const TextStyle(fontSize: 15)),
            ],
          ),
        ],
      ),
    );
  }
}
