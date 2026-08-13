import 'package:get/get.dart';

import '../modules/academic_routine/bindings/academic_routine_binding.dart';
import '../modules/academic_routine/views/academic_routine_view.dart';
import '../modules/assessments/bindings/assessments_binding.dart';
import '../modules/assessments/views/assessments_view.dart';
import '../modules/bus_schedule/bindings/bus_schedule_binding.dart';
import '../modules/bus_schedule/views/bus_schedule_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/exam/bindings/exam_binding.dart';
import '../modules/exam/views/exam_view.dart';
import '../modules/notice/bindings/notice_binding.dart';
import '../modules/notice/views/notice_view.dart';
import '../modules/sidebar/bindings/sidebar_binding.dart';
import '../modules/sidebar/views/sidebar_view.dart';
import '../modules/study_with_ai/bindings/study_with_ai_binding.dart';
import '../modules/study_with_ai/views/study_with_ai_view.dart';
import '../modules/todo/bindings/todo_binding.dart';
import '../modules/todo/views/todo_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SIDEBAR;

  static final routes = [
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.STUDY_WITH_AI,
      page: () => const StudyWithAiView(),
      binding: StudyWithAiBinding(),
    ),
    GetPage(
      name: _Paths.SIDEBAR,
      page: () => const SidebarView(),
      binding: SidebarBinding(),
    ),
    GetPage(
      name: _Paths.NOTICE,
      page: () => const NoticeView(),
      binding: NoticeBinding(),
    ),
    GetPage(
      name: _Paths.ACADEMIC_ROUTINE,
      page: () => const AcademicRoutineView(),
      binding: AcademicRoutineBinding(),
    ),
    GetPage(
      name: _Paths.ASSESSMENTS,
      page: () => const AssessmentsView(),
      binding: AssessmentsBinding(),
    ),
    GetPage(
      name: _Paths.TODO,
      page: () => const TodoView(),
      binding: TodoBinding(),
    ),
    GetPage(
      name: _Paths.EXAM,
      page: () => const ExamView(),
      binding: ExamBinding(),
    ),
    GetPage(
      name: _Paths.BUS_SCHEDULE,
      page: () => const BusScheduleView(),
      binding: BusScheduleBinding(),
    ),
  ];
}
