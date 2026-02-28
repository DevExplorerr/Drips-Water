import 'package:drips_water/data/services/auth_service.dart';
import 'package:drips_water/logic/providers/cart_provider.dart';
import 'package:drips_water/logic/providers/favorite_provider.dart';
import 'package:drips_water/logic/view_models/home/home_app_bar_view_model.dart';
import 'package:drips_water/presentation/screens/home/profile/address_screen.dart';
import 'package:drips_water/presentation/screens/orders/order_history_screen.dart';
import 'package:drips_water/presentation/screens/welcome/welcome_screen.dart';
import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/presentation/widgets/dialog/confirmation_alert_dialog.dart';
import 'package:drips_water/presentation/widgets/dialog/custom_login_prompt_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          context.read<CartProvider>().clear();
          context.read<FavoriteProvider>().clear();

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

  void _showLoginPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const CustomLoginPromptDialog(
        message: "Please sign in to access your orders and account details.",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final vm = context.watch<HomeAppBarViewModel>();
    final bool isGuest = vm.isGuest;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Profile"), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: isGuest ? AppColors.grey : AppColors.primary,
              child: Icon(Icons.person, size: 50, color: AppColors.white),
            ),
            const SizedBox(height: 15),
            Text(
              isGuest
                  ? "Guest User"
                  : (vm.isLoading ? "Loading..." : "${vm.userName}"),
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: 30),
            _buildProfileTile(
              textTheme: textTheme,
              icon: Icons.shopping_bag_outlined,
              title: "My Orders",
              onTap: () {
                if (isGuest) {
                  _showLoginPrompt(context);
                } else {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const OrderHistoryScreen(),
                    ),
                  );
                }
              },
            ),

            _buildProfileTile(
              textTheme: textTheme,
              icon: Icons.location_on_outlined,
              title: "Shipping Addresses",
              onTap: () {
                if (isGuest) {
                  _showLoginPrompt(context);
                } else {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const AddressScreen(),
                    ),
                  );
                }
              },
            ),

            _buildProfileTile(
              textTheme: textTheme,
              icon: isGuest ? Icons.login_rounded : Icons.logout,
              title: isGuest ? "Sign In / Register" : "Logout",
              textColor: isGuest ? AppColors.primary : AppColors.red,
              iconColor: isGuest ? AppColors.primary : AppColors.red,
              onTap: () {
                if (isGuest) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(builder: (_) => const WelcomeScreen()),
                    (route) => false,
                  );
                } else {
                  _showLogoutDialog(context);
                }
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
