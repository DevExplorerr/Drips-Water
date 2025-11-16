// ignore_for_file: deprecated_member_use, depend_on_referenced_packages, use_build_context_synchronously

import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/global/snackbar.dart';
import 'package:drips_water/logic/services/auth_service.dart';
import 'package:drips_water/presentation/screens/auth/login_screen.dart';
import 'package:drips_water/presentation/screens/auth/widgets/footer.dart';
import 'package:drips_water/presentation/screens/auth/widgets/header.dart';
import 'package:drips_water/presentation/screens/home/home_screen.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:drips_water/presentation/widgets/forms/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  bool obscureText = true;
  bool isLoading = false;
  String errorMessage = '';

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final username = _userNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => errorMessage = "Please fill in all fields.");
      return;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      setState(() => errorMessage = "Please enter a valid email address.");
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      await authService.value.signUp(
        email: email,
        password: password,
        userName: username,
      );

      if (!mounted) return;
      showFloatingSnackBar(
        context,
        message: "Registration successful",
        backgroundColor: AppColors.success,
      );

      await Future.delayed(const Duration(milliseconds: 500));

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      final errorMsg = switch (e.code) {
        'email-already-in-use' => "The email address is already in use.",
        'invalid-email' => "Invalid email format.",
        'weak-password' => "Password should be at least 6 characters.",
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
        message: "Unexpected error occurred please try again later.",
        backgroundColor: AppColors.error,
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 25,
              right: 25,
              top: kToolbarHeight,
              bottom: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 35),
                const Header(
                  title: "Create your Account",
                  description:
                      "Please fill in your details to create your account.",
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                const SizedBox(height: 35),
                CustomTextField(
                  labelText: "Name",
                  controller: _userNameController,
                  textInputType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  hintText: "Enter your name",
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  labelText: "Email",
                  controller: _emailController,
                  textInputType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  hintText: "Enter your email",
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  labelText: "Password",
                  controller: _passwordController,
                  textInputType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  hintText: "Enter your password",
                  obscureText: obscureText,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: theme.iconTheme.color,
                    ),
                  ),
                ),
                errorMessage.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          errorMessage,
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                const SizedBox(height: 50),
                isLoading
                    ? Center(
                        child: LoadingAnimationWidget.threeArchedCircle(
                          color: AppColors.primary,
                          size: 30,
                        ),
                      )
                    : CustomButton(
                        onPressed: () {
                          _register();
                        },
                        height: 55,
                        width: double.infinity,
                        text: "CREATE AN ACCOUNT",
                      ),
                const SizedBox(height: 30),
                Footer(
                  title: "Already have an account?",
                  subTitle: "Sign in",
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
