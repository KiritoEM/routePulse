import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';

enum NetworkErrorType {
  unknown,
  network,
  server,
  badRequest,
  notFound,
  forbidden,
  unauthorized,
  client,
  canceled,
  conflict,
  tooManyRequest,
}

enum JwtVerifyResult { expired, success, error }

enum DeliveryStatus {
  all('Toutes', 'all', AppColors.primary),
  pending('En attente', 'pending', AppColors.mutedForeground),
  inProgress('En cours', 'in_progress', AppColors.info),
  delivered('Livrées', 'delivered', AppColors.success),
  reported('À reporter', 'reported', AppColors.warning),
  cancelled('Annulée', 'cancelled', AppColors.error);

  final String label;
  final String value;
  final Color color;

  const DeliveryStatus(this.label, this.value, this.color);

  static DeliveryStatus fromValue(String value) {
    return DeliveryStatus.values.firstWhere(
      (e) => e.value.toString().toLowerCase() == value.toLowerCase(),
      orElse: () => DeliveryStatus.inProgress,
    );
  }
}

enum VehicleType {
  moto('Moto', 'moto'),
  bicycle('Vélo', 'bicycle'),
  car('Voiture', 'car');

  final String label;
  final String value;

  const VehicleType(this.label, this.value);

  static VehicleType fromValue(String value) {
    return VehicleType.values.firstWhere(
      (e) => e.value.toLowerCase() == value.toLowerCase(),
      orElse: () => VehicleType.moto,
    );
  }

  static List<VehicleType> get valuesList => VehicleType.values;
}

enum SortFilterEnum {
  creationDate('Date de création', 'creation_date'),
  timeSlot('Créneau horaire', 'time_slot');

  final String label;
  final String value;

  const SortFilterEnum(this.label, this.value);

  static SortFilterEnum fromValue(String value) {
    return SortFilterEnum.values.firstWhere(
      (e) => e.value.toLowerCase() == value.toLowerCase(),
      orElse: () => SortFilterEnum.creationDate,
    );
  }
}
