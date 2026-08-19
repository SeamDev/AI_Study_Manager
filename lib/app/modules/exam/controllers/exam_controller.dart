import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExamController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  final RxBool isLoading = false.obs;

  final RxString selectedFilter = 'All'.obs;

  final List<String> filters = ['All', 'Upcoming', 'Completed'];

  final RxList<Map<String, dynamic>> exams = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadExams();
  }

  // ============================================================
  // LOAD EXAMS
  // ============================================================

  Future<void> loadExams() async {
    try {
      isLoading.value = true;

      final response = await supabase
          .from('exams')
          .select()
          .order('exam_date', ascending: true);

      exams.assignAll(List<Map<String, dynamic>>.from(response));
    } catch (e) {
      print('Error loading exams: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // TODAY
  // ============================================================

  DateTime get today {
    final now = DateTime.now();

    return DateTime(now.year, now.month, now.day);
  }

  // ============================================================
  // CHECK UPCOMING
  // ============================================================

  bool isUpcoming(String? date) {
    if (date == null || date.isEmpty) {
      return false;
    }

    try {
      final examDate = DateTime.parse(date);

      final dateOnly = DateTime(examDate.year, examDate.month, examDate.day);

      return !dateOnly.isBefore(today);
    } catch (_) {
      return false;
    }
  }

  // ============================================================
  // CHECK COMPLETED
  // ============================================================

  bool isCompleted(String? date) {
    if (date == null || date.isEmpty) {
      return false;
    }

    try {
      final examDate = DateTime.parse(date);

      final dateOnly = DateTime(examDate.year, examDate.month, examDate.day);

      return dateOnly.isBefore(today);
    } catch (_) {
      return false;
    }
  }

  // ============================================================
  // FILTERED EXAMS
  // ============================================================

  List<Map<String, dynamic>> get filteredExams {
    if (selectedFilter.value == 'All') {
      return exams.toList();
    }

    if (selectedFilter.value == 'Upcoming') {
      return exams.where((exam) => isUpcoming(exam['exam_date'])).toList();
    }

    if (selectedFilter.value == 'Completed') {
      return exams.where((exam) => isCompleted(exam['exam_date'])).toList();
    }

    return exams.toList();
  }

  // ============================================================
  // TOTAL EXAMS
  // ============================================================

  int get totalExams {
    return exams.length;
  }

  // ============================================================
  // UPCOMING EXAMS
  // ============================================================

  int get upcomingExams {
    return exams.where((exam) => isUpcoming(exam['exam_date'])).length;
  }

  // ============================================================
  // COMPLETED EXAMS
  // ============================================================

  int get completedExams {
    return exams.where((exam) => isCompleted(exam['exam_date'])).length;
  }

  // ============================================================
  // TOTAL SUBJECTS
  // ============================================================

  int get totalSubjects {
    return exams
        .map((exam) => exam['course_code'])
        .where((code) => code != null)
        .toSet()
        .length;
  }

  // ============================================================
  // TOTAL EXAM DAYS
  // ============================================================

  int get totalExamDays {
    return exams
        .map((exam) => exam['exam_date'])
        .where((date) => date != null)
        .toSet()
        .length;
  }

  // ============================================================
  // CHANGE FILTER
  // ============================================================

  void changeFilter(String filter) {
    selectedFilter.value = filter;
  }

  // ============================================================
  // NEXT EXAM
  // ============================================================

  String get nextExamText {
    final upcoming = exams
        .where((exam) => isUpcoming(exam['exam_date']))
        .toList();

    if (upcoming.isEmpty) {
      return 'No upcoming exams';
    }

    upcoming.sort(
      (a, b) => DateTime.parse(
        a['exam_date'],
      ).compareTo(DateTime.parse(b['exam_date'])),
    );

    final nextDate = DateTime.parse(upcoming.first['exam_date']);

    final nextDateOnly = DateTime(nextDate.year, nextDate.month, nextDate.day);

    final difference = nextDateOnly.difference(today).inDays;

    if (difference == 0) {
      return 'Today';
    }

    if (difference == 1) {
      return 'Tomorrow';
    }

    return 'In $difference days';
  }

  // ============================================================
  // EXAM PERIOD
  // ============================================================

  String get examPeriod {
    if (exams.isEmpty) {
      return 'No exam period';
    }

    final dates = exams
        .map((exam) => DateTime.parse(exam['exam_date']))
        .toList();

    dates.sort();

    final first = dates.first;
    final last = dates.last;

    return '${_formatDate(first)} - ${_formatDate(last)}';
  }

  // ============================================================
  // DATE FORMAT
  // ============================================================

  String _formatDate(DateTime date) {
    const months = [
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

    return '${date.day} ${months[date.month - 1]}';
  }

  String formatDate(String? date) {
    if (date == null || date.isEmpty) {
      return '';
    }

    try {
      final parsedDate = DateTime.parse(date);

      const months = [
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

      return '${parsedDate.day} '
          '${months[parsedDate.month - 1]}, '
          '${parsedDate.year}';
    } catch (_) {
      return date;
    }
  }

  // ============================================================
  // DAY
  // ============================================================

  String getDay(String? date) {
    if (date == null || date.isEmpty) {
      return '';
    }

    try {
      final parsedDate = DateTime.parse(date);

      const days = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];

      return days[parsedDate.weekday - 1];
    } catch (_) {
      return '';
    }
  }

  // ============================================================
  // TIME FORMAT
  // ============================================================

  String formatTime(String? time) {
    if (time == null || time.isEmpty) {
      return '';
    }

    try {
      final parts = time.split(':');

      int hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      final period = hour >= 12 ? 'PM' : 'AM';

      if (hour == 0) {
        hour = 12;
      } else if (hour > 12) {
        hour -= 12;
      }

      return '$hour:${minute.toString().padLeft(2, '0')} $period';
    } catch (_) {
      return time;
    }
  }

  // ============================================================
  // EXAM TIME
  // ============================================================

  String getExamTime(String? startTime, String? endTime) {
    final start = formatTime(startTime);
    final end = formatTime(endTime);

    if (start.isEmpty || end.isEmpty) {
      return '';
    }

    return '$start - $end';
  }

  // ============================================================
  // DISPLAY STATUS
  // ============================================================

  String getExamStatus(String? date) {
    if (isUpcoming(date)) {
      return 'Upcoming';
    }

    if (isCompleted(date)) {
      return 'Completed';
    }

    return '';
  }
}
