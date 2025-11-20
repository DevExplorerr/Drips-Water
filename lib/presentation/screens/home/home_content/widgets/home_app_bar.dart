import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/logic/services/auth_service.dart';
import 'package:drips_water/presentation/screens/auth/signup_screen.dart';
import 'package:drips_water/presentation/screens/search/search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  String? userName;

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    final user = authService.value.currentUser;
    if (user != null) {
      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (snapshot.exists) {
          setState(() {
            userName = snapshot.data()?['name'] ?? 'Guest';
          });
        }
      } catch (e) {
        debugPrint('Error fetching username: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bool isGuest = FirebaseAuth.instance.currentUser == null;

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
                  child: isGuest
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
                isGuest
                    ? "Welcome, Guest"
                    : (userName != null ? "Welcome, $userName" : "Loading..."),
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
