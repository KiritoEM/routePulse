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
  inProgress('En cours', 'in_progress', AppColors.info),
  delivered('Livrées', 'delivered', AppColors.success),
  reported('À reporter', 'reported', AppColors.warning),
  cancelled('Annulée', 'cancelled', AppColors.error);

  final String label;
  final String value;
  final Color color;

  const DeliveryStatus(this.label, this.value, this.color);
}
