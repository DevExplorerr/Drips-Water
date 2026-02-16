// ignore_for_file: deprecated_member_use

import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/global/snackbar.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ConfirmationAlertDialog extends StatefulWidget {
  final String title;
  final IconData icon;
  final String desc;
  final String buttonTxt;
  final String? secondaryButtonText;
  final String successMessage;
  final Future<void> Function() onConfirm;
  const ConfirmationAlertDialog({
    super.key,
    required this.onConfirm,
    required this.title,
    required this.icon,
    required this.desc,
    required this.buttonTxt,
    this.secondaryButtonText,
    this.successMessage = "Action completed successfully",
  });

  @override
  State<ConfirmationAlertDialog> createState() =>
      _ConfirmationAlertDialogState();
}

class _ConfirmationAlertDialogState extends State<ConfirmationAlertDialog> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return AlertDialog(
      backgroundColor: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: .circular(20)),
      contentPadding: const .fromLTRB(24, 20, 24, 10),
      insetPadding: const .symmetric(horizontal: 30),

      content: Column(
        mainAxisSize: .min,
        children: [
          // Premium Circular Icon
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.2),
              shape: .circle,
            ),
            child: Icon(widget.icon, size: 34, color: AppColors.primary),
          ),

          const SizedBox(height: 20),

          // Title
          Text(widget.title, style: textTheme.titleLarge),

          const SizedBox(height: 10),

          // Description
          Text(
            widget.desc,
            textAlign: .center,
            style: textTheme.bodyMedium?.copyWith(
              height: 1.4,
              color: AppColors.secondaryText,
            ),
          ),

          const SizedBox(height: 25),

          // Buttons
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  child: Text(
                    widget.secondaryButtonText ?? "Cancel",
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: .w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _isLoading
                    ? LoadingAnimationWidget.threeRotatingDots(
                        color: AppColors.primary,
                        size: 35,
                      )
                    : CustomButton(
                        height: 40,
                        width: 40,
                        text: widget.buttonTxt,
                        onPressed: () async {
                          setState(() => _isLoading = true);
                          try {
                            await widget.onConfirm();
                            if (context.mounted && Navigator.canPop(context)) {
                              Navigator.pop(context);
                              showFloatingSnackBar(
                                context,
                                message: widget.successMessage,
                                backgroundColor: theme.primaryColor,
                              );
                            }
                          } finally {
                            if (mounted) {
                              setState(() => _isLoading = false);
                            }
                          }
                        },
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
