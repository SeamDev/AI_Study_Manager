import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';

class SummeryCard extends GetView<DashboardController> {
  const SummeryCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Obx(() {
            final schedules = controller.academicController.todaySchedules;

            final next = controller.academicController.nextClass;

            return _summaryCard(
              icon: Icons.menu_book_rounded,
              color: const Color(0xFF079BFF),

              title: 'Classes Today',

              number: schedules.length.toString(),

              subtitle: next != null ? 'Next: ${next.startTime}' : 'No class',

              labels: schedules.map((e) => e.title).toList(),
            );
          }),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _summaryCard(
            icon: Icons.assignment_rounded,
            color: Color(0xFFFF9D00),
            title: 'Homework Due',
            number: '4',
            subtitle: 'Next: Tomorrow',
            labels: ['DSA Assignment'],
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _summaryCard(
            icon: Icons.school_rounded,
            color: Color(0xFF8A2BE2),
            title: 'Exams Upcoming',
            number: '2',
            subtitle: 'Next: In 5d 8h',
            labels: ['Database Midterm'],
          ),
        ),
      ],
    );
  }

  Widget _summaryCard({
    required IconData icon,
    required Color color,
    required String title,
    required String number,
    required String subtitle,
    required List<String> labels,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 180),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF061426),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: const Color(0xFF102C49)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .25),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: color, size: 31),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),

                const SizedBox(height: 4),

                Text(
                  number,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                Text(subtitle, style: const TextStyle(fontSize: 12)),

                const SizedBox(height: 16),

                Wrap(
                  spacing: 6,
                  runSpacing: 5,
                  children: labels.map((label) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(color: color, fontSize: 11),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
