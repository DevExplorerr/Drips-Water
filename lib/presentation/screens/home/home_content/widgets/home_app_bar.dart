import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/logic/providers/address_provider.dart';
import 'package:drips_water/logic/providers/user_provider.dart';
import 'package:drips_water/presentation/screens/auth/signup_screen.dart';
import 'package:drips_water/presentation/screens/home/profile/address/address_management_screen.dart';
import 'package:drips_water/presentation/screens/search/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UserProvider>();
    final addressProvider = context.watch<AddressProvider>();
    final textTheme = Theme.of(context).textTheme;

    return SliverAppBar(
      backgroundColor: AppColors.primary,
      expandedHeight: 170,
      pinned: true,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: .pin,
        background: Padding(
          padding: const .only(left: 20, right: 20, top: 40),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              const SizedBox(height: 15),
              SizedBox(
                height: 40,
                child: Align(
                  alignment: .centerRight,
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
                              fontWeight: .w600,
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => const AddressManagementScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const .symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: .circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.black.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: .min,
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 14,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    addressProvider.selectedAddress?.city ??
                                        "Set Location",
                                    style: textTheme.bodySmall?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: .w600,
                                    ),
                                    maxLines: 1,
                                    overflow: .ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ),
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
            child: const IgnorePointer(
              child: SearchBar(
                hintText: "Search something...",
                leading: Icon(Icons.search, color: AppColors.primary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
