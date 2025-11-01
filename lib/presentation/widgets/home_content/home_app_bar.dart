import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/presentation/screens/auth/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bool isGuest = FirebaseAuth.instance.currentUser == null;

    return SliverAppBar(
      backgroundColor: AppColors.primary,
      expandedHeight: 130,
      pinned: true,
      floating: false,
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isGuest)
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        CupertinoPageRoute(
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
                ),
              const SizedBox(height: 12),
              Text(
                "Welcome!",
                style: textTheme.titleLarge?.copyWith(
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
      // Pinned search bar at the bottom of app bar
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(35),
        child: Container(
          color: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: SearchBar(
            hintText: "Search something...",
            leading: Icon(Icons.search, color: AppColors.primary),
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
          ),
        ),
      ),
    );
  }
}
