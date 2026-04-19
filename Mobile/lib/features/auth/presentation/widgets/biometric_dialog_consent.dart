import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';

class BiometricDialogConsent extends StatelessWidget {
  final VoidCallback onEnable;
  final VoidCallback onCancel;

  const BiometricDialogConsent({
    super.key,
    required this.onEnable,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: EdgeInsets.fromLTRB(24, 8, 24, 24),
      title: const Text(
        'Activer la biométrie',
        style: TextStyle(fontWeight: .w500),
      ),
      content: Column(
        mainAxisSize: .min,
        children: [
          const Text(
            'Utilisez votre empreinte/Face ID pour vous connecter plus rapidement et sécuriser l\'accès à votre compte.',
            style: TextStyle(color: AppColors.mutedForeground),
          ),

          const SizedBox(height: 24),

          Lottie.asset(
            'assets/lotties/fingerprint_biometric.json',
            width: 200,
            height: 200,
            fit: .fill,
          ),

          const SizedBox(height: 8),
        ],
      ),
      actions: [
        Row(
          spacing: 8,
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  onCancel();
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 44),
                  textStyle: TextStyle(fontSize: AppTypography.small),
                ),
                child: Text('Plus tard'),
              ),
            ),

            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  onEnable();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 44),
                  textStyle: TextStyle(fontSize: AppTypography.small),
                ),
                child: Text('Activer'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
