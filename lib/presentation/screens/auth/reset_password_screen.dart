// ignore_for_file: use_build_context_synchronously

import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/global/snackbar.dart';
import 'package:drips_water/logic/view_models/auth/reset_password_view_model.dart';
import 'package:drips_water/presentation/screens/auth/login_screen.dart';
import 'package:drips_water/presentation/screens/auth/widgets/header.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:drips_water/presentation/widgets/forms/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with SingleTickerProviderStateMixin {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ResetPasswordViewModel(),
      child: Consumer<ResetPasswordViewModel>(
        builder: (context, resetPasswordViewModel, _) {
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
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
                        controller: resetPasswordViewModel.emailController,
                        textInputType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                      ),
                      if (resetPasswordViewModel.validationError != null &&
                          resetPasswordViewModel.validationError!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: Center(
                            child: Text(
                              resetPasswordViewModel.validationError!,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.error),
                            ),
                          ),
                        ),
                      const SizedBox(height: 50),
                      resetPasswordViewModel.isLoading
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
                              onPressed: () async {
                                final success = await resetPasswordViewModel
                                    .resetPasswordWithEmail();

                                if (success) {
                                  showFloatingSnackBar(
                                    context,
                                    message:
                                        "Reset link sent! Check your email.",
                                    backgroundColor: AppColors.success,
                                  );

                                  await Future.delayed(
                                    const Duration(milliseconds: 500),
                                  );

                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LoginScreen(),
                                    ),
                                    (route) => false,
                                  );
                                } else if (resetPasswordViewModel.authError !=
                                        null &&
                                    resetPasswordViewModel
                                        .authError!
                                        .isNotEmpty) {
                                  showFloatingSnackBar(
                                    context,
                                    message: resetPasswordViewModel.authError!,
                                    backgroundColor: AppColors.error,
                                  );
                                }
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
