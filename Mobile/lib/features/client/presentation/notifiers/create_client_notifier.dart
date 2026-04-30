import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/features/client/data/client_repository_impl.dart';
import 'package:route_pulse_mobile/features/client/presentation/states/create_client_state.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';

part 'create_client_notifier.g.dart';

@riverpod
class CreateClientNotifier extends _$CreateClientNotifier {
  final _clientRepository = ClientRepositoryImpl();

  CreateClientState _client = const CreateClientState(name: '');
  final _formKey = GlobalKey<FormState>();

  GlobalKey<FormState> get formKey => _formKey;

  @override
  HttpState build() => const HttpState.init();

  void setName(String name) {
    _client = _client.copyWith(name: name);
  }

  void setPhoneNumber(String? phoneNumber) {
    _client = _client.copyWith(phoneNumber: phoneNumber);
  }

  void setAddress(String? address) {
    _client = _client.copyWith(address: address);
  }

  void setLocation(List<double> location) {
    _client = _client.copyWith(location: location);
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    state = const HttpState.loading();

    final response = await _clientRepository.createClient(_client, false);

    if (response.isSucess) {
      state = HttpState.success(data: response.data);
      return;
    }

    state = HttpState.error(
      errorType: response.errorType ?? NetworkErrorType.server,
      message: response.message ?? 'Impossible de créer le client',
    );
  }
}
