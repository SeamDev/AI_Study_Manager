import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AssessmentsController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  final RxBool isLoading = false.obs;

  final RxString semester = ''.obs;
  final RxString section = ''.obs;

  final RxList<Map<String, dynamic>> assessments = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAssessments();
  }

  // ============================================================
  // LOAD ALL ASSESSMENTS
  // ============================================================

  Future<void> loadAssessments() async {
    try {
      isLoading.value = true;

      final user = _supabase.auth.currentUser;

      if (user == null) {
        assessments.clear();
        return;
      }

      // Get semester and section from Supabase Auth metadata
      final metadata = user.userMetadata ?? {};

      semester.value = metadata['semester']?.toString() ?? '';
      section.value = metadata['section']?.toString() ?? '';

      if (semester.value.isEmpty || section.value.isEmpty) {
        assessments.clear();
        return;
      }

      // ----------------------------------------------------------
      // Get public assessments
      // ----------------------------------------------------------

      final assessmentsData = await _supabase
          .from('assessments')
          .select()
          .eq('semester', semester.value)
          .eq('section', section.value)
          .order('due_date', ascending: true);

      // ----------------------------------------------------------
      // Get this user's completion status
      // ----------------------------------------------------------

      final statusData = await _supabase
          .from('user_assessment_status')
          .select('assessment_id, is_complete')
          .eq('user_id', user.id);

      // Create a set of completed assessment IDs
      final completedIds = statusData
          .where((item) => item['is_complete'] == true)
          .map((item) => item['assessment_id'])
          .toSet();

      // ----------------------------------------------------------
      // Combine assessment + user status
      // ----------------------------------------------------------

      final result = assessmentsData.map<Map<String, dynamic>>((item) {
        final id = item['id'];

        final dueDate = DateTime.parse(item['due_date'].toString()).toLocal();

        final isCompleted = completedIds.contains(id);

        String status;

        if (isCompleted) {
          status = 'Completed';
        } else if (dueDate.isBefore(DateTime.now())) {
          status = 'Overdue';
        } else {
          status = 'Pending';
        }

        return {
          ...Map<String, dynamic>.from(item),
          'status': status,
          'is_complete': isCompleted,
          'dueDateTime': dueDate,
        };
      }).toList();

      assessments.assignAll(result);
    } catch (e) {
      debugPrint('Error loading assessments: $e');

      assessments.clear();

      Get.snackbar(
        'Error',
        'Could not load assessments.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  final RxString selectedFilter = 'All'.obs;

  final Map<String, String> filterMap = {
    'All': 'All',
    'Completed': 'Completed',
    'Pending': 'Pending',
    'Overdue': 'Overdue',
  };

  List<Map<String, dynamic>> getFilteredAssessments() {
    final filter = filterMap[selectedFilter.value];

    if (filter == 'All') {
      return assessments.toList();
    }

    return assessments
        .where((assessment) => assessment['status'] == filter)
        .toList();
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
  }
  // ============================================================
  // MARK AS COMPLETED
  // ============================================================

  Future<void> completeAssessment(String assessmentId) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      return;
    }

    final index = assessments.indexWhere(
      (assessment) => assessment['id'].toString() == assessmentId,
    );

    if (index == -1) {
      return;
    }

    final assessment = assessments[index];

    try {
      // Immediately update UI
      assessments[index]['is_complete'] = true;
      assessments[index]['status'] = 'Completed';
      assessments.refresh();

      // Save user's completion status
      await _supabase.from('user_assessment_status').upsert({
        'user_id': user.id,
        'assessment_id': assessmentId,
        'is_complete': true,
        'completed_at': DateTime.now().toUtc().toIso8601String(),
      }, onConflict: 'user_id,assessment_id');
    } catch (e) {
      debugPrint('Error completing assessment: $e');

      final dueDate = DateTime.parse(
        assessment['due_date'].toString(),
      ).toLocal();

      assessments[index]['is_complete'] = false;

      assessments[index]['status'] = dueDate.isBefore(DateTime.now())
          ? 'Overdue'
          : 'Pending';

      assessments.refresh();

      Get.snackbar(
        'Error',
        'Could not mark assessment as completed.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> refreshAssessments() async {
    await loadAssessments();
  }

  // ============================================================
  // FORMAT DATE
  // ============================================================

  String formatDueDate(dynamic value) {
    if (value == null) {
      return '';
    }

    final date = DateTime.parse(value.toString()).toLocal();

    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    int hour = date.hour;

    final minute = date.minute.toString().padLeft(2, '0');

    final period = hour >= 12 ? 'PM' : 'AM';

    if (hour == 0) {
      hour = 12;
    } else if (hour > 12) {
      hour -= 12;
    }

    return '${months[date.month - 1]} '
        '${date.day}, '
        '${date.year} '
        '$hour:$minute $period';
  }

  // ============================================================
  // COUNTS
  // ============================================================

  int get completedCount {
    return assessments.where((e) => e['status'] == 'Completed').length;
  }

  int get pendingCount {
    return assessments.where((e) => e['status'] == 'Pending').length;
  }

  int get overdueCount {
    return assessments.where((e) => e['status'] == 'Overdue').length;
  }

  Future<void> openUrl(String url) async {
    try {
      final uri = Uri.parse(url);

      final launched = await launchUrl(uri, webOnlyWindowName: '_blank');

      if (!launched) {
        throw Exception('Could not open URL');
      }
    } catch (e) {
      debugPrint('Error opening URL: $e');

      Get.snackbar(
        'Error',
        'Could not open the link.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
