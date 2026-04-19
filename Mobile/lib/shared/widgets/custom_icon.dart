import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';

class CustomIcon extends StatelessWidget {
  final String path;
  final Color? color;
  final double? width;

  const CustomIcon({super.key, required this.path, this.color, this.width});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      width: width ?? 26,
      colorFilter: ColorFilter.mode(
        color ?? AppColors.foreground,
        BlendMode.srcIn,
      ),
    );
  }
}
