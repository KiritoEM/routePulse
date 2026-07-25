import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/shared/widgets/button_with_loader.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  final String title;
  final String message;
  final bool isLoading;
  final VoidCallback onConfirm;

  const ConfirmDeleteDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      title: Row(
        spacing: 12,
        children: [
          CustomIcon(
            path: 'assets/icons/trash.svg',
            width: 24,
            color: AppColors.error,
          ),
          Expanded(
            child: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
      content: Text(
        message,
        style: TextStyle(color: AppColors.mutedForeground),
      ),
      actions: [
        Row(
          spacing: 8,
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: isLoading ? null : () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 44),
                  textStyle: TextStyle(fontSize: AppTypography.small),
                ),
                child: const Text('Annuler'),
              ),
            ),
            Expanded(
              child: ButtonWithLoader(
                text: 'Supprimer',
                loadingText: 'Suppression...',
                isLoading: isLoading,
                onPressed: isLoading ? null : onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  minimumSize: const Size(double.infinity, 44),
                  textStyle: TextStyle(fontSize: AppTypography.small),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
