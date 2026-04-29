import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/features/home/presentation/notifiers/deliveries_count_notifier.dart';
import 'package:route_pulse_mobile/features/home/presentation/notifiers/deliveries_pending_notifier.dart';
import 'package:route_pulse_mobile/features/home/presentation/widgets/next_deliveries_section.dart';
import 'package:route_pulse_mobile/features/home/presentation/widgets/quick_actions.dart';
import 'package:route_pulse_mobile/features/home/presentation/widgets/stat_card.dart';
import 'package:route_pulse_mobile/shared/services/sync_orchestrator.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';
import 'package:route_pulse_mobile/shared/widgets/app_bottom_navigation.dart';
import 'package:route_pulse_mobile/shared/widgets/app_drawer.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:route_pulse_mobile/shared/widgets/drawer_opener.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
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
          ref.read(deliveriesCountProvider.notifier).startLoading();
          await SyncOrchestrator().syncAll();
          ref.read(deliveriesCountProvider.notifier).refetch();
          ref.read(deliveriesPendingProvider.notifier).startLoading();
          await SyncOrchestrator().syncAll();
          ref.read(deliveriesPendingProvider.notifier).refetch();
        }

        return;
      }

      // Sync when connection status change
      if (isOnline) {
        ref.read(deliveriesCountProvider.notifier).startLoading();
        await SyncOrchestrator().syncAll();
        ref.read(deliveriesCountProvider.notifier).refetch();
        ref.read(deliveriesPendingProvider.notifier).startLoading();
        await SyncOrchestrator().syncAll();
        ref.read(deliveriesPendingProvider.notifier).refetch();
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
    final deliveriesCountState = ref.watch(deliveriesCountProvider);

    return Scaffold(
      backgroundColor: AppColors.grayBg,
      drawer: MainAppDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Padding(
          child: CustomIcon(
            path: 'assets/icons/route_pulse-logo.svg',
            color: AppColors.primary,
            width: 152,
          ),
          padding: EdgeInsets.only(left: 16),
        ),

        actions: [
          Padding(
            child: DrawerOpener(),
            padding: EdgeInsets.only(right: 16),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          clipBehavior: .none,
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 24),

              deliveriesCountState is HttpLoading ||
                      deliveriesCountState is HttpInitial
                  ? _buildStatsSkeleton()
                  : IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: 14,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 7),
                              child: StatCard(
                                label: 'Livraisons à faire',
                                value: deliveriesCountState is HttpSuccess
                                    ? deliveriesCountState.data['pending'] ?? 0
                                    : 0,
                                color: const Color(0xFF19C5FA),
                                icon: CustomIcon(
                                  path: 'assets/icons/bicycle.svg',
                                  width: 28,
                                  color: const Color(0xFF19C5FA),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 7),
                              child: StatCard(
                                label: 'Livraisons terminées',
                                value: deliveriesCountState is HttpSuccess
                                    ? deliveriesCountState.data['delivered'] ??
                                          0
                                    : 0,
                                color: const Color(0xFFD719FA),
                                icon: CustomIcon(
                                  path: 'assets/icons/double-check.svg',
                                  width: 28,
                                  color: const Color(0xFFD719FA),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              const SizedBox(height: 40),

              // quick actions
              QuickActions(),

              const SizedBox(height: 28),

              NextDeliveriesSection(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),

      bottomNavigationBar: AppBottomNavigation(),
    );
  }

  Widget _buildStatsSkeleton() {
    return Row(
      spacing: 14,
      children: [
        Expanded(
          child: SkeletonLine(
            style: SkeletonLineStyle(
              height: 200,
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
        Expanded(
          child: SkeletonLine(
            style: SkeletonLineStyle(
              height: 200,
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
      ],
    );
  }
}
