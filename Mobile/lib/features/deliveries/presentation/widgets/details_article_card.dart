import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

class DetailsArticleCard extends StatelessWidget {
  final String articleName;
  final int price;
  final String? image;

  const DetailsArticleCard({
    super.key,
    required this.articleName,
    required this.price,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        articleName,
        style: TextStyle(fontSize: AppTypography.body + 1, fontWeight: .w500),
        maxLines: 2,
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 45,
          height: 45,
          color: AppColors.surface,
          child: Image.network(
            image ?? '',
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return SkeletonLine(
                style: SkeletonLineStyle(
                  height: double.infinity,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            },

            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.shopping_basket,
                size: 24,
                color: AppColors.mutedForeground,
              );
            },
          ),
        ),
      ),
      trailing: Text(
        '$price Ar',
        style: TextStyle(
          color: AppColors.mutedForeground,
          fontSize: AppTypography.body,
        ),
      ),
    );
  }
}
