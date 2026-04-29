import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
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
import 'package:route_pulse_mobile/shared/states/http_state.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';

class VehicleScreen extends ConsumerWidget {
  const VehicleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          style: TextStyle(fontSize: AppTypography.h5, fontWeight: .w500),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          clipBehavior: .none,
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildBody(context, vehiclesListState),
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

  Widget _buildBody(BuildContext context, HttpState vehiclesListState) {
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
            ? EmptyVehicles()
            : Column(
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
