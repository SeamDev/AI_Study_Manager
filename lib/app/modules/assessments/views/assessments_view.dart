import 'package:ai_study_manager/app/modules/assessments/views/assesment_summery.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/assessments_controller.dart';

class AppColors {
  static const background = Color(0xff020817);
  static const card = Color(0xff071426);
  static const card2 = Color(0xff0B1C33);
  static const border = Color(0xff17304F);

  static const text = Color(0xffF5F8FF);
  static const secondary = Color(0xffAEB9C8);

  static const blue = Color(0xff079BFF);
  static const cyan = Color(0xff00E5FF);
  static const green = Color(0xff32E875);
  static const orange = Color(0xffFFB000);
  static const red = Color(0xffFF2635);
}

class AssessmentsView extends GetView<AssessmentsController> {
  const AssessmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            AssesmentSummery(),

            const SizedBox(height: 16),

            _toolbar(),

            const SizedBox(height: 10),

            _table(),
          ],
        ),
      ),
    );
  }

  Widget _toolbar() {
    return Obx(() {
      return Row(
        children: [
          _filter(
            "All",
            AppColors.cyan,
            isActive: controller.selectedFilter.value == "All",
          ),

          _filter(
            "Pending",
            AppColors.orange,
            isActive: controller.selectedFilter.value == "Pending",
          ),

          _filter(
            "Completed",
            AppColors.green,
            isActive: controller.selectedFilter.value == "Completed",
          ),

          _filter(
            "Overdue",
            AppColors.red,
            isActive: controller.selectedFilter.value == "Overdue",
          ),
        ],
      );
    });
  }

  Widget _filter(String text, Color color, {bool isActive = false}) {
    return GestureDetector(
      onTap: () => controller.changeFilter(text),
      child: Container(
        margin: const EdgeInsets.only(right: 10),

        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),

        decoration: BoxDecoration(
          color: isActive ? color.withValues(alpha: 0.8) : AppColors.card,

          borderRadius: BorderRadius.circular(6),

          border: Border.all(color: color.withValues(alpha: .5)),
        ),

        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.white : color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _table() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(color: AppColors.border),
      ),

      child: Obx(() {
        return DataTable(
          headingRowColor: WidgetStateProperty.all(AppColors.card2),
          columns: [
            const DataColumn(
              label: Text(
                "Assignment Title",
                style: TextStyle(color: AppColors.secondary),
              ),
            ),

            const DataColumn(
              label: Text(
                "Course",
                style: TextStyle(color: AppColors.secondary),
              ),
            ),

            const DataColumn(
              label: Text(
                "Due Date",
                style: TextStyle(color: AppColors.secondary),
              ),
            ),

            const DataColumn(
              label: Text(
                "Status",
                style: TextStyle(color: AppColors.secondary),
              ),
            ),
          ],

          rows: controller.getFilteredAssessments().map((assessment) {
            return DataRow(
              cells: [
                DataCell(
                  Text(
                    assessment['title'] ?? '',
                    style: const TextStyle(color: AppColors.text),
                  ),
                ),

                DataCell(
                  Text(
                    '${assessment['course_code']} - '
                    '${assessment['course_name']}',
                    style: const TextStyle(color: AppColors.secondary),
                  ),
                ),

                DataCell(
                  Text(
                    controller.formatDueDate(assessment['due_date']),
                    style: const TextStyle(color: AppColors.text),
                  ),
                ),

                DataCell(
                  _status(
                    assessment['status'],
                    assessment['id'].toString(),
                    assessment['url'] ?? 'https://toolkit.nav.bd',
                  ),
                ),
              ],
            );
          }).toList(),
        );
      }),
    );
  }

  Widget _status(String value, String id, String url) {
    Color getColor(String status) {
      switch (status) {
        case "Completed":
          return AppColors.green;

        case "Overdue":
          return AppColors.red;

        default:
          return AppColors.orange;
      }
    }

    final color = getColor(value);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Status box
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Done button
        if (value == "Pending" || value == "Overdue") ...[
          const SizedBox(width: 8),

          InkWell(
            onTap: () {
              controller.completeAssessment(id);
            },
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.green.withValues(alpha: .10),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppColors.green.withValues(alpha: .6),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check, color: AppColors.green, size: 15),
                  SizedBox(width: 4),
                  Text(
                    "Done",
                    style: TextStyle(
                      color: AppColors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(width: 8),

        InkWell(
          onTap: () {
            controller.openUrl(url);
          },
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: .10),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.withValues(alpha: .6)),
            ),
            child: Text(
              "Open",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
