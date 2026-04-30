import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:route_pulse_mobile/core/constants/router_constant.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/features/vehicle/domain/entities/vehicle.dart';
import 'package:route_pulse_mobile/features/vehicle/presentation/notifiers/get_vehicles_list_notifier.dart';
import 'package:route_pulse_mobile/features/vehicle/presentation/widgets/create_vehicle_bottomsheet.dart';
import 'package:route_pulse_mobile/features/vehicle/presentation/widgets/empty_vehicles.dart';
import 'package:route_pulse_mobile/features/vehicle/presentation/widgets/vehicle_actions_bottomsheet.dart';
import 'package:route_pulse_mobile/features/vehicle/presentation/widgets/vehicle_card.dart';
import 'package:route_pulse_mobile/features/vehicle/presentation/widgets/vehicles_list_skeletons.dart';
import 'package:route_pulse_mobile/shared/services/sync_orchestrator.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';

class VehicleScreen extends ConsumerStatefulWidget {
  const VehicleScreen({super.key});

  @override
  ConsumerState<VehicleScreen> createState() => _VehicleScreenState();
}

class _VehicleScreenState extends ConsumerState<VehicleScreen> {
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
          ref.read(getVehiclesListProvider.notifier).startLoading();
          await SyncOrchestrator().syncAll();
          ref.read(getVehiclesListProvider.notifier).refetch();
        }

        return;
      }

      // Sync when connection status change
      if (isOnline) {
        ref.read(getVehiclesListProvider.notifier).startLoading();
        await SyncOrchestrator().syncAll();
        ref.read(getVehiclesListProvider.notifier).refetch();
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
    final vehiclesListState = ref.watch(getVehiclesListProvider);

    final List<Vehicle> data = vehiclesListState is HttpSuccess
        ? vehiclesListState.data.cast<Vehicle>()
        : [];

    return Scaffold(
      backgroundColor: AppColors.grayBg,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 4,
        leading: IconButton(
          onPressed: () {
            context.canPop()
                ? context.pop(true)
                : context.go(RouterConstant.HOME_ROUTE);
          },
          icon: CustomIcon(path: 'assets/icons/chevron-left.svg', width: 28),
        ),
        title: Text(
          'Véhicules',
          style: TextStyle(
            fontSize: AppTypography.h5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildBody(vehiclesListState),
            ],
          ),
        ),
      ),
      floatingActionButton: data.isNotEmpty
          ? FloatingActionButton(
              backgroundColor: AppColors.primary,
              onPressed: () => CreateVehicleBottomsheet().show(context),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildBody(HttpState vehiclesListState) {
    return switch (vehiclesListState) {
      HttpInitial() || HttpLoading() => const VehiclesListSkeletons(),
      HttpError(:final message) => Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.error),
        ),
      ),
      HttpSuccess(:final data as List<Vehicle>) =>
        data.isEmpty
            ? EmptyVehicles(
                onCreate: () => CreateVehicleBottomsheet().show(context),
              )
            : Column(
                spacing: 20,
                children: List.generate(
                  data.length,
                  (index) => VehicleCard(
                    vehicleType: data[index].type,
                    vehicleName: data[index].name,
                    plateNumber: data[index].plateNumber,
                    isActive: data[index].isActive,
                    onTapMenu: () =>
                        VehicleActionsBottomsheet().show(context, data[index]),
                  ),
                ),
              ),
      _ => const SizedBox.shrink(),
    };
  }
}
