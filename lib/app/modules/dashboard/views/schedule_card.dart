import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../utils/app_color.dart';
import '../controllers/dashboard_controller.dart';

class ScheduleCard extends GetView<DashboardController> {
  const ScheduleCard({super.key});
  @override
  Widget build(BuildContext context) {
    final schedules = [
      ['08:00 AM', 'Data Structures', 'CSE 201', 'Room 402', '1h 25m'],
      ['10:00 AM', 'Database Systems', 'CSE 204', 'Lab 1', '3h 25m'],
      ['01:00 PM', 'Discrete Mathematics', 'MATH 203', 'Room 305', '6h 25m'],
      ['03:00 PM', 'Operating Systems', 'CSE 205', 'Room 401', '8h 25m'],
      ['05:00 PM', 'Computer Networks', 'CSE 206', 'Room 404', '10h 25m'],
    ];
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
                "Today's Schedule",
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                'View Full',
                style: const TextStyle(color: AppColors.cyan, fontSize: 12),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Column(
            children: [
              for (int i = 0; i < schedules.length; i++)
                _scheduleItem(
                  time: schedules[i][0],
                  title: schedules[i][1],
                  code: schedules[i][2],
                  room: schedules[i][3],
                  starts: schedules[i][4],
                  last: i == schedules.length - 1,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _scheduleItem({
  required String time,
  required String title,
  required String code,
  required String room,
  required String starts,
  required bool last,
}) {
  return SizedBox(
    height: 65,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              time,
              style: const TextStyle(color: AppColors.cyan, fontSize: 13),
            ),
          ),
        ),

        SizedBox(
          width: 20,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              if (!last)
                Positioned(
                  top: 15,
                  bottom: 0,
                  child: Container(width: 1, color: const Color(0xFF17405B)),
                ),
              Container(
                margin: const EdgeInsets.only(top: 7),
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: AppColors.cyan,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 5),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFF07182B),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        code,
                        style: const TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF06284A),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    room,
                    style: const TextStyle(color: AppColors.cyan, fontSize: 10),
                  ),
                ),

                const SizedBox(width: 14),

                SizedBox(
                  width: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Starts in',
                        style: TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        starts,
                        style: const TextStyle(
                          color: AppColors.cyan,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
