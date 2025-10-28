import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/presentation/screens/auth/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bool isGuest = FirebaseAuth.instance.currentUser == null;
    return Container(
      color: AppColors.primary,
      height: 225,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 30,
          bottom: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: isGuest
                  ? Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        child: Text(
                          "Sign Up",
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 12),
            Text(
              "Welcome!",
              style: textTheme.titleLarge?.copyWith(color: AppColors.textDark),
            ),
            const SizedBox(height: 12),

            // Search Bar
            SearchBar(
              hintText: "Search something...",
              leading: Icon(Icons.search, color: AppColors.primary),
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
            ),
          ],
        ),
      ),
    );
  }
}
