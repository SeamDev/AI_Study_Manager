import 'package:ai_study_manager/app/routes/app_pages.dart';
import 'package:ai_study_manager/app/utils/app_binding.dart';
import 'package:ai_study_manager/app/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ueltdsfdhiufopuvazsa.supabase.co',
    publishableKey: 'sb_publishable_y4VPzulMfz1gfen_SMW6Wg_zt5BK9Lm',
  );
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox("chatBox");
  runApp(const StudyWithAIApp());
}

class StudyWithAIApp extends StatelessWidget {
  const StudyWithAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Study With AI',
      getPages: AppPages.routes,
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      initialBinding: AppBinding(),
      initialRoute: AppPages.INITIAL,
    );
  }
}
