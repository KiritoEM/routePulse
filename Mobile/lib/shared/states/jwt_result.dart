import 'package:route_pulse_mobile/core/constants/enums/enums.dart';

class JwtResult {
  final JwtVerifyResult result;
  final Map<String, dynamic>? payload;

  const JwtResult({required this.result, this.payload});
}
