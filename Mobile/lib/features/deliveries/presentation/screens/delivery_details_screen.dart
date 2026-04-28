import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/notifiers/delivery_details_notifier.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/delivery_details_appbar.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/delivery_details_articles.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/delivery_details_card.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/delivery_details_skeleton.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';

class DeliveryDetailsScreen extends ConsumerWidget {
  final String deliveryId;

  const DeliveryDetailsScreen({super.key, required this.deliveryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliveryDetailsState = ref.watch(deliveryDetailsProvider(deliveryId));

    return Scaffold(
      backgroundColor: AppColors.grayBg,
      appBar: DeliveryDetailsAppbar(onOpenMenu: () {}),
      body: SafeArea(
        child: Column(
          children: [
            // Expanded(child: _buildBody(delliveryDetailsState)),
            Expanded(child: _buildBody(deliveryDetailsState)),

            // bottom CTA
            _buildBottomCta(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomCta() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 72, 16, 24),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.0),
            Colors.white.withOpacity(0.7),
            Colors.white.withOpacity(0.8),
            Colors.white.withOpacity(1.0),
          ],
          stops: [0.0, 0.25, 0.7, 0.9],
        ),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          spacing: 12,
          children: [
            SizedBox(
              height: 55,
              child: IconButton(
                onPressed: () {},
                style: IconButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  backgroundColor: AppColors.secondaryButtonBg,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: CustomIcon(path: 'assets/icons/location.svg', width: 24),
              ),
            ),

            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Valider la livraison'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(HttpState deliveryDetailsState) {
    return switch (deliveryDetailsState) {
      HttpInitial() || HttpLoading() => DeliveryDetailsSkeleton(),
      HttpError(:final message) => Center(
        child: Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.error),
          ),
        ),
      ),
      HttpSuccess(:final data) => SingleChildScrollView(
        clipBehavior: Clip.none,
        padding: EdgeInsets.fromLTRB(16, 0, 16, 32),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 16,
              children: [
                Expanded(
                  child: Text(
                    data.deliveryId,
                    style: TextStyle(fontSize: AppTypography.h5),
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                  decoration: BoxDecoration(
                    color: data.status.color,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    data.status.label,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppTypography.small + 1.5,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // details card
            DeliveryDetailsCard(
              address: data.address,
              timeSlotStart: data.timeSlotStart,
              timeSlotEnd: data.timeSlotEnd,
              notes: data.notes,
              clientName: data.client.name,
              phoneNumber: data.client.phoneNumber,
            ),

            const SizedBox(height: 40),

            // articles list
            DeliveryDetailsArticles(articles: data.articles),
          ],
        ),
      ),
      _ => const SizedBox.shrink(),
    };
  }
}
