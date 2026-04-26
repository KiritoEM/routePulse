import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:route_pulse_mobile/core/constants/router_constant.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/notifiers/create_delivery_notifier.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/states/create_delivery_state.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/article_card_to_add.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/create_article_bottomsheet.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';

class AddArticlesSection extends ConsumerWidget {
  const AddArticlesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createDeliveryVm = ref.read(createDeliveryProvider.notifier);
    final createDeliveryState = ref.watch(createDeliveryProvider);

    final bool isListEmpty = createDeliveryState.articles.isEmpty;

    return Column(
      children: [
        // header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 8,
          children: [
            Text(
              'Articles',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: AppTypography.h5,
              ),
            ),
            IntrinsicWidth(
              child: TextButton(
                onPressed: () => CreateArticleBottomsheet().show(context, ref, (
                  DeliveryArticle data,
                ) {
                  createDeliveryVm.addArticle(data);
                }),
                child: Text(
                  'Ajouter',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),

        // Articles list
        !isListEmpty
            ? _buildList(
                createDeliveryState.articles,
                (index) => createDeliveryVm.removeArticle(index),
              )
            : Padding(
                padding: EdgeInsets.only(top: 8),
                child: _buildEmptyState(),
              ),

        const SizedBox(height: 40),

        ElevatedButton(
          onPressed: isListEmpty
              ? null
              : () {
                  // navigate to next step
                  context.push(RouterConstant.CREATE_DELIVERY_STEP4);
                },
          child: Text('Continuer'),
        ),
      ],
    );
  }

  Widget _buildList(
    List<DeliveryArticle> articles,
    Function(int index) onRemove,
  ) {
    return Column(
      spacing: 12,
      children: articles.asMap().entries.map((entry) {
        final index = entry.key;
        final article = entry.value;

        return ArticleCardToAdd(
          image: article.file?.file,
          index: index,
          articleName: article.name,
          price: article.price.toInt(),
          onRemove: () => onRemove(index),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.Primary100,
            borderRadius: BorderRadius.circular(50),
          ),
          padding: EdgeInsets.all(16),
          child: CustomIcon(
            path: 'assets/icons/package-filled.svg',
            width: 40,
            color: AppColors.primary,
          ),
        ),

        Text(
          'Aucun article ajouté',
          style: TextStyle(
            color: AppColors.mutedForeground,
            fontSize: AppTypography.body,
          ),
        ),
      ],
    );
  }
}
