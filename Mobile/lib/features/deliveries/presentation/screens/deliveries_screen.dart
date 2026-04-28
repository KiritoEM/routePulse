import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/core/constants/router_constant.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/features/deliveries/domain/entities/delivery.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/notifiers/deliveries_filter_notifier.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/notifiers/deliveries_list_notifier.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/deliveries_appbar.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/deliveries_list_skeleton.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/delivery_card.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/empty_deliveries.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/filter_bottomsheet.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/status_filter.dart';
import 'package:route_pulse_mobile/shared/services/sync_orchestrator.dart';
import 'package:route_pulse_mobile/shared/widgets/app_bottom_navigation.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';

class DeliveriesScreen extends ConsumerStatefulWidget {
  const DeliveriesScreen({super.key});

  @override
  ConsumerState<DeliveriesScreen> createState() => _DeliveriesScreenState();
}

class _DeliveriesScreenState extends ConsumerState<DeliveriesScreen> {
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _isFirstCheck = true;

  void _listenToConnectivityChanges() {
    _subscription = Connectivity().onConnectivityChanged.listen((result) async {
      if (!mounted) return;

      final bool isOnline = result.any((r) => r != ConnectivityResult.none);

      if (_isFirstCheck) {
        _isFirstCheck = false;
        return;
      }

      _showConnectivitySnackBar(isOnline);

      if (isOnline) {
        // Sync offline/online
        ref.read(deliveriesListProvider.notifier).startLoading();
        await SyncOrchestrator().syncAll();
        ref.read(deliveriesListProvider.notifier).refetch();
      }
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
    final deliveriesListState = ref.watch(deliveriesListProvider);
    final deliveriesFilterState = ref.watch(deliveriesFilterProvider);
    final deliveriesFilterVm = ref.read(deliveriesFilterProvider.notifier);
    final DeliveryStatus currentStatus = deliveriesFilterState['status'];

    final List<Delivery> data = deliveriesListState is HttpSuccess
        ? deliveriesListState.data.cast<Delivery>()
        : [];

    return Scaffold(
      backgroundColor: AppColors.grayBg,
      appBar: DeliveriesAppbar(
        onFilter: () {
          FilterBottomsheet.show(
            context,
            deliveriesFilterState['sort'],
            (SortFilterEnum? sortFilter) {
              deliveriesFilterVm.setFilter(sort: sortFilter);
            },
            () {
              deliveriesFilterVm.setFilter(sort: null);
            },
          );
        },
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          StatusFilter(
            selectedStatus: currentStatus,
            onSelect: (DeliveryStatus status) {
              deliveriesFilterVm.setFilter(status: status);
            },
          ),
          const SizedBox(height: 32),
          Expanded(child: _buildBody(deliveriesListState, currentStatus)),
        ],
      ),
      bottomNavigationBar: AppBottomNavigation(),
      floatingActionButton: data.isNotEmpty
          ? FloatingActionButton(
              backgroundColor: AppColors.primary,
              onPressed: () => context.go(RouterConstant.CREATE_DELIVERY_STEP1),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildBody(dynamic deliveriesListState, DeliveryStatus currentStatus) {
    return switch (deliveriesListState) {
      HttpInitial() || HttpLoading() => const DeliveriesListSkeleton(),
      HttpError(:final message) => Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.error),
        ),
      ),
      HttpSuccess(:final data) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: data.isEmpty
            ? EmptyDeliveries(isFiltered: currentStatus != DeliveryStatus.all)
            : ListView.separated(
                itemCount: data.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final delivery = data[index];
                  return DeliveryCard(
                    deliveryId: delivery.deliveryId,
                    status: delivery.status,
                    timeSlotStart: delivery.timeSlotStart,
                    timeSlotEnd: delivery.timeSlotEnd,
                    clientName: delivery.client.name,
                    city: delivery.city,
                  );
                },
              ),
      ),
      _ => const SizedBox.shrink(),
    };
  }
}
