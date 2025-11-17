// ignore_for_file: deprecated_member_use, depend_on_referenced_packages, use_build_context_synchronously

import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/global/snackbar.dart';
import 'package:drips_water/logic/view_models/signup_view_model.dart';
import 'package:drips_water/presentation/screens/auth/login_screen.dart';
import 'package:drips_water/presentation/screens/auth/widgets/footer.dart';
import 'package:drips_water/presentation/screens/auth/widgets/header.dart';
import 'package:drips_water/presentation/screens/home/home_screen.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:drips_water/presentation/widgets/forms/custom_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ChangeNotifierProvider(
      create: (_) => SignupViewModel(),
      child: Consumer<SignupViewModel>(
        builder: (context, signupViewModel, _) {
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
                        controller: signupViewModel.userNameController,
                        textInputType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        hintText: "Enter your name",
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        labelText: "Email",
                        controller: signupViewModel.emailController,
                        textInputType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        hintText: "Enter your email",
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        labelText: "Password",
                        controller: signupViewModel.passwordController,
                        textInputType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        hintText: "Enter your password",
                        obscureText: signupViewModel.obscureText,
                        suffixIcon: IconButton(
                          onPressed: () => signupViewModel.toggleObscureText(),
                          icon: Icon(
                            signupViewModel.obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                      ),
                      if (signupViewModel.validationError != null &&
                          signupViewModel.validationError!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: Center(
                            child: Text(
                              signupViewModel.validationError!,
                              style: textTheme.bodySmall?.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 50),
                      signupViewModel.isLoading
                          ? Center(
                              child: LoadingAnimationWidget.threeArchedCircle(
                                color: AppColors.primary,
                                size: 45,
                              ),
                            )
                          : CustomButton(
                              onPressed: () async {
                                final success = await signupViewModel
                                    .register();

                                if (success) {
                                  showFloatingSnackBar(
                                    context,
                                    message: "Registration Successful",
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
                                } else if (signupViewModel.authError != null &&
                                    signupViewModel.authError!.isNotEmpty) {
                                  showFloatingSnackBar(
                                    context,
                                    message: signupViewModel.authError!,
                                    backgroundColor: AppColors.error,
                                  );
                                }
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
        },
      ),
    );
  }
}
