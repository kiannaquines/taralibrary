import 'package:flutter/material.dart';
import 'package:taralibrary/components/bottom_navbar.dart';
import 'package:taralibrary/components/app_navbar.dart';
import 'package:taralibrary/pages/home_page.dart';
import 'package:taralibrary/screens/navigation.dart';
import 'package:taralibrary/screens/profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  void _onDestinationSelected(int index) {
    switch (index) {
      case 0:
        setState(() {
          selectedIndex = index;
        });
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const NavigationScreen(),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileScreen(),
          ),
        );
        break;
      case 3:
        _openLoggedoutDialog();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyWidget = const HomePage();

    return Scaffold(
      appBar: const CustomAppBar(
        greetingMessage: 'Good Evening, Kian!',
        libraryName: 'KEPLRC Library',
        avatarImagePath: 'assets/images/avatar.jpg',
      ),
      body: bodyWidget,
      bottomNavigationBar: BottomNavbar(
        selectedIndex: selectedIndex,
        selectedIndexFunc:
            _onDestinationSelected,
      ),
    );
  }

  void _openLoggedoutDialog(BuildContext context) {
    showDialog(context: context, builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        child: const SizedBox(
           height: 200,
           child: Text('Are you sure you want to log out?'),
        ),
      );
    });
  }
}
