import 'package:ai_study_manager/app/models/routine_schedule_model.dart';
import 'package:ai_study_manager/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_color.dart';
import '../controllers/dashboard_controller.dart';

class ScheduleCard extends GetView<DashboardController> {
  const ScheduleCard({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(minutes: 1)),
      builder: (context, asyncSnapshot) {
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Today's Schedule",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.ACADEMIC_ROUTINE);
                    },
                    child: Text(
                      'View All',
                      style: const TextStyle(
                        color: AppColors.cyan,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Obx(() {
                final schedules = controller.academicController.todaySchedules;
                return Column(
                  children: [
                    for (int i = 0; i < schedules.length; i++)
                      _scheduleItem(
                        time: schedules[i].startTime,
                        title: schedules[i].title,
                        code: schedules[i].subtitle,
                        room: schedules[i].room,
                        starts: getTimeStatus(schedules[i]),
                        last: i == schedules.length - 1,
                        isActive: controller.academicController.isActive(
                          schedules[i],
                        ),
                      ),
                  ],
                );
              }),
            ],
          ),
        );
      },
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
  required bool isActive,
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

        // Timeline
        SizedBox(
          width: 20,
          height: 65,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              // Connecting line
              if (!last)
                Positioned(
                  top: 13,
                  bottom: 0,
                  child: Container(width: 2, color: const Color(0xFF17405B)),
                ),

              // Dot
              Positioned(
                top: 7,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.green : AppColors.cyan,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        // Schedule content
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

String getTimeStatus(ScheduleModel schedule) {
  final now = DateTime.now();

  final start = _parseTime(schedule.startTime);
  final end = _parseTime(schedule.endTime);

  if (start == null || end == null) {
    return "";
  }

  // Class not started
  if (now.isBefore(start)) {
    final difference = start.difference(now);

    if (difference.inHours > 0) {
      return "Starts in "
          "${difference.inHours}h "
          "${difference.inMinutes % 60}m";
    } else {
      return "Starts in "
          "${difference.inMinutes} min";
    }
  }

  // Class finished
  if (now.isAfter(end)) {
    return "Ended";
  }

  // Currently running
  return "Running";
}

DateTime? _parseTime(String time) {
  try {
    final now = DateTime.now();

    /*
      Example:
      08:30 AM

      split:
      [
        08:30,
        AM
      ]
    */

    final parts = time.trim().split(" ");

    final hm = parts[0].split(":");

    int hour = int.parse(hm[0]);
    int minute = int.parse(hm[1]);

    final period = parts[1];

    if (period == "PM" && hour != 12) {
      hour += 12;
    }

    if (period == "AM" && hour == 12) {
      hour = 0;
    }

    return DateTime(now.year, now.month, now.day, hour, minute);
  } catch (e) {
    debugPrint("Time parse error: $e");

    return null;
  }
}
