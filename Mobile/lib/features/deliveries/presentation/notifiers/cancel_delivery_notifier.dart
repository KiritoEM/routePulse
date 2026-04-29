import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/features/deliveries/data/deliveries_repository_impl.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/notifiers/delivery_details_notifier.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';

part 'cancel_delivery_notifier.g.dart';

@riverpod
class CancelDeliveryNotifier extends _$CancelDeliveryNotifier {
  final _deliveryRepository = DeliveriesRepositoryImpl();

  @override
  HttpState build() => const HttpState.init();

  Future<void> submit(String id, String reason) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      state = HttpState.loading();

      final response = await _deliveryRepository.cancelDelivery(id, reason);
      if (response.isSucess) {
        final deliveryDetailsVm = ref.read(
          deliveryDetailsProvider(id).notifier,
        );

        await deliveryDetailsVm.refetch(id);

        state = HttpState.success(message: response.message);

        return;
      }

      state = HttpState.error(
        errorType: response.errorType ?? NetworkErrorType.server,
        message: response.message ?? "Impossible d'annuler la livraison",
      );
    });
  }
}
