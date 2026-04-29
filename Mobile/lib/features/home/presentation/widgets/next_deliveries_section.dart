import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:route_pulse_mobile/core/constants/router_constant.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';

class NextDeliveriesSection extends ConsumerWidget {
  const NextDeliveriesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            spacing: 8,
            mainAxisAlignment: .spaceBetween,
            crossAxisAlignment: .center,
            children: [
              Text(
                'Prochaines livraisons',
                style: TextStyle(fontSize: AppTypography.h5),
              ),

              IntrinsicWidth(
                child: TextButton(
                  onPressed: () => context.go(RouterConstant.DELIVERIES_ROUTE),
                  child: Text(
                    'Voir tout',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: .w600,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Column(spacing: 16, children: []),
        ],
      ),
    );
  }
}
