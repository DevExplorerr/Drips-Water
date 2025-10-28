import 'package:drips_water/logic/services/auth_service.dart';
import 'package:drips_water/presentation/screens/welcome/welcome_screen.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Profile", style: theme.textTheme.titleLarge),
            const SizedBox(height: 20),
            CustomButton(
              onPressed: () {
                authService.value.logout();
                Future.delayed(const Duration(milliseconds: 600));
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WelcomeScreen(),
                  ),
                  (route) => false,
                );
              },
              height: 70,
              width: 140,
              text: "Logout",
            ),
          ],
        ),
      ),
    );
  }
}
