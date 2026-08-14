import 'dart:async';

import 'package:ai_study_manager/app/routes/app_pages.dart';
import 'package:ai_study_manager/app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  // --------------------------------------------------------------------------
  // Controllers
  // --------------------------------------------------------------------------

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Signup fields
  final fullNameController = TextEditingController();
  final studentIdController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // --------------------------------------------------------------------------
  // State
  // --------------------------------------------------------------------------

  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final rememberMe = false.obs;

  final isChecking = false.obs;
  final isAuthenticated = false.obs;

  final _isLogin = true.obs;

  bool get isLogin => _isLogin.value;

  // --------------------------------------------------------------------------
  // Signup options
  // --------------------------------------------------------------------------

  final semesters = [
    '1st Semester',
    '2nd Semester',
    '3rd Semester',
    '4th Semester',
    '5th Semester',
    '6th Semester',
    '7th Semester',
    '8th Semester',
  ];

  final sections = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];

  final selectedSemester = RxnString();
  final selectedSection = RxnString();

  final acceptTerms = false.obs;

  // --------------------------------------------------------------------------
  // Auth mode
  // --------------------------------------------------------------------------
  
  // ignore: unused_field
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void onInit() {
    super.onInit();

    checkAuth();

    _authSubscription = _authService.authStateChanges.listen((data) {
      isAuthenticated.value = data.session != null;
    });
  }

  void checkAuth() {
    isChecking.value = true;

    try {
      isAuthenticated.value = _authService.isAuthenticated;
    } catch (e) {
      isAuthenticated.value = false;
    } finally {
      isChecking.value = false;
    }
  }

  void toggleAuthMode() {
    _isLogin.toggle();

    clearValidation();

    emailController.clear();
    passwordController.clear();

    if (isLogin) {
      fullNameController.clear();
      studentIdController.clear();
      confirmPasswordController.clear();

      selectedSemester.value = null;
      selectedSection.value = null;
      acceptTerms.value = false;
    }

    obscurePassword.value = true;
    obscureConfirmPassword.value = true;
  }

  void clearValidation() {
    formKey.currentState?.reset();
  }

  // --------------------------------------------------------------------------
  // Password visibility
  // --------------------------------------------------------------------------

  void togglePasswordVisibility() {
    obscurePassword.toggle();
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.toggle();
  }

  // --------------------------------------------------------------------------
  // Remember me
  // --------------------------------------------------------------------------

  void setRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  // --------------------------------------------------------------------------
  // Semester / Section
  // --------------------------------------------------------------------------

  void setSemester(String? value) {
    selectedSemester.value = value;
  }

  void setSection(String? value) {
    selectedSection.value = value;
  }

  void setAcceptTerms(bool? value) {
    acceptTerms.value = value ?? false;
  }

  // --------------------------------------------------------------------------
  // MAIN SUBMIT
  // --------------------------------------------------------------------------

  Future<void> submit() async {
    // Validate form first.
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    // Signup-specific validation.
    if (!isLogin && !acceptTerms.value) {
      Get.snackbar(
        'Terms Required',
        'Please accept the Terms of Service and Privacy Policy.',
      );

      return;
    }

    try {
      isLoading.value = true;

      if (isLogin) {
        await login();
      } else {
        await signup();
      }
    } catch (e) {
      Get.snackbar('Authentication Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // --------------------------------------------------------------------------
  // LOGIN
  // --------------------------------------------------------------------------

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    try {
      isLoading.value = true;

      final response = await _authService.login(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Unable to login.');
      }

      Get.offAllNamed(Routes.SIDEBAR);
    } on AuthException catch (e) {
      Get.snackbar('Login Failed', e.message);
    } catch (e) {
      Get.snackbar('Login Failed', 'Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // --------------------------------------------------------------------------
  // SIGNUP
  // --------------------------------------------------------------------------

  Future<void> signup() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (!acceptTerms.value) {
      Get.snackbar(
        'Terms Required',
        'Please accept the Terms of Service and Privacy Policy.',
      );
      return;
    }

    final fullName = fullNameController.text.trim();
    final studentId = studentIdController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    final semester = selectedSemester.value;
    final section = selectedSection.value;

    if (semester == null || section == null) {
      Get.snackbar(
        'Missing Information',
        'Please select your semester and section.',
      );
      return;
    }

    try {
      isLoading.value = true;

      final response = await _authService.signup(
        fullName: fullName,
        studentId: studentId,
        email: email,
        password: password,
        semester: semester,
        section: section,
      );

      if (response.user == null) {
        throw Exception('Unable to create account.');
      }

      // Email confirmation is enabled.
      if (response.session == null) {
        Get.snackbar(
          'Account Created',
          'Please check your email and verify your account.',
          duration: const Duration(seconds: 5),
        );

        // Switch back to login.
        _isLogin.value = true;

        clearSignupForm();

        return;
      }

      // Email confirmation is disabled.
      Get.snackbar('Welcome!', 'Your account has been created successfully.');

      Get.offAllNamed(Routes.SIDEBAR);
    } on AuthException catch (e) {
      Get.snackbar('Signup Failed', e.message);
    } catch (e) {
      Get.snackbar('Signup Failed', 'Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  void clearSignupForm() {
    fullNameController.clear();
    studentIdController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();

    selectedSemester.value = null;
    selectedSection.value = null;
    acceptTerms.value = false;

    obscurePassword.value = true;
    obscureConfirmPassword.value = true;
  }
  // --------------------------------------------------------------------------
  // FORGOT PASSWORD
  // --------------------------------------------------------------------------

  Future<void> forgotPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar('Email Required', 'Please enter your email address.');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Invalid Email', 'Please enter a valid email address.');
      return;
    }

    try {
      isLoading.value = true;

      await _authService.forgotPassword(email: email);

      Get.snackbar(
        'Check Your Email',
        'We sent you a password reset link.',
        duration: const Duration(seconds: 5),
      );
    } on AuthException catch (e) {
      Get.snackbar('Reset Password Failed', e.message);
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // --------------------------------------------------------------------------
  // DISPOSE
  // --------------------------------------------------------------------------

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();

    fullNameController.dispose();
    studentIdController.dispose();
    confirmPasswordController.dispose();

    super.onClose();
  }
}
