// ignore_for_file: depend_on_referenced_packages, deprecated_member_use, use_build_context_synchronously

import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/global/snackbar.dart';
import 'package:drips_water/logic/view_models/login_view_model.dart';
import 'package:drips_water/presentation/screens/auth/reset_password_screen.dart';
import 'package:drips_water/presentation/screens/auth/signup_screen.dart';
import 'package:drips_water/presentation/screens/auth/widgets/footer.dart';
import 'package:drips_water/presentation/screens/auth/widgets/header.dart';
import 'package:drips_water/presentation/screens/home/home_screen.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:drips_water/presentation/widgets/forms/custom_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Consumer<LoginViewModel>(
        builder: (context, loginViewModel, _) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                        controller: loginViewModel.emailController,
                        textInputType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        hintText: "Enter your email",
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        labelText: "Password",
                        controller: loginViewModel.passwordController,
                        textInputType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        hintText: "Enter your password",
                        obscureText: loginViewModel.obscureText,
                        suffixIcon: IconButton(
                          onPressed: () => loginViewModel.toggleObscureText(),
                          icon: Icon(
                            loginViewModel.obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Theme.of(context).iconTheme.color,
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
                                builder: (context) =>
                                    const ResetPasswordScreen(),
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
                      if (loginViewModel.validationError != null &&
                          loginViewModel.validationError!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Center(
                            child: Text(
                              loginViewModel.validationError!,
                              style: textTheme.bodySmall?.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 50),
                      loginViewModel.isLoading
                          ? Center(
                              child: LoadingAnimationWidget.threeArchedCircle(
                                color: AppColors.primary,
                                size: 45,
                              ),
                            )
                          : CustomButton(
                              onPressed: () async {
                                final success = await loginViewModel.login();

                                if (success) {
                                  showFloatingSnackBar(
                                    context,
                                    message: "Login Successfully",
                                    backgroundColor: AppColors.success,
                                  );

                                  await Future.delayed(
                                    const Duration(milliseconds: 500),
                                  );

                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomeScreen(),
                                    ),
                                    (route) => false,
                                  );
                                } else if (loginViewModel.authError != null &&
                                    loginViewModel.authError!.isNotEmpty) {
                                  showFloatingSnackBar(
                                    context,
                                    message: loginViewModel.authError!,
                                    backgroundColor: AppColors.error,
                                  );
                                }
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
        },
      ),
    );
  }
}
