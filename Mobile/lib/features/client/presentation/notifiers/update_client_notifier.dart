import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/features/client/data/client_repository_impl.dart';
import 'package:route_pulse_mobile/features/client/presentation/states/update_client_state.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';

part 'update_client_notifier.g.dart';

@riverpod
class UpdateClientNotifier extends _$UpdateClientNotifier {
  final _clientRepository = ClientRepositoryImpl();

  UpdateClientState _client = const UpdateClientState();
  final _formKey = GlobalKey<FormState>();

  GlobalKey<FormState> get formKey => _formKey;

  @override
  HttpState build() => const HttpState.init();

  void init(UpdateClientState initial) {
    _client = initial;
  }

  void setName(String name) {
    _client = _client.copyWith(name: name);
  }

  void setPhoneNumber(String phoneNumber) {
    _client = _client.copyWith(phoneNumber: phoneNumber);
  }

  void setAddress(String address) {
    _client = _client.copyWith(address: address);
  }

  void setCity(String city) {
    _client = _client.copyWith(city: city);
  }

  void setLocation(List<double> location) {
    _client = _client.copyWith(location: location);
  }

  Future<void> submit(String clientId) async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    state = const HttpState.loading();

    final response = await _clientRepository.updateClient(clientId, _client);

    if (response.isSucess) {
      state = HttpState.success(data: response.data);
      return;
    }

    state = HttpState.error(
      errorType: response.errorType ?? NetworkErrorType.server,
      message: response.message ?? 'Impossible de mettre à jour le client',
    );
  }
}
