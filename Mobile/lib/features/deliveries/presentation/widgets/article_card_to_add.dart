import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';

class ArticleCardToAdd extends StatelessWidget {
  final int index;
  final String articleName;
  final int price;
  final String? image;
  final VoidCallback onRemove;

  const ArticleCardToAdd({
    super.key,
    required this.index,
    required this.articleName,
    required this.price,
     this.image,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: image != null
            ? Container(
                width: 54,
                height: 54,
                color: AppColors.surface,
                child: Image.memory(
                  base64Decode(image!),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.shopping_basket,
                      size: 30,
                      color: AppColors.mutedForeground,
                    );
                  },
                ),
              )
            : Container(
                width: 54,
                height: 54,
                color: AppColors.surface,
                child: Icon(
                  Icons.shopping_basket,
                  size: 30,
                  color: AppColors.mutedForeground,
                ),
              ),
      ),

      title: Text(
        articleName,
        style: TextStyle(fontSize: AppTypography.body, fontWeight: .w500),
      ),
      subtitle: Text(
        '$price Ar',
        style: TextStyle(color: AppColors.mutedForeground),
      ),

      trailing: IconButton(
        onPressed: () => onRemove(),
        icon: CustomIcon(
          path: 'assets/icons/trash.svg',
          width: 22,
          color: AppColors.error,
        ),
      ),
    );
  }
}
