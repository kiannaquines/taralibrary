import 'package:flutter/material.dart';
import 'package:taralibrary/components/bottom_navbar.dart';
import 'package:taralibrary/components/app_navbar.dart';
import 'package:taralibrary/pages/home_page.dart';
import 'package:taralibrary/screens/navigation.dart';
import 'package:taralibrary/screens/profile.dart';
import 'package:taralibrary/utils/colors.dart';
import 'package:taralibrary/screens/login.dart';

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
        _openLoggedoutDialog(context);
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
        avatarImagePath: 'assets/images/avatar-1.jpg',
      ),
      body: bodyWidget,
      bottomNavigationBar: BottomNavbar(
        selectedIndex: selectedIndex,
        selectedIndexFunc: _onDestinationSelected,
      ),
    );
  }

  void _openLoggedoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Logout?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'You are about to leave this page.',
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _logout();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          foregroundColor: AppColors.primary,
                          shadowColor: Colors.transparent,
                        ),
                        child: const Text('Sign out'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }
}
