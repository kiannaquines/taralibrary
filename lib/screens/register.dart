import 'package:flutter/material.dart';
import 'package:taralibrary/screens/forgot.dart';
import 'package:taralibrary/screens/login.dart';
import 'package:taralibrary/screens/verification.dart';
import 'package:taralibrary/utils/colors.dart';
import 'package:taralibrary/model/auth_models.dart';
import 'package:taralibrary/service/auth_service.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _userNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _registerUser() async {
    AuthService authService = AuthService();

    RegisterModel registerModel = RegisterModel(
      username: _userNameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
    );

    Map<String, dynamic> result = await authService.registerService(
      registerModel,
    );

    String message = result['message'];
    int statusCode = result['status_code'];
    int currentId = result['current_id'];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        showCloseIcon: true,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
      ),
    );

    if (statusCode == 200 && currentId != 0) {
      await Future.delayed(const Duration(seconds: 5));

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationScreen(
            userId: currentId,
          ),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Column(
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
                        top: 100,
                        left: 25,
                        child: Text(
                          "TaraLibrary",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black.withOpacity(0.8),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 150,
                        left: 25,
                        child: Text(
                          "Start by creating your new\naccount",
                          softWrap: true,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                            color: AppColors.dark.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fill your information',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.dark.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.dark.withOpacity(0.9),
                            fontSize: 16),
                        controller: _userNameController,
                        maxLines: 1,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.dark.withOpacity(0.5),
                              fontSize: 16),
                          prefixIcon: const Icon(
                            FeatherIcons.atSign,
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
                      const SizedBox(height: 25),
                      TextField(
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.dark.withOpacity(0.9),
                            fontSize: 16),
                        controller: _emailController,
                        maxLines: 1,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.dark.withOpacity(0.5),
                              fontSize: 16),
                          prefixIcon: const Icon(
                            FeatherIcons.mail,
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
                      const SizedBox(height: 25),
                      TextField(
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.dark.withOpacity(0.9),
                            fontSize: 16),
                        controller: _firstNameController,
                        maxLines: 1,
                        decoration: InputDecoration(
                          labelText: 'Firstname',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.dark.withOpacity(0.5),
                              fontSize: 16),
                          prefixIcon: const Icon(
                            FeatherIcons.circle,
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
                      const SizedBox(height: 25),
                      TextField(
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.dark.withOpacity(0.9),
                            fontSize: 16),
                        controller: _lastNameController,
                        maxLines: 1,
                        decoration: InputDecoration(
                          labelText: 'Lastname',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.dark.withOpacity(0.5),
                              fontSize: 16),
                          prefixIcon: const Icon(
                            FeatherIcons.circle,
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
                      Text(
                        'Fill your password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.dark.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.dark.withOpacity(0.9),
                            fontSize: 16),
                        controller: _passwordController,
                        obscureText: true,
                        maxLines: 1,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.dark.withOpacity(0.5),
                              fontSize: 16),
                          prefixIcon: const Icon(
                            FeatherIcons.lock,
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
                      const SizedBox(height: 25),
                      TextField(
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.dark.withOpacity(0.9),
                            fontSize: 16),
                        controller: _confirmPasswordController,
                        obscureText: true,
                        maxLines: 1,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.dark.withOpacity(0.5),
                              fontSize: 16),
                          prefixIcon: const Icon(
                            FeatherIcons.lock,
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
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          _registerUser();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
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
                              Icons.login,
                              color: AppColors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already registered ? ",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.dark.withOpacity(0.6),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: Text(
                          '© 2024 TaraLibrary. All rights reserved.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.dark.withOpacity(0.6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: -60,
              right: -20,
              child: Container(
                width: 155,
                height: 155,
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
    );
  }
}
