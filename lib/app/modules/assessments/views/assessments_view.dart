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
    return Row(
      children: [
        _filter("All", AppColors.cyan),

        _filter("Pending", AppColors.orange),

        _filter("Completed", AppColors.green),

        _filter("Overdue", AppColors.red),
      ],
    );
  }

  Widget _filter(String text, Color color, {bool isActive = false}) {
    return Container(
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
    );
  }

  Widget _table() {
    final data = [
      [
        "Database Normalization",
        "CSE 204 - DB Systems",
        "May 18, 2025",
        "Pending",
      ],

      [
        "Binary Search Tree Implementation",
        "CSE 201 - Data Structures",
        "May 19, 2025",
        "Pending",
      ],

      [
        "Operating System Process Scheduling",
        "CSE 205 - Operating Systems",
        "May 16, 2025",
        "Overdue",
      ],

      [
        "SQL Query Practice Set",
        "CSE 204 - DB Systems",
        "May 11, 2025",
        "Completed",
      ],
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.card,

        //borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),

      child: DataTable(
        headingRowColor: WidgetStateProperty.all(AppColors.card2),
        //border: TableBorder.all(borderRadius: BorderRadius.circular(12)),

        columns: [
          const DataColumn(
            label: Text(
              "Assignment Title",
              style: TextStyle(color: AppColors.secondary),
            ),
          ),

          const DataColumn(
            label: Text("Course", style: TextStyle(color: AppColors.secondary)),
          ),

          const DataColumn(
            label: Text(
              "Due Date",
              style: TextStyle(color: AppColors.secondary),
            ),
          ),

          const DataColumn(
            label: Text("Status", style: TextStyle(color: AppColors.secondary)),
          ),
        ],

        rows: data.map((e) {
          return DataRow(

            cells: [
              DataCell(
                Text(e[0], style: const TextStyle(color: AppColors.text)),
              ),

              DataCell(
                Text(e[1], style: const TextStyle(color: AppColors.secondary)),
              ),

              DataCell(
                Text(e[2], style: const TextStyle(color: AppColors.text)),
              ),

              DataCell(_status(e[3])),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _status(String value) {
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: getColor(value).withValues(alpha: .12),

        borderRadius: BorderRadius.circular(6),

        border: Border.all(color: getColor(value)),
      ),

      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,

          dropdownColor: AppColors.card,

          icon: Icon(
            Icons.keyboard_arrow_down,
            color: getColor(value),
            size: 18,
          ),

          style: TextStyle(color: getColor(value), fontSize: 18,),

          items: ["Pending", "Completed", "Overdue"].map((status) {
            final color = getColor(status);

            return DropdownMenuItem<String>(
              value: status,

              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),

                child: Text(
                  status,
                  style: TextStyle(color: color, fontSize: 12),
                ),
              ),
            );
          }).toList(),

          onChanged: (newValue) {
            if (newValue != null) {
              // update controller/database here
              print("Changed: $newValue");
            }
          },
        ),
      ),
    );
  }
}
