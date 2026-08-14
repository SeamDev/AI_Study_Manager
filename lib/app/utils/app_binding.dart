import 'package:ai_study_manager/app/modules/academic_routine/bindings/academic_routine_binding.dart';
import 'package:ai_study_manager/app/modules/assessments/bindings/assessments_binding.dart';
import 'package:ai_study_manager/app/modules/auth/bindings/auth_binding.dart';
import 'package:ai_study_manager/app/modules/bus_schedule/bindings/bus_schedule_binding.dart';
import 'package:ai_study_manager/app/modules/dashboard/bindings/dashboard_binding.dart';
import 'package:ai_study_manager/app/modules/exam/bindings/exam_binding.dart';
import 'package:ai_study_manager/app/modules/notice/bindings/notice_binding.dart';
import 'package:ai_study_manager/app/modules/study_with_ai/bindings/study_with_ai_binding.dart';
import 'package:ai_study_manager/app/modules/todo/bindings/todo_binding.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    final bindings = <Bindings>[
      AuthBinding(),
      DashboardBinding(),
      StudyWithAiBinding(),
      NoticeBinding(),
      AcademicRoutineBinding(),
      AssessmentsBinding(),
      TodoBinding(),
      ExamBinding(),
      BusScheduleBinding(),
    ];

    for (final binding in bindings) {
      binding.dependencies();
    }
  }
}
