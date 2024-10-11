import 'package:flutter/material.dart';
import 'package:taralibrary/screens/login.dart';
import 'package:taralibrary/utils/colors.dart';
import 'package:taralibrary/utils/storage.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String greetingMessage;
  final String libraryName;
  final String avatarImagePath;

  const CustomAppBar({
    super.key,
    this.greetingMessage = 'Good Morning, Kian!',
    this.libraryName = 'TaraLibrary',
    this.avatarImagePath = 'assets/images/avatar-1.jpg',
  });

  @override
  Size get preferredSize => const Size.fromHeight(80.0);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  Storage storage = Storage();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      automaticallyImplyLeading: false,
      elevation: 4,
      flexibleSpace: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.greetingMessage,
                          style: const TextStyle(
                            fontSize: 13.0,
                            color: AppColors.dark,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          widget.libraryName,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _openLoggedoutDialog(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                          width: 5.0,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 22.0,
                        backgroundImage: AssetImage(widget.avatarImagePath),
                        backgroundColor: Colors.transparent,
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
                        onPressed: () async {
                          await storage.deleteData('accessToken');
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
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
