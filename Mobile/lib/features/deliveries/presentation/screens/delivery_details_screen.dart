import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/delivery_details_appbar.dart';

class DeliveryDetailsScreen extends ConsumerWidget {
  const DeliveryDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(appBar: DeliveryDetailsAppbar(onOpenMenu: () {}));
  }
}
