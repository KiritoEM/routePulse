import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:route_pulse_mobile/core/constants/router_constants.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';

class AppBottomNavigation extends StatefulWidget {
  final Widget child;

  const AppBottomNavigation({super.key, required this.child});

  @override
  State<AppBottomNavigation> createState() => _ScaffoldNavigationBarState();
}

class _ScaffoldNavigationBarState extends State<AppBottomNavigation> {
  int _currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateCurrentIndex();
  }

  void _updateCurrentIndex() {
    final location = GoRouterState.of(context).uri.toString();

    int newIndex = 1;
    RouterConstant.BOTTOM_NAVIGATION_ROUTES.asMap().entries.map((entry) {
      final int index = entry.key;
      final route = entry.value;

      if (location.startsWith(route['route'])) {
        newIndex = index;
      }
    });

    if (_currentIndex != newIndex) {
      setState(() => _currentIndex = newIndex);
    }
  }

  void _handleChangeTab(int index) {
    if (index < 3) {
      setState(() => _currentIndex = index);

      final routes = RouterConstant.BOTTOM_NAVIGATION_ROUTES
          .map((route) => route['route'])
          .toList();
      context.go(routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              offset: Offset(0, -2),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: NavigationBar(
          elevation: 0,
          selectedIndex: _currentIndex,
          onDestinationSelected: _handleChangeTab,
          backgroundColor: Colors.white,
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.selected)) {
              return TextStyle(
                color: AppColors.primary,
		fontSize: AppTypography.small
              );
            }
            return TextStyle(color: AppColors.mutedForeground, fontSize: AppTypography.small);
          }),
          indicatorColor: AppColors.primary,
          destinations: RouterConstant.BOTTOM_NAVIGATION_ROUTES
              .asMap()
              .entries
              .map((entry) {
                final index = entry.key;
                final route = entry.value;
                final isSelected = _currentIndex == index;

                return NavigationDestination(
                  icon: SvgPicture.asset(
                    route['icon'],
                    width: route['icon_width'],
                    colorFilter: ColorFilter.mode(
                      isSelected ? Colors.white : AppColors.mutedForeground,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: route['label'],
                );
              })
              .toList(),
        ),
      ),
    );
  }
}
