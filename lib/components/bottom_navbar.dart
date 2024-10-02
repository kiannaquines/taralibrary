import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taralibrary/utils/colors.dart';

class BottomNavbar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) selectedIndexFunc;

  const BottomNavbar({
    super.key,
    required this.selectedIndex,
    required this.selectedIndexFunc,
  });

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  final List<Map<String, String>> _navDestinations = [
    {
      'icon': 'home',
      'selectedIcon': 'home-solid',
      'label': 'Home',
    },
    {
      'icon': 'map-marker',
      'selectedIcon': 'map-marker-solid',
      'label': 'Navigation',
    },
    {
      'icon': 'user',
      'selectedIcon': 'user-solid',
      'label': 'Profile',
    },
    {
      'icon': 'sign-out-alt-outline',
      'selectedIcon': 'sign-out-alt-solid',
      'label': 'Logout',
    },
  ];

  NavigationDestination _buildNavigationDestination(
      String icon, String selectedIcon, String label) {
    return NavigationDestination(
      icon: SvgPicture.asset(
        'assets/icons/$icon.svg',
        colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
        width: 20,
        height: 20,
      ),
      selectedIcon: SvgPicture.asset(
        'assets/icons/$selectedIcon.svg',
        colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
        width: 20,
        height: 20,
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: widget.selectedIndex,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      onDestinationSelected: (int index) {
        setState(() {
          widget.selectedIndexFunc(index);
        });
      },
      indicatorColor: AppColors.primary.withOpacity(0.1),
      backgroundColor: AppColors.white,
      shadowColor: AppColors.primary.withOpacity(0.5),
      elevation: 20,
      destinations: _navDestinations.map((destination) {
        return _buildNavigationDestination(
          destination['icon']!,
          destination['selectedIcon']!,
          destination['label']!,
        );
      }).toList(),
    );
  }
}
