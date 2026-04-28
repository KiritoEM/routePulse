import 'package:flutter/material.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

class DeliveryDetailsSkeleton extends StatelessWidget {
  const DeliveryDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      clipBehavior: Clip.none,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      child: Column(
        children: [
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 16,
            children: [
              SkeletonLine(
                style: SkeletonLineStyle(
                  height: 28,
                  width: 145,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              SkeletonLine(
                style: SkeletonLineStyle(
                  height: 32,
                  width: 100,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Details card skeleton
          SkeletonLine(
            style: SkeletonLineStyle(
              height: 275,
              width: double.infinity,
              borderRadius: BorderRadius.circular(24),
            ),
          ),

          const SizedBox(height: 40),

          SkeletonLine(
            style: SkeletonLineStyle(
              height: 200,
              width: double.infinity,
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ],
      ),
    );
  }
}
