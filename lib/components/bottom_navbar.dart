import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taralibrary/utils/colors.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int currentSelectedIndex = 0;

  // Icon paths
  final String _homeIcon = 'assets/icons/home.svg';
  final String _homeIconSelected = 'assets/icons/home-solid.svg';
  final String _mapIcon = 'assets/icons/map-marker.svg';
  final String _mapIconSelected = 'assets/icons/map-marker-solid.svg';
  final String _userIcon = 'assets/icons/user.svg';
  final String _userIconSelected = 'assets/icons/user-solid.svg';
  final String _visitorsIcon = 'assets/icons/chart-histogram.svg';
  final String _visitorsIconSelected = 'assets/icons/chart-histogram-solid.svg';

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
      'icon': 'chart-histogram',
      'selectedIcon': 'chart-histogram-solid',
      'label': 'Visitors',
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
      selectedIndex: currentSelectedIndex,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      onDestinationSelected: (int index) {
        setState(() {
          currentSelectedIndex = index;
          // Implement navigation logic here
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
