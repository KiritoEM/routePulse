import 'package:flutter/material.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

class DeliveriesListSkeleton extends StatelessWidget {
  const DeliveriesListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 7,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (_, _) {
        return Container(
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
                    spacing: 8,
                    children: [
                      const SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 18,
                          width: 18,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                      const SkeletonLine(
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
                    spacing: 8,
                    children: [
                      const SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 18,
                          width: 18,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                      const SkeletonLine(
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
        );
      },
    );
  }
}
