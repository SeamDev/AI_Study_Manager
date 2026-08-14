import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

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

  final classesToday = 0.obs;
  final homeworkDue = 0.obs;
  final examsUpcoming = 0.obs;

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
      await loadClasses();
      await loadHomework();
      await loadExams();
    } catch (e) {
      print('Dashboard error: $e');
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

      fullName.value =
          metadata['full_name']?.toString() ?? '';

      studentId.value =
          metadata['student_id']?.toString() ?? '';

      semester.value =
          metadata['semester']?.toString() ?? '';

      section.value =
          metadata['section']?.toString() ?? '';

      email.value =
          user.email ?? '';

      initials.value =
          _getInitials(fullName.value);
    } catch (e) {
      print('User info error: $e');
    }
  }

  // ----------------------------------------------------------
  // CLASSES
  // ----------------------------------------------------------

  Future<void> loadClasses() async {
    try {
      // TODO:
      // Load today's classes from Supabase.

      classesToday.value = 3;
    } catch (e) {
      print('Classes error: $e');
    }
  }

  // ----------------------------------------------------------
  // HOMEWORK
  // ----------------------------------------------------------

  Future<void> loadHomework() async {
    try {
      // TODO:
      // Load homework from Supabase.

      homeworkDue.value = 4;
    } catch (e) {
      print('Homework error: $e');
    }
  }

  // ----------------------------------------------------------
  // EXAMS
  // ----------------------------------------------------------

  Future<void> loadExams() async {
    try {
      // TODO:
      // Load upcoming exams from Supabase.

      examsUpcoming.value = 2;
    } catch (e) {
      print('Exams error: $e');
    }
  }

  // ----------------------------------------------------------
  // INITIALS
  // ----------------------------------------------------------

  String _getInitials(String name) {
    if (name.trim().isEmpty) {
      return '';
    }

    final parts = name
        .trim()
        .split(RegExp(r'\s+'));

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