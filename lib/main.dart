import 'package:ai_study_manager/app/modules/sidebar/controllers/sidebar_controller.dart';
import 'package:ai_study_manager/app/modules/sidebar/views/sidebar_view.dart';
import 'package:ai_study_manager/app/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const StudyWithAIApp());
}

class StudyWithAIApp extends StatelessWidget {
  const StudyWithAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Study With AI',
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      initialBinding: BindingsBuilder(() {
        Get.lazyPut<SidebarController>(() => SidebarController());
      }),
      home: const DashboardPage(),
    );
  }
}
