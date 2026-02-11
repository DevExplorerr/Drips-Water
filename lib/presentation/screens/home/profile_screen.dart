import 'package:drips_water/data/services/auth_service.dart';
import 'package:drips_water/presentation/screens/orders/order_history_screen.dart';
import 'package:drips_water/presentation/screens/welcome/welcome_screen.dart';
import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/presentation/widgets/dialog/confirmation_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationAlertDialog(
        title: "Logout",
        icon: Icons.delete_forever_rounded,
        desc: "Are you sure you want to logout?",
        buttonTxt: "Logout",
        successMessage: "Logged out successfully",
        onConfirm: () async {
          await authService.value.logout();
          if (context.mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(builder: (context) => const WelcomeScreen()),
              (route) => false,
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Profile"), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, size: 50, color: AppColors.white),
            ),
            const SizedBox(height: 15),
            Text("User Name", style: textTheme.titleMedium),
            const SizedBox(height: 30),
            _buildProfileTile(
              textTheme: textTheme,
              icon: Icons.shopping_bag_outlined,
              title: "My Orders",
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const OrderHistoryScreen(),
                  ),
                );
              },
            ),

            _buildProfileTile(
              textTheme: textTheme,
              icon: Icons.location_on_outlined,
              title: "Shipping Addresses",
              onTap: () {
                // Future: Navigate to address management
              },
            ),

            _buildProfileTile(
              textTheme: textTheme,
              icon: Icons.logout,
              title: "Logout",
              textColor: AppColors.red,
              iconColor: AppColors.red,
              onTap: () {
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
    required TextTheme textTheme,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: iconColor ?? AppColors.icon),
      title: Text(
        title,
        style: textTheme.bodyMedium?.copyWith(
          color: textColor ?? AppColors.textLight,
          fontWeight: .w500,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.icon,
      ),
    );
  }
}
