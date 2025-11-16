// ignore_for_file: use_build_context_synchronously

import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/global/snackbar.dart';
import 'package:drips_water/logic/services/auth_service.dart';
import 'package:drips_water/presentation/screens/auth/login_screen.dart';
import 'package:drips_water/presentation/screens/auth/widgets/header.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:drips_water/presentation/widgets/forms/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> resetPasswordWithEmail() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      showFloatingSnackBar(
        context,
        message: "Please enter your email address.",
        backgroundColor: AppColors.error,
      );
      return;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      showFloatingSnackBar(
        context,
        message: "Please enter a valid email address.",
        backgroundColor: AppColors.error,
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await authService.value.resetPasswordWithEmail(email: email);

      if (!mounted) return;
      showFloatingSnackBar(
        context,
        message: "Reset link sent! Check your email.",
        backgroundColor: AppColors.success,
      );

      await Future.delayed(const Duration(milliseconds: 500));

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      final errorMsg = switch (e.code) {
        'user-not-found' => "No account found for this email.",
        _ => e.message ?? e.code,
      };

      showFloatingSnackBar(
        context,
        message: errorMsg,
        backgroundColor: AppColors.error,
      );
    } catch (_) {
      showFloatingSnackBar(
        context,
        message: "Unexpected error occurred. Try again later.",
        backgroundColor: AppColors.error,
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: const Icon(
                      Icons.lock_outline,
                      size: 80,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Header(
                    title: "Reset Password",
                    description: "Enter your email to receive a reset link",
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                  const SizedBox(height: 35),
                  CustomTextField(
                    hintText: "Enter your email",
                    labelText: "Email",
                    controller: _emailController,
                    textInputType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 40),
                  isLoading
                      ? Center(
                          child: LoadingAnimationWidget.threeArchedCircle(
                            color: AppColors.primary,
                            size: 45,
                          ),
                        )
                      : CustomButton(
                          text: "Reset Password",
                          height: 55,
                          width: double.infinity,
                          onPressed: () {
                            resetPasswordWithEmail();
                          },
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
