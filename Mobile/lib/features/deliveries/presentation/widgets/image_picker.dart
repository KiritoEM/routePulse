import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';

class ImagePicker extends StatelessWidget {
  final File? image;
  final String? error;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const ImagePicker({
    super.key,
    required this.onTap,
    this.image,
    this.error,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final int imageSizeInBytes = image?.lengthSync() ?? 0;
    final double sizeInKB = imageSizeInBytes / 1024;
    final double sizeInMB = imageSizeInBytes / 1024 / 1024;

    String getImageSize() {
      if (sizeInMB >= 1) {
        return '${sizeInMB.toStringAsFixed(2)} MB';
      } else {
        return '${sizeInKB.toStringAsFixed(2)} KB';
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (image != null)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(
                color: AppColors.mutedForeground.withOpacity(0.3),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    image!,
                    width: 75,
                    height: 75,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Image téléchargée',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.foreground,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        getImageSize(),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: onRemove,
                  color: Colors.grey.shade600,
                  tooltip: 'Changer l\'image',
                ),
              ],
            ),
          )
        else
          GestureDetector(
            onTap: onTap,
            child: DottedBorder(
              options: RoundedRectDottedBorderOptions(
                dashPattern: [5, 5],
                strokeWidth: 2,
                padding: EdgeInsets.all(0),
                color: AppColors.border,
                radius: Radius.circular(14),
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 32, horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.Primary100,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: CustomIcon(
                        path: 'assets/icons/image.svg',
                        width: 26,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 16),

                    RichText(
                      text: TextSpan(
                        text: 'Cliquer ',
                        style: TextStyle(
                          fontSize: AppTypography.body,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                        children: [
                          TextSpan(
                            text: 'pour télécharger une image',
                            style: TextStyle(
                              fontSize: AppTypography.body,
                              color: AppColors.foreground,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
