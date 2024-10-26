import 'package:flutter/material.dart';
import 'package:taralibrary/model/auth_models.dart';
import 'package:taralibrary/screens/forgot.dart';
import 'package:taralibrary/screens/register.dart';
import 'package:taralibrary/utils/colors.dart';
import 'package:taralibrary/screens/home.dart';
import 'package:taralibrary/service/auth_service.dart';
import 'package:taralibrary/utils/storage.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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

  void loginProcess() async {
    Storage storage = Storage();
    AuthService authService = AuthService();

    Login loginDetail = Login(
      username: _usernameController.text,
      password: _passwordController.text,
    );

    Map<String, dynamic> result = await authService.login(loginDetail);

    String message = result['message'] ?? 'An unknown error occurred.';
    int statusCode = result['status_code'] ?? 500;

    if (statusCode == 200) {
      String accessToken = result['access_token'] ?? '';
      storage.addData('accessToken', accessToken);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          showCloseIcon: true,
          duration: const Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
        ),
      );

      await Future.delayed(const Duration(seconds: 5));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
        (Route<dynamic> route) => false,
      );
    }

    if (statusCode == 422 || statusCode == 401 || statusCode == 500) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          showCloseIcon: true,
          duration: const Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
        ),
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
                          "Start by signing in your\naccount.",
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
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.dark.withOpacity(0.9),
                            fontSize: 16),
                        controller: _usernameController,
                        maxLines: 1,
                        decoration: InputDecoration(
                          labelText: 'Username',
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
                      const SizedBox(height: 15),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordScreen(),
                                maintainState: true,
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
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () {
                          loginProcess();
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
                              'Sign In',
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
                            "Not registered yet? ",
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
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 60),
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
              bottom: -100,
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
