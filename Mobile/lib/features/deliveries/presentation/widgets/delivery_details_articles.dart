import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/details_article_card.dart';

class DeliveryDetailsArticles extends StatelessWidget {
  const DeliveryDetailsArticles({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text('Articles', style: TextStyle(fontSize: AppTypography.h4 - 1)),

          const SizedBox(height: 24),

          Column(
            children: [
              DetailsArticleCard(articleName: 'Jean slim bleu', price: 50000),
            ],
          ),
        ],
      ),
    );
  }
}
