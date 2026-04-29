import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/core/utils/app_logger.dart';
import 'package:route_pulse_mobile/features/deliveries/domain/entities/delivery.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/notifiers/delivery_details_notifier.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/delivery_details_appbar.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/delivery_details_articles.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/delivery_details_card.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/delivery_details_skeleton.dart';
import 'package:route_pulse_mobile/shared/services/sync_orchestrator.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';

class DeliveryDetailsScreen extends ConsumerStatefulWidget {
  final String deliveryId;

  const DeliveryDetailsScreen({super.key, required this.deliveryId});

  @override
  ConsumerState<DeliveryDetailsScreen> createState() =>
      _DeliveryDetailsScreenState();
}

class _DeliveryDetailsScreenState extends ConsumerState<DeliveryDetailsScreen> {
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _isFirstCheck = true;

  void _listenToConnectivityChanges() {
    _subscription = Connectivity().onConnectivityChanged.listen((result) async {
      if (!mounted) return;

      final bool isOnline = result.any((r) => r != ConnectivityResult.none);

      if (_isFirstCheck) {
        _isFirstCheck = false;

        // First Sync if online
        if (isOnline) {
          ref
              .read(deliveryDetailsProvider(widget.deliveryId).notifier)
              .startLoading();
          await SyncOrchestrator().syncAll();
          ref
              .read(deliveryDetailsProvider(widget.deliveryId).notifier)
              .refetch(widget.deliveryId);
        }

        return;
      }

      // Sync when connection status change
      if (isOnline) {
        ref
            .read(deliveryDetailsProvider(widget.deliveryId).notifier)
            .startLoading();
        await SyncOrchestrator().syncAll();
        ref
            .read(deliveryDetailsProvider(widget.deliveryId).notifier)
            .refetch(widget.deliveryId);
      }

      _showConnectivitySnackBar(isOnline);
    });
  }

  void _showConnectivitySnackBar(bool isOnline) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isOnline ? 'Connexion rétablie' : 'Pas de connexion Internet',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: isOnline ? AppColors.info : AppColors.border,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _listenToConnectivityChanges();
  }

  @override
  void dispose() {
    super.dispose();

    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final deliveryDetailsState = ref.watch(
      deliveryDetailsProvider(widget.deliveryId),
    );

    final bool isLoading = deliveryDetailsState is HttpLoading;
    final bool hasError = deliveryDetailsState is HttpError;
    final Delivery? data = deliveryDetailsState is HttpSuccess
        ? deliveryDetailsState.data as Delivery
        : null;

    return Scaffold(
      backgroundColor: AppColors.grayBg,
      appBar: DeliveryDetailsAppbar(onOpenMenu: () {}),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildBody(deliveryDetailsState)),
            _buildBottomCta(
              disabledLocationBtn: isLoading || hasError,
              disabledMainBtn:
                  data?.status != DeliveryStatus.pending &&
                  data?.status != DeliveryStatus.inProgress,
              label: data?.status == DeliveryStatus.pending
                  ? 'Démarrer la livraison'
                  : 'Valider la livraison',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomCta({
    bool disabledLocationBtn = false,
    bool disabledMainBtn = false,
    String label = 'Valider la livraison',
  }) {
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
                onPressed: disabledLocationBtn ? null : () {},
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
                onPressed: disabledMainBtn ? null : () {},
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
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.error),
        ),
      ),
      HttpSuccess(:final data as Delivery) => SingleChildScrollView(
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

            if (data.cancelReason != null && data.cancelReason!.isNotEmpty) ...[
              const SizedBox(height: 40),

              // cancel reason
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      'Motif d\'annulation',
                      style: TextStyle(
                        fontSize: AppTypography.h5,
                        color: AppColors.error,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      data.cancelReason!,
                      style: TextStyle(color: AppColors.foreground),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      _ => const SizedBox.shrink(),
    };
  }
}
