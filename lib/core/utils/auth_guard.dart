import 'package:drips_water/presentation/widgets/dialog/custom_login_prompt_dialog.dart';
import 'package:flutter/material.dart';

class AuthGuard {
  static bool check(BuildContext context, String? uid) {
    if (uid == null || uid.isEmpty || uid == "guest") {
      showDialog(
        context: context,
        animationStyle: AnimationStyle(
          curve: Curves.ease,
          duration: const Duration(milliseconds: 300),
          reverseDuration: const Duration(milliseconds: 200),
        ),
        builder: (ctx) =>
            const CustomLoginPromptDialog(message: "Sign In Required"),
      );
      return false;
    }
    return true;
  }
}
