import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:route_pulse_mobile/core/constants/router_constant.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/features/client/domain/entities/client.dart';
import 'package:route_pulse_mobile/features/client/presentation/notifiers/get_clients_list_notifier.dart';
import 'package:route_pulse_mobile/features/client/presentation/widgets/client_actions_bottomsheet.dart';
import 'package:route_pulse_mobile/features/client/presentation/widgets/client_card.dart';
import 'package:route_pulse_mobile/features/client/presentation/widgets/create_client_bottomsheet.dart';
import 'package:route_pulse_mobile/features/client/presentation/widgets/empty_clients.dart';
import 'package:route_pulse_mobile/features/vehicle/presentation/widgets/vehicles_list_skeletons.dart';
import 'package:route_pulse_mobile/shared/services/sync_orchestrator.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';

class ClientsScreen extends ConsumerStatefulWidget {
  const ClientsScreen({super.key});

  @override
  ConsumerState<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends ConsumerState<ClientsScreen> {
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
          ref.read(getClientsListProvider.notifier).startLoading();
          await SyncOrchestrator().syncAll();
          ref.read(getClientsListProvider.notifier).refetch();
        }

        return;
      }

      // Sync when connection status change
      if (isOnline) {
          ref.read(getClientsListProvider.notifier).startLoading();
          await SyncOrchestrator().syncAll();
          ref.read(getClientsListProvider.notifier).refetch();
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
    final clientsListState = ref.watch(getClientsListProvider);

    final List<Client> data = clientsListState is HttpSuccess
        ? clientsListState.data.cast<Client>()
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
          'Clients',
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
              _buildBody(clientsListState),
            ],
          ),
        ),
      ),
      floatingActionButton: data.isNotEmpty
          ? FloatingActionButton(
              backgroundColor: AppColors.primary,
              onPressed: () => CreateClientBottomsheet().show(context),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildBody(HttpState clientsListState) {
    return switch (clientsListState) {
      HttpInitial() || HttpLoading() => const VehiclesListSkeletons(),
      HttpError(:final message) => Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.error),
        ),
      ),
      HttpSuccess(:final data as List<Client>) =>
        data.isEmpty
            ? EmptyClients(
                onCreate: () => CreateClientBottomsheet().show(context),
              )
            : Column(
                spacing: 20,
                children: List.generate(
                  data.length,
                  (index) => ClientCard(
                    name: data[index].name,
                    phoneNumber: data[index].phoneNumber,
                    address: data[index].address,
                    onTapMenu: () =>
                        ClientActionsBottomsheet().show(context, data[index]),
                  ),
                ),
              ),
      _ => const SizedBox.shrink(),
    };
  }
}
