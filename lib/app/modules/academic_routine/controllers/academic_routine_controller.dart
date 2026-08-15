import 'package:ai_study_manager/app/models/routine_schedule_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AcademicRoutineController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;
final c = 0.obs;
  final RxString selectedDay = ''.obs;

  final RxList<String> days = <String>[
    'Saturday',
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ].obs;

  // All routines fetched from Supabase
  final RxList<ScheduleModel> _allSchedules = <ScheduleModel>[].obs;
  final RxList<ScheduleModel> todaySchedules = <ScheduleModel>[].obs;
  // Routines currently displayed
  final RxList<ScheduleModel> schedules = <ScheduleModel>[].obs;

  void getTodaySchedule() {
    final today = _today();

    todaySchedules.assignAll(
      _allSchedules.where((schedule) => schedule.day == today).toList(),
    );
  }

  @override
  void onInit() {
    super.onInit();

    selectedDay.value = _today();

    // Only ONE API call
    loadAllRoutine();
  }

  String _today() {
    const dayNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return dayNames[DateTime.now().weekday - 1];
  }

  /// Fetch the complete routine once.
  Future<void> loadAllRoutine() async {
    try {
      final user = _supabase.auth.currentUser;

      if (user == null) {
        _allSchedules.clear();
        schedules.clear();
        return;
      }

      final metadata = user.userMetadata ?? {};

      final semester = metadata['semester'];
      final section = metadata['section'];

      if (semester == null || section == null) {
        _allSchedules.clear();
        schedules.clear();
        return;
      }
      final data = await _supabase
          .from('academic_routine')
          .select()
          .eq('semester', semester)
          .eq('section', section)
          .order('start_time');

      _allSchedules.assignAll(
        data.map<ScheduleModel>((item) {
          return ScheduleModel(
            startTime: item['start_time'] ?? '',
            endTime: item['end_time'] ?? '',
            title: item['title'] ?? '',
            subtitle: item['subtitle'] ?? '',
            teacher: item['teacher'] ?? '',
            room: item['room'] ?? '',
            number: item['number'] ?? '',
            day: item['day'] ?? '',
            color: null,
          );
        }).toList(),
      );

      // Show today's schedule
      filterByDay(selectedDay.value);

      getTodaySchedule();
    } catch (e) {
      debugPrint('Error loading routine: $e');

      _allSchedules.clear();
      schedules.clear();
    }
  }

  /// Change day WITHOUT calling Supabase.
  void changeDay(String day) {
    selectedDay.value = day;

    filterByDay(day);
  }

  /// Filter already downloaded data locally.
  void filterByDay(String day) {
    schedules.assignAll(
      _allSchedules.where((schedule) => schedule.day == day).toList(),
    );
  }

  bool isActive(ScheduleModel schedule) {
    final now = DateTime.now();

    final start = _parseTime(schedule.startTime);
    final end = _parseTime(schedule.endTime);

    if (start == null || end == null) {
      return false;
    }

    return !now.isBefore(start) && !now.isAfter(end);
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

  int? _parseTime1(String time) {
    try {
      final parts = time.split(" ");

      final hm = parts[0].split(":");

      int hour = int.parse(hm[0]);
      int minute = int.parse(hm[1]);

      if (parts[1] == "PM" && hour != 12) {
        hour += 12;
      }

      if (parts[1] == "AM" && hour == 12) {
        hour = 0;
      }

      return hour * 60 + minute;
    } catch (e) {
      return null;
    }
  }

  String get today {
    final now = DateTime.now();

    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return days[now.weekday - 1];
  }

  ScheduleModel? get nextClass {
    if (todaySchedules.isEmpty) {
      return null;
    }

    final now = TimeOfDay.now();

    final currentMinutes = now.hour * 60 + now.minute;

    for (final schedule in todaySchedules) {
      final start = _parseTime1(schedule.startTime);
      final end = _parseTime1(schedule.endTime);

      if (start == null || end == null) {
        continue;
      }

      // Current running class
      if (currentMinutes >= start && currentMinutes <= end) {
        return schedule;
      }

      // Upcoming class
      if (currentMinutes < start) {
        return schedule;
      }
    }

    // All classes ended
    return null;
  }

  bool isEnded(ScheduleModel schedule) {
    final now = TimeOfDay.fromDateTime(DateTime.now());

    final current = now.hour * 60 + now.minute;

    final end = _parseTime1(schedule.endTime);

    if (end == null) {
      return false;
    }

    return current > end;
  }
}
