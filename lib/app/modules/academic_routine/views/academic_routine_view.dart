import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_color.dart';
import '../../../models/routine_schedule_model.dart';
import '../controllers/academic_routine_controller.dart';

class AcademicRoutineView extends GetView<AcademicRoutineController> {
  const AcademicRoutineView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: Padding(
        padding: const EdgeInsets.all(25),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Academic Routine",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            const Text(
              "Your semester class schedule",
              style: TextStyle(color: AppColors.secondaryText),
            ),

            const SizedBox(height: 25),

            // DAY SELECTOR
            Obx(
              () => SizedBox(
                height: 45,

                child: ListView.separated(
                  scrollDirection: Axis.horizontal,

                  itemCount: controller.days.length,

                  separatorBuilder: (_, _) => const SizedBox(width: 10),

                  itemBuilder: (context, index) {
                    final day = controller.days[index];

                    final selected = controller.selectedDay.value == day;
                    return InkWell(
                      onTap: () {
                        controller.changeDay(day);
                      },

                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),

                        alignment: Alignment.center,

                        decoration: BoxDecoration(
                          color: selected ? AppColors.cyan : AppColors.card,

                          borderRadius: BorderRadius.circular(12),

                          border: Border.all(color: AppColors.border),
                        ),

                        child: Text(
                          day,

                          style: TextStyle(
                            color: selected ? Colors.black : Colors.white,

                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: Obx(() {
                if (controller.schedules.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 55,
                          color: AppColors.secondaryText,
                        ),

                        SizedBox(height: 15),

                        Text(
                          "No class today",
                          style: TextStyle(
                            color: AppColors.secondaryText,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: controller.schedules.length,

                  itemBuilder: (context, index) {
                    final schedule = controller.schedules[index];

                    return ScheduleTile(
                      schedule: schedule,

                      active: controller.isActive(schedule),

                      completed: controller.isEnded(schedule),

                      status: controller.getTimeStatus(schedule),

                      isToday: controller.selectedDay.value == controller.today,

                      last: index == controller.schedules.length - 1,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class ScheduleTile extends StatelessWidget {
  final ScheduleModel schedule;
  final bool active;
  final bool last;
  final bool isToday;
  final String status;
  final bool completed;

  const ScheduleTile({
    super.key,
    required this.schedule,
    required this.active,
    required this.last,
    required this.isToday,
    required this.status,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // TIME SECTION
          SizedBox(
            width: 120,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,

              children: [
                Text(
                  schedule.startTime,
                  style: const TextStyle(
                    color: AppColors.cyan,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  schedule.endTime,
                  style: const TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 12,
                  ),
                ),

                if (isToday)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),

                    child: StatusChip(status: status),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 15),

          // TIMELINE
          SizedBox(
            width: 35,
            child: Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                if (!last)
                  Positioned(
                    top: 25,
                    bottom: -150,
                    child: Container(
                      width: 3,
                      color: completed || active
                          ? Colors.green
                          : const Color(0xff17405B),
                    ),
                  ),

                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: active ? 22 : 14,
                  height: active ? 22 : 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: active ? Colors.green : AppColors.background,
                    border: Border.all(
                      color: active ? Colors.green : AppColors.cyan,
                      width: active ? 5 : 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),

          // CLASS CARD
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 15),

              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: AppColors.card,

                borderRadius: BorderRadius.circular(18),

                border: Border.all(
                  color: active ? Colors.green : AppColors.border,
                ),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Text(
                        schedule.title,

                        style: const TextStyle(
                          fontSize: 20,

                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,

                          vertical: 6,
                        ),

                        decoration: BoxDecoration(
                          color: const Color(0xff06284A),

                          borderRadius: BorderRadius.circular(10),
                        ),

                        child: Text(
                          "Room ${schedule.room}",

                          style: const TextStyle(color: AppColors.cyan),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    schedule.subtitle,

                    style: const TextStyle(color: AppColors.secondaryText),
                  ),

                  const Spacer(),

                  Row(
                    children: [
                      Text(
                        "Teacher : ${schedule.teacher}",

                        style: const TextStyle(color: AppColors.secondaryText),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: () {},
                        label: Text("Copy Number"),
                        icon: Icon(Icons.copy),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  final String status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final ended = status == "Ended";

    final running = status == "Running";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),

      decoration: BoxDecoration(
        color: ended
            ? Colors.red.withOpacity(.15)
            : running
            ? Colors.green.withOpacity(.15)
            : AppColors.cyan.withOpacity(.15),

        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(
        status,

        style: TextStyle(
          fontSize: 12,

          color: ended
              ? Colors.red
              : running
              ? Colors.green
              : AppColors.cyan,

          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget timelineDot({required bool isActive, required bool isLast}) {
    return SizedBox(
      width: 40,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // connector line
          if (!isLast)
            Positioned(
              top: 18,
              bottom: -30,
              child: Container(
                width: 2,
                color: isActive ? Colors.green : const Color(0xff17405B),
              ),
            ),

          // dot
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: isActive ? 22 : 14,
            height: isActive ? 22 : 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? Colors.green : const Color(0xff061425),
              border: Border.all(
                color: isActive ? Colors.green : Colors.cyan,
                width: isActive ? 4 : 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
