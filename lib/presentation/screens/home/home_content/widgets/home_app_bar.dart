import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/logic/view_models/home_app_bar_view_model.dart';
import 'package:drips_water/presentation/screens/auth/signup_screen.dart';
import 'package:drips_water/presentation/screens/search/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeAppBarViewModel>();
    final textTheme = Theme.of(context).textTheme;
    return SliverAppBar(
      backgroundColor: AppColors.primary,
      expandedHeight: 170,
      pinned: true,
      floating: false,
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
                child: Align(
                  alignment: Alignment.topRight,
                  child: vm.isGuest
                      ? TextButton(
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
                        )
                      : const SizedBox(),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                vm.isGuest
                    ? "Welcome, Guest"
                    : vm.isLoading
                    ? "Loading..."
                    : "Welcome, ${vm.userName}",
                style: textTheme.titleLarge?.copyWith(
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => const SearchScreen()),
            );
          },
          child: Container(
            color: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: IgnorePointer(
              child: SearchBar(
                hintText: "Search something...",
                leading: const Icon(Icons.search, color: AppColors.primary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
