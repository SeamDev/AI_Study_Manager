import 'package:ai_study_manager/app/modules/academic_routine/views/academic_routine_view.dart';
import 'package:ai_study_manager/app/modules/assessments/views/assessments_view.dart';
import 'package:ai_study_manager/app/modules/bus_schedule/views/bus_schedule_view.dart';
import 'package:ai_study_manager/app/modules/dashboard/views/dashboard_view.dart';
import 'package:ai_study_manager/app/modules/exam/views/exam_view.dart';
import 'package:ai_study_manager/app/modules/notice/views/notice_view.dart';
import 'package:ai_study_manager/app/modules/sidebar/controllers/sidebar_controller.dart';
import 'package:ai_study_manager/app/modules/study_with_ai/views/study_with_ai_view.dart';
import 'package:ai_study_manager/app/modules/todo/views/todo_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppColors {
  static const background = Color(0xFF020B1A);
  static const sidebar = Color(0xFF020A17);
  static const card = Color(0xFF061426);
  static const card2 = Color(0xFF07182C);
  static const border = Color(0xFF102C49);

  static const blue = Color(0xFF079BFF);
  static const cyan = Color(0xFF00E5FF);
  static const purple = Color(0xFF8A2BE2);
  static const green = Color(0xFF32E875);
  static const orange = Color(0xFFFF9D00);
  static const red = Color(0xFFFF2635);
  static const yellow = Color(0xFFFFC400);

  static const text = Color(0xFFF3F7FF);
  static const secondaryText = Color(0xFFAEB9C8);
}

class SidebarView extends GetView<SidebarController> {
  const SidebarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 305,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.sidebar,
                border: Border(
                  right: BorderSide(color: Color(0xFF10253E), width: 1),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Logo
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.purple,
                              width: 2,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x552B00FF),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.rocket_launch_rounded,
                            size: 34,
                            color: AppColors.blue,
                          ),
                        ),

                        const SizedBox(width: 12),

                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI Study Manager',
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Smart Today, Better Tomorrow',
                              style: TextStyle(
                                color: AppColors.secondaryText,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: controller.menuItems.length,
                      itemBuilder: (context, index) {
                        return Obx(() {
                          final selected =
                              controller.selectedIndex.value == index;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: GestureDetector(
                              onTap: () {
                                controller.changePage(index);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: 65,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: selected
                                      ? const Color(0xFF06264B)
                                      : Colors.transparent,
                                  border: selected
                                      ? Border.all(
                                          color: const Color(0xFF0878D7),
                                        )
                                      : null,
                                  boxShadow: selected
                                      ? const [
                                          BoxShadow(
                                            color: Color(0x330078FF),
                                            blurRadius: 15,
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: controller.menuColors[index]
                                            .withValues(alpha: .95),
                                      ),
                                      child: Icon(
                                        controller.menuIcons[index],
                                        color: Colors.white,
                                        size: 27,
                                      ),
                                    ),

                                    const SizedBox(width: 16),

                                    Expanded(
                                      child: Text(
                                        controller.menuItems[index],
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: selected
                                              ? Colors.white
                                              : const Color(0xFFE8EDF5),
                                          fontWeight: selected
                                              ? FontWeight.w500
                                              : FontWeight.w400,
                                        ),
                                      ),
                                    ),

                                    if (index == 1)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 9,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF5A00FF),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: const Text(
                                          'NEW',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                      },
                    ),
                  ),

                  // User card
                  Obx(() {
                    if (controller.isLoading.value) {
                      return Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.card2,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const SizedBox(
                          height: 52,
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      );
                    }

                    return Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.card2,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.cyan),
                            ),
                            child: Center(
                              child: Text(
                                controller.initials.value,
                                style: const TextStyle(
                                  color: AppColors.cyan,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.fullName.value,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  controller.email.value,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppColors.secondaryText,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          IconButton(
                            onPressed: controller.logout,
                            icon: const Icon(
                              Icons.logout,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF030D1D), Color(0xFF020A18)],
                ),
              ),
              child: SafeArea(
                child: Obx(() {
                  switch (controller.selectedIndex.value) {
                    case 0:
                      return const DashboardView();
                    case 1:
                      return const StudyWithAiView();
                    case 2:
                      return const NoticeView();
                    case 3:
                      return const AcademicRoutineView();
                    case 4:
                      return const AssessmentsView();
                    case 5:
                      return const TodoView();
                    case 6:
                      return const ExamView();
                    case 7:
                      return const BusScheduleView();
                    default:
                      return const DashboardView();
                  }
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
