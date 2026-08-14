import 'package:ai_study_manager/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    
   final session = Supabase.instance.client.auth.currentSession;

    if (session == null) {
      return const RouteSettings(
        name: Routes.AUTH,
      );
    }


    return null;
  }
}
