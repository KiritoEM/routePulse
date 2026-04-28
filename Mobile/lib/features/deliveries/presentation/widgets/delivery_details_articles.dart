import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/features/deliveries/domain/entities/delivery_item.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/details_article_card.dart';

class DeliveryDetailsArticles extends StatelessWidget {
  final List<DeliveryItem> articles;

  const DeliveryDetailsArticles({super.key, required this.articles});

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
            children: articles
                .map<Widget>(
                  (item) => DetailsArticleCard(
                    articleName: item.name,
                    price: item.price?.toInt() ?? 0,
                    image: item.image?.file,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
