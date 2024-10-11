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

  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAccessToken();

    _username.text = 'kjgnaquines';
    _email.text = 'kjgnaquines@gmail.com';
    _firstName.text = 'Kian';
    _lastName.text = 'Naquines';
  }

  MyStorage myStorage = MyStorage();

  Future<String?> _loadAccessToken() async {
    Map<String, dynamic> tokenData = await myStorage.fetchAccessToken();
    return tokenData['accessToken'];
  }

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _firstName.dispose();
    _lastName.dispose();
    super.dispose();
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
                    top: 45,
                    left: 25,
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
                      child: ClipOval(
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          width: 50,
                          height: 50,
                          child: SvgPicture.asset(
                            'assets/icons/angle-small-left.svg',
                            colorFilter: ColorFilter.mode(
                              AppColors.dark.withOpacity(0.7),
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
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
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
                    right: 150,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.dark.withOpacity(0.1),
                            blurRadius: 2,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 30,
                        color: AppColors.primary,
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
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextField(
                    controller: _username,
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
                    height: 25,
                  ),
                  TextField(
                    controller: _firstName,
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
                    height: 25,
                  ),
                  TextField(
                    controller: _lastName,
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
                    height: 25,
                  ),
                  TextField(
                    controller: _email,
                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      labelStyle: TextStyle(
                        color: AppColors.black.withOpacity(
                          0.5,
                        ),
                      ),
                      prefixIcon: const Icon(
                        Icons.email,
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
                    height: 25,
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
