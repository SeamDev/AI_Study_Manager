import 'package:ai_study_manager/app/routes/app_pages.dart';
import 'package:ai_study_manager/app/services/auth_service.dart';
import 'package:ai_study_manager/app/services/database_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

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

class SidebarController extends GetxController {
  final selectedIndex = 0.obs;

  final List<String> menuItems = [
    'Dashboard',
    'Study With AI',
    'Notice',
    'Academic Routine',
    'Assessments /\nHome Work',
    'To Do',
    'Exams',
    'Bus Schedule',
  ];

  final List<IconData> menuIcons = [
    Icons.home_rounded,
    Icons.auto_awesome,
    Icons.campaign_rounded,
    Icons.calendar_month_rounded,
    Icons.assignment_rounded,
    Icons.check_box_rounded,
    Icons.school_rounded,
    Icons.directions_bus,
  ];

  final List<Color> menuColors = [
    AppColors.blue,
    AppColors.purple,
    AppColors.orange,
    AppColors.green,
    Colors.deepOrange,
    Colors.blue,
    AppColors.red,
    Color(0xFF378EB1),
  ];

  final DatabaseService _database = DatabaseService();

  final AuthService _authService = AuthService();

  final isLoading = false.obs;

  final fullName = ''.obs;
  final email = ''.obs;
  final studentId = ''.obs;
  final semester = ''.obs;
  final section = ''.obs;
  final initials = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadSelectedIndex();
    loadUserInfo();
  }

  Future<void> loadSelectedIndex() async {
    final box = Hive.box("chatBox");

    selectedIndex.value = box.get("index", defaultValue: 0) as int;
  }

  Future<void> changePage(int index) async {
    selectedIndex.value = index;

    final box = Hive.box('chatBox');

    await box.put('index', index);
  }

  Future<void> loadUserInfo() async {
    try {
      isLoading.value = true;

      final user = _database.currentUser;

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
      Get.snackbar('Error', 'Unable to load user information.');
    } finally {
      isLoading.value = false;
    }
  }

  String _getInitials(String name) {
    if (name.trim().isEmpty) {
      return '?';
    }

    final parts = name.trim().split(RegExp(r'\s+'));

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  Future<void> logout() async {
    await _authService.logout();
    Get.offAllNamed(Routes.AUTH);
  }
}
