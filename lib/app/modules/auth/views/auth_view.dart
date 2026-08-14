import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 900) {
            return const Center(
              child: Text('Please use Study With AI on a desktop device.'),
            );
          }

          return Row(
            children: [
              Expanded(child: _BrandSection()),
              Expanded(child: _AuthPanel()),
            ],
          );
        },
      ),
    );
  }
}

// =============================================================================
// BRAND SECTION
// =============================================================================

class _BrandSection extends StatelessWidget {
  const _BrandSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/auth_robot.png'),
          opacity: 0.5,
          fit: BoxFit.cover,
        ),
        border: Border(
          right: BorderSide(color: colors.outline.withValues(alpha: 0.2)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -----------------------------------------------------------------
          // LOGO
          // -----------------------------------------------------------------
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [colors.primary, colors.secondary],
                  ),
                ),
                child: Icon(
                  Icons.smart_toy_rounded,
                  size: 34,
                  color: colors.onPrimary,
                ),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: theme.textTheme.headlineMedium,
                      children: [
                        TextSpan(
                          text: 'AI ',
                          style: TextStyle(
                            color: colors.secondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const TextSpan(text: 'Study Manager'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Your AI-Powered Study Companion',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),

          const Spacer(),

          // -----------------------------------------------------------------
          // TITLE
          // -----------------------------------------------------------------
          RichText(
            text: TextSpan(
              style: theme.textTheme.displayMedium?.copyWith(
                fontSize: 42,
                height: 1.15,
                fontWeight: FontWeight.w700,
              ),
              children: [
                TextSpan(
                  text: 'Smarter ',
                  style: TextStyle(color: colors.secondary),
                ),
                const TextSpan(text: 'Learning,\n'),
                TextSpan(
                  text: 'Better ',
                  style: TextStyle(color: colors.secondary),
                ),
                const TextSpan(text: 'Tomorrow'),
              ],
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: 560,
            child: Text(
              'Plan, track, and achieve your academic goals '
              'with the power of AI.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colors.onSurface.withValues(alpha: 0.7),
                height: 1.6,
              ),
            ),
          ),


          const SizedBox(height: 100),

          const _FeatureBar(),

          const Spacer(),
        ],
      ),
    );
  }
}

// =============================================================================
// FEATURE BAR
// =============================================================================

class _FeatureBar extends StatelessWidget {
  const _FeatureBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final features = [
      (
        Icons.psychology_rounded,
        'AI Assistance',
        'Smart study\nrecommendations',
      ),
      (
        Icons.calendar_month_rounded,
        'Organized',
        'Plan and manage\nyour schedule',
      ),
      (
        Icons.track_changes_rounded,
        'Track Progress',
        'Monitor your goals\nand achievements',
      ),
      (
        Icons.verified_user_rounded,
        'Stay Focused',
        'Distraction-free\nlearning environment',
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.outline.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          for (int i = 0; i < features.length; i++) ...[
            Expanded(
              child: Column(
                children: [
                  Icon(features[i].$1, size: 28, color: colors.secondary),
                  const SizedBox(height: 8),
                  Text(
                    features[i].$2,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    features[i].$3,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (i != features.length - 1)
              Container(
                width: 1,
                height: 65,
                color: colors.outline.withValues(alpha: 0.2),
              ),
          ],
        ],
      ),
    );
  }
}

// =============================================================================
// AUTH PANEL
// =============================================================================

class _AuthPanel extends GetView<AuthController> {
  const _AuthPanel();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 35),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Obx(
            () => controller.isLogin ? const _LoginPage() : const _SignupPage(),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// LOGIN PAGE
// =============================================================================

class _LoginPage extends GetView<AuthController> {
  const _LoginPage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      children: [
        // -------------------------------------------------------------------
        // ICON
        // -------------------------------------------------------------------
        _AuthIcon(icon: Icons.lock_outline_rounded),

        const SizedBox(height: 25),

        // -------------------------------------------------------------------
        // TITLE
        // -------------------------------------------------------------------
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: theme.textTheme.displaySmall?.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
            children: [
              const TextSpan(text: 'Welcome '),
              TextSpan(
                text: 'Back!',
                style: TextStyle(color: colors.secondary),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'Login to continue your learning journey',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.onSurface.withValues(alpha: 0.65),
          ),
        ),

        const SizedBox(height: 30),

        const _LoginForm(),

        const SizedBox(height: 22),

        _SwitchAuthMode(
          text: "Don't have an account?",
          action: 'Sign Up',
          onPressed: controller.toggleAuthMode,
        ),
      ],
    );
  }
}

// =============================================================================
// LOGIN FORM
// =============================================================================

class _LoginForm extends GetView<AuthController> {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //final colors = theme.colorScheme;

    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          // Email
          TextFormField(
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              hintText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email';
              }

              if (!GetUtils.isEmail(value.trim())) {
                return 'Please enter a valid email';
              }

              return null;
            },
          ),

          const SizedBox(height: 14),

          // Password
          Obx(
            () => TextFormField(
              controller: controller.passwordController,
              obscureText: controller.obscurePassword.value,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) {
                controller.submit();
              },
              decoration: InputDecoration(
                hintText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  onPressed: controller.togglePasswordVisibility,
                  icon: Icon(
                    controller.obscurePassword.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }

                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }

                return null;
              },
            ),
          ),

          const SizedBox(height: 8),

          // Remember me / Forgot password
          Row(
            children: [
              Obx(
                () => Checkbox(
                  value: controller.rememberMe.value,
                  onChanged: controller.setRememberMe,
                ),
              ),
              Text('Remember me', style: theme.textTheme.bodyMedium),
              const Spacer(),
              TextButton(
                onPressed: controller.forgotPassword,
                child: const Text('Forgot Password?'),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _AuthButton(text: 'Login', onPressed: controller.submit),
        ],
      ),
    );
  }
}

// =============================================================================
// SIGNUP PAGE
// =============================================================================

class _SignupPage extends GetView<AuthController> {
  const _SignupPage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      children: [
        // -------------------------------------------------------------------
        // ICON
        // -------------------------------------------------------------------
        _AuthIcon(icon: Icons.person_add_alt_1_rounded),

        const SizedBox(height: 20),

        // -------------------------------------------------------------------
        // TITLE
        // -------------------------------------------------------------------
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: theme.textTheme.displaySmall?.copyWith(
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
            children: [
              const TextSpan(text: 'Create '),
              TextSpan(
                text: 'Account',
                style: TextStyle(color: colors.secondary),
              ),
            ],
          ),
        ),

        const SizedBox(height: 6),

        Text(
          'Sign up to get started with AI Study Manager',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colors.onSurface.withValues(alpha: 0.65),
          ),
        ),

        const SizedBox(height: 25),

        const _SignupForm(),

        const SizedBox(height: 20),

        _SwitchAuthMode(
          text: 'Already have an account?',
          action: 'Login',
          onPressed: controller.toggleAuthMode,
        ),
      ],
    );
  }
}

// =============================================================================
// SIGNUP FORM
// =============================================================================

class _SignupForm extends GetView<AuthController> {
  const _SignupForm();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          // -----------------------------------------------------------------
          // FULL NAME + STUDENT ID
          // -----------------------------------------------------------------
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.fullNameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'Full Name',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Required';
                    }

                    return null;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: controller.studentIdController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'Student ID',
                    prefixIcon: Icon(Icons.school_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Required';
                    }

                    return null;
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // -----------------------------------------------------------------
          // EMAIL
          // -----------------------------------------------------------------
          TextFormField(
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              hintText: 'Email Address',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email';
              }

              if (!GetUtils.isEmail(value.trim())) {
                return 'Please enter a valid email';
              }

              return null;
            },
          ),

          const SizedBox(height: 10),

          // -----------------------------------------------------------------
          // PASSWORD
          // -----------------------------------------------------------------
          Obx(
            () => TextFormField(
              controller: controller.passwordController,
              obscureText: controller.obscurePassword.value,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  onPressed: controller.togglePasswordVisibility,
                  icon: Icon(
                    controller.obscurePassword.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }

                if (value.length < 8) {
                  return 'Password must be at least 8 characters';
                }

                return null;
              },
            ),
          ),

          const SizedBox(height: 10),

          // -----------------------------------------------------------------
          // CONFIRM PASSWORD
          // -----------------------------------------------------------------
          Obx(
            () => TextFormField(
              controller: controller.confirmPasswordController,
              obscureText: controller.obscureConfirmPassword.value,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: 'Confirm Password',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  onPressed: controller.toggleConfirmPasswordVisibility,
                  icon: Icon(
                    controller.obscureConfirmPassword.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }

                if (value != controller.passwordController.text) {
                  return 'Passwords do not match';
                }

                return null;
              },
            ),
          ),

          const SizedBox(height: 10),

          // -----------------------------------------------------------------
          // SEMESTER + SECTION
          // -----------------------------------------------------------------
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: controller.selectedSemester.value,
                  decoration: const InputDecoration(
                    hintText: 'Semester',
                    prefixIcon: Icon(Icons.calendar_month_outlined),
                  ),
                  items: controller.semesters
                      .map(
                        (semester) => DropdownMenuItem(
                          value: semester,
                          child: Text(semester),
                        ),
                      )
                      .toList(),
                  onChanged: controller.setSemester,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }

                    return null;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: controller.selectedSection.value,
                  decoration: const InputDecoration(
                    hintText: 'Section',
                    prefixIcon: Icon(Icons.groups_outlined),
                  ),
                  items: controller.sections
                      .map(
                        (section) => DropdownMenuItem(
                          value: section,
                          child: Text(section),
                        ),
                      )
                      .toList(),
                  onChanged: controller.setSection,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }

                    return null;
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // -----------------------------------------------------------------
          // TERMS
          // -----------------------------------------------------------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(
                () => Checkbox(
                  value: controller.acceptTerms.value,
                  onChanged: controller.setAcceptTerms,
                  visualDensity: VisualDensity.compact,
                ),
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodySmall,
                    children: [
                      const TextSpan(text: 'I agree to the '),
                      TextSpan(
                        text: 'Terms of Service',
                        style: TextStyle(color: colors.secondary),
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(color: colors.secondary),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // -----------------------------------------------------------------
          // SIGNUP BUTTON
          // -----------------------------------------------------------------
          _AuthButton(text: 'Sign Up', onPressed: controller.submit),
        ],
      ),
    );
  }
}

// =============================================================================
// AUTH ICON
// =============================================================================

class _AuthIcon extends StatelessWidget {
  final IconData icon;

  const _AuthIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: 82,
      height: 82,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: colors.primary.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.12),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Icon(icon, size: 40, color: colors.primary),
    );
  }
}

// =============================================================================
// AUTH BUTTON
// =============================================================================

class _AuthButton extends GetView<AuthController> {
  final String text;
  final VoidCallback onPressed;

  const _AuthButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 52,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            gradient: LinearGradient(
              colors: [colors.primary, colors.secondary],
            ),
          ),
          child: ElevatedButton(
            onPressed: controller.isLoading.value ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              disabledBackgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            child: controller.isLoading.value
                ? SizedBox(
                    width: 21,
                    height: 21,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.onPrimary,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        text,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colors.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 9),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: colors.onPrimary,
                        size: 20,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// SWITCH LOGIN / SIGNUP
// =============================================================================

class _SwitchAuthMode extends StatelessWidget {
  final String text;
  final String action;
  final VoidCallback onPressed;

  const _SwitchAuthMode({
    required this.text,
    required this.action,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text, style: theme.textTheme.bodyMedium),
        const SizedBox(width: 5),
        TextButton(onPressed: onPressed, child: Text(action)),
      ],
    );
  }
}
