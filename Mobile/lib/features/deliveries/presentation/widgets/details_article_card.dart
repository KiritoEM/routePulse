import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';

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
        child: image != null
            ? Container(
                width: 45,
                height: 45,
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
                width: 45,
                height: 45,
                color: AppColors.surface,
                child: Icon(
                  Icons.shopping_basket,
                  size: 30,
                  color: AppColors.mutedForeground,
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
