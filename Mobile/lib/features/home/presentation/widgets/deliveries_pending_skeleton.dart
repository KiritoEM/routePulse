import 'package:flutter/material.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

class DeliveriesPendingSkeleton extends StatelessWidget {
  const DeliveriesPendingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        7,
        (index) => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLine(
                style: SkeletonLineStyle(
                  height: 32,
                  width: 80,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              const SizedBox(height: 8),

              const SkeletonLine(
                style: SkeletonLineStyle(
                  height: 20,
                  width: 120,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ),

              const SizedBox(height: 22),

              SkeletonLine(
                style: SkeletonLineStyle(
                  height: 1,
                  width: double.infinity,
                  borderRadius: BorderRadius.zero,
                ),
              ),

              const SizedBox(height: 22),

              Wrap(
                spacing: 20,
                runSpacing: 8,
                direction: Axis.horizontal,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      SizedBox(width: 8),
                      SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 18,
                          width: 18,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                      SizedBox(width: 8),
                      SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 16,
                          width: 100,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      SizedBox(width: 8),
                      SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 18,
                          width: 18,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                      SizedBox(width: 8),
                      SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 16,
                          width: 80,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
