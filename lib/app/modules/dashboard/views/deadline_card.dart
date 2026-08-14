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
              Text(
                'View All',
                style: const TextStyle(color: AppColors.cyan, fontSize: 12),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Column(
            children: [
              _deadline(
                title: 'Database Systems Midterm',
                code: 'CSE 204',
                priority: 'High',
                date: 'May 18, 2025',
                remaining: 'In 5 days',
                color: AppColors.red,
              ),
              _deadline(
                title: 'Discrete Math Midterm',
                code: 'MATH 203',
                priority: 'Medium',
                date: 'May 19, 2025',
                remaining: 'In 8 days',
                color: AppColors.yellow,
              ),
              _deadline(
                title: 'Operating Systems Assignment',
                code: 'CSE 205',
                priority: 'Medium',
                date: 'May 23, 2025',
                remaining: 'In 6 days',
                color: AppColors.blue,
              ),
              _deadline(
                title: 'Computer Networks Quiz',
                code: 'CSE 206',
                priority: 'Low',
                date: 'May 23, 2025',
                remaining: 'In 10 days',
                color: AppColors.cyan,
              ),
              const SizedBox(height: 8),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '✦ Click the circle when you finish the work to remove it from the list.',
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
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

        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.secondaryText),
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
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                code,
                style: const TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 10,
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
