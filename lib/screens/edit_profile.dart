import 'package:flutter/material.dart';
import 'package:taralibrary/screens/profile.dart';
import 'package:taralibrary/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taralibrary/utils/storage.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final List<String> recentSections = [
    'Information Technology',
    'References',
    'Filipiniana',
    'Publication',
  ];

  @override
  void initState() {
    super.initState();
    _loadAccessToken();
  }

  MyStorage myStorage = MyStorage();

  Future<String?> _loadAccessToken() async {
    Map<String, dynamic> tokenData = await myStorage.fetchAccessToken();
    return tokenData['accessToken'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/icons/ellipse.png'),
                  alignment: Alignment.topLeft,
                  fit: BoxFit.contain,
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Positioned(
                    top: 40,
                    left: 20,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileScreen(),
                            maintainState: true,
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.rectangle,
                          ),
                          width: 50,
                          height: 50,
                          child: SvgPicture.asset(
                            'assets/icons/angle-small-left.svg',
                            colorFilter: ColorFilter.mode(
                              AppColors.dark.withOpacity(0.5),
                              BlendMode.srcIn,
                            ),
                            width: 25,
                            height: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            AssetImage('assets/images/avatar-1.jpg'),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -5,
                    right: -15,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/icons/small-ellipse.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  TextField(
                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: 'User Name',
                      labelStyle: TextStyle(
                        color: AppColors.black.withOpacity(
                          0.5,
                        ),
                      ),
                      prefixIcon: const Icon(
                        Icons.person,
                        color: AppColors.primary,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      fillColor: AppColors.primary.withOpacity(0.1),
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      labelStyle: TextStyle(
                        color: AppColors.black.withOpacity(
                          0.5,
                        ),
                      ),
                      prefixIcon: const Icon(
                        Icons.person,
                        color: AppColors.primary,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      fillColor: AppColors.primary.withOpacity(0.1),
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      labelStyle: TextStyle(
                        color: AppColors.black.withOpacity(
                          0.5,
                        ),
                      ),
                      prefixIcon: const Icon(
                        Icons.person,
                        color: AppColors.primary,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      fillColor: AppColors.primary.withOpacity(0.1),
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      labelStyle: TextStyle(
                        color: AppColors.black.withOpacity(
                          0.5,
                        ),
                      ),
                      prefixIcon: const Icon(
                        Icons.person,
                        color: AppColors.primary,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      fillColor: AppColors.primary.withOpacity(0.1),
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                          maintainState: false,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      foregroundColor: AppColors.primary,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14.0, horizontal: 32.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.save,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
