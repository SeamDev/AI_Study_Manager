import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ---------------------------------------------------------------------------
  // Current User
  // ---------------------------------------------------------------------------

  User? get currentUser {
    return _supabase.auth.currentUser;
  }

  String? get currentUserId {
    return currentUser?.id;
  }

  String? get currentUserEmail {
    return currentUser?.email;
  }

  // ---------------------------------------------------------------------------
  // Get Current User Profile
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    final userId = currentUserId;

    if (userId == null) {
      return null;
    }

    return await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
  }

  // ---------------------------------------------------------------------------
  // Get Profile By User ID
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>?> getProfileByUserId(String userId) async {
    return await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
  }

  // ---------------------------------------------------------------------------
  // Update Current User Profile
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> updateCurrentUserProfile({
    String? fullName,
    String? studentId,
    String? semester,
    String? section,
  }) async {
    final userId = currentUserId;

    if (userId == null) {
      throw Exception('User is not logged in.');
    }

    final data = <String, dynamic>{};

    if (fullName != null) {
      data['full_name'] = fullName;
    }

    if (studentId != null) {
      data['student_id'] = studentId;
    }

    if (semester != null) {
      data['semester'] = semester;
    }

    if (section != null) {
      data['section'] = section;
    }

    data['updated_at'] = DateTime.now().toIso8601String();

    return await _supabase
        .from('profiles')
        .update(data)
        .eq('id', userId)
        .select()
        .single();
  }

  // ---------------------------------------------------------------------------
  // Get All Profiles
  // ---------------------------------------------------------------------------

  Future<List<Map<String, dynamic>>> getProfiles() async {
    final response = await _supabase.from('profiles').select();

    return List<Map<String, dynamic>>.from(response);
  }

  // ---------------------------------------------------------------------------
  // Get Profile By Student ID
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>?> getProfileByStudentId(String studentId) async {
    return await _supabase
        .from('profiles')
        .select()
        .eq('student_id', studentId)
        .maybeSingle();
  }
}
