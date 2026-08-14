import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  User? get currentUser => _supabase.auth.currentUser;

  Session? get currentSession => _supabase.auth.currentSession;

  bool get isAuthenticated => currentSession != null;

  
  Future<AuthResponse> signup({
    required String fullName,
    required String studentId,
    required String email,
    required String password,
    required String semester,
    required String section,
  }) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'student_id': studentId,
        'semester': semester,
        'section': section,
      },
    );

    return response;
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) {
    return _supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> forgotPassword({required String email}) async {
    await _supabase.auth.resetPasswordForEmail(
      email,
      redirectTo: 'http://localhost:8080/reset-password',
    );
  }

  Future<void> updatePassword({required String password}) async {
    await _supabase.auth.updateUser(UserAttributes(password: password));
  }

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  Future<void> logout() async {
    await _supabase.auth.signOut();
  }
}
