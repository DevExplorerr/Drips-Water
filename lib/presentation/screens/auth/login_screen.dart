// ignore_for_file: depend_on_referenced_packages, deprecated_member_use, use_build_context_synchronously

import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/global/snackbar.dart';
import 'package:drips_water/logic/services/auth_service.dart';
import 'package:drips_water/presentation/screens/auth/reset_password_screen.dart';
import 'package:drips_water/presentation/screens/auth/signup_screen.dart';
import 'package:drips_water/presentation/screens/auth/widgets/footer.dart';
import 'package:drips_water/presentation/screens/auth/widgets/header.dart';
import 'package:drips_water/presentation/screens/home/home_screen.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:drips_water/presentation/widgets/forms/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  bool obscureText = true;
  String errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => errorMessage = "Please enter email and password");
      return;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      setState(() => errorMessage = "Please enter a valid email address.");
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      await authService.value.login(email: email, password: password);

      if (!mounted) return;
      showFloatingSnackBar(
        context,
        message: "Login successfully",
        backgroundColor: AppColors.success,
      );

      await Future.delayed(const Duration(milliseconds: 500));

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      final errorMsg =
          (e.code == 'user-not-found' || e.code == 'wrong-password')
          ? "Invalid email or password."
          : e.message ?? e.code;

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
              children: [
                const SizedBox(height: 35),
                const Header(
                  title: "Welcome Back!",
                  description:
                      "Please fill in your email password to login to your account.",
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                const SizedBox(height: 35),
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
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const ResetPasswordScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Forgot Password?",
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
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
                const SizedBox(height: 40),
                isLoading
                    ? Center(
                        child: LoadingAnimationWidget.threeArchedCircle(
                          color: AppColors.primary,
                          size: 45,
                        ),
                      )
                    : CustomButton(
                        onPressed: () {
                          _login();
                        },
                        height: 55,
                        width: double.infinity,
                        text: "LOGIN",
                      ),
                const SizedBox(height: 30),
                Footer(
                  title: "Don't have an account?",
                  subTitle: "Sign up",
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const SignupScreen(),
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
