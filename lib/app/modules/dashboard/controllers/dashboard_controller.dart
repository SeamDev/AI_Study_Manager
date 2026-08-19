import 'package:ai_study_manager/app/modules/academic_routine/controllers/academic_routine_controller.dart';
import 'package:ai_study_manager/app/modules/study_with_ai/controllers/study_with_ai_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;
  final academicController = Get.find<AcademicRoutineController>();
  // ----------------------------------------------------------
  // LOADING
  // ----------------------------------------------------------

  final isLoading = false.obs;

  // ----------------------------------------------------------
  // USER INFO
  // ----------------------------------------------------------

  final fullName = ''.obs;
  final studentId = ''.obs;
  final semester = ''.obs;
  final section = ''.obs;
  final email = ''.obs;
  final initials = ''.obs;

  // ----------------------------------------------------------
  // DASHBOARD DATA
  // ----------------------------------------------------------


  final homeworkDue = 0.obs;
  final examsUpcoming = 0.obs;

  final RxList<Map<String, dynamic>> deadlines = <Map<String, dynamic>>[].obs;

  TextEditingController aiTextController = TextEditingController();

  final StudyWithAiController studyWithAiController = Get.find<StudyWithAiController>();

  @override
  void onInit() {
    super.onInit();

    loadDashboard();
  }

  // ----------------------------------------------------------
  // LOAD DASHBOARD
  // ----------------------------------------------------------

  Future<void> loadDashboard() async {
    try {
      isLoading.value = true;
      await loadUserInfo();

      // Later you can load these from Supabase
      await loadHomework();
      await loadExams();

      await upcomingDeadline();

      // deadline
    } catch (e) {
      debugPrint('Dashboard error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ----------------------------------------------------------
  // USER INFO
  // ----------------------------------------------------------

  Future<void> loadUserInfo() async {
    try {
      final user = _supabase.auth.currentUser;

      if (user == null) {
        return;
      }

      final metadata = user.userMetadata ?? {};

      fullName.value = metadata['full_name']?.toString() ?? '';

      studentId.value = metadata['student_id']?.toString() ?? '';

      semester.value = metadata['semester']?.toString() ?? '';

      section.value = metadata['section']?.toString() ?? '';

      email.value = user.email ?? '';

      initials.value = _getInitials(fullName.value);
    } catch (e) {
      debugPrint('User info error: $e');
    }
  }


  // ----------------------------------------------------------
  // HOMEWORK
  // ----------------------------------------------------------

  Future<void> loadHomework() async {
    try {
      homeworkDue.value = 4;
    } catch (e) {
      debugPrint('Homework error: $e');
    }
  }

  // ----------------------------------------------------------
  // EXAMS
  // ----------------------------------------------------------

  Future<void> loadExams() async {
    try {
      examsUpcoming.value = 2;
    } catch (e) {
      debugPrint('Exams error: $e');
    }
  }

  Future<void> todaySchedule() async {
    try {
      examsUpcoming.value = 2;
    } catch (e) {
      debugPrint('Exams error: $e');
    }
  }

  // Deadline
  Future<void> upcomingDeadline() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      deadlines.clear();
      return;
    }

    try {
      final today = DateTime.now().toIso8601String().split('T')[0];

      // Get upcoming public deadlines
      final deadlinesData = await _supabase
          .from('deadlines')
          .select()
          .eq('semester', semester)
          .eq('section', section)
          .gte('due_date', today)
          .order('due_date', ascending: true);

      // Get only this user's completed deadlines
      final completedData = await _supabase
          .from('user_deadline_status')
          .select('deadline_id')
          .eq('user_id', user.id)
          .eq('is_complete', true);

      final completedIds = completedData
          .map<int>((item) => item['deadline_id'] as int)
          .toSet();

      deadlines.assignAll(
        deadlinesData.map<Map<String, dynamic>>((deadline) {
          return {
            ...deadline,
            'isComplete': completedIds.contains(deadline['id']),
          };
        }).toList(),
      );
    } catch (e) {
      debugPrint('Error getting upcoming deadlines: $e');
      deadlines.clear();
    }
  }

  Future<void> completeDeadline(int index) async {
    final deadline = deadlines[index];
    final deadlineId = deadline['id'];

    // Optimistic UI update
    deadline['isComplete'] = true;
    deadlines.refresh();

    try {
      final user = _supabase.auth.currentUser;

      if (user == null) {
        throw Exception('User not logged in');
      }

      await _supabase.from('user_deadline_status').upsert({
        'user_id': user.id,
        'deadline_id': deadlineId,
        'is_complete': true,
      });
    } catch (e) {
      // Restore if database update fails
      deadline['isComplete'] = false;
      deadlines.refresh();
      Get.snackbar('Error', 'Could not save deadline completion.');
    }
  }

  // ----------------------------------------------------------
  // INITIALS
  // ----------------------------------------------------------

  String _getInitials(String name) {
    if (name.trim().isEmpty) {
      return '';
    }

    final parts = name.trim().split(RegExp(r'\s+'));

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  // ----------------------------------------------------------
  // REFRESH
  // ----------------------------------------------------------

  Future<void> refreshDashboard() async {
    await loadDashboard();
  }
}
