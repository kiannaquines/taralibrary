import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:taralibrary/screens/code.dart';
import 'package:taralibrary/screens/login.dart';
import 'package:taralibrary/screens/register.dart';
import 'package:taralibrary/utils/colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    double copyrightFontSize = screenWidth < 400 ? 12 : 14;

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
                      const Positioned(
                        top: 100,
                        left: 25,
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 150,
                        left: 25,
                        child: Text(
                          "Recover your password by entering\nyour email address.",
                          softWrap: true,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.normal,
                            color: AppColors.black.withOpacity(0.5),
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
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                        maxLines: 1,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: AppColors.dark.withOpacity(0.9),
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
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                                maintainState: false,
                              ),
                            );
                          },
                          child: const Text(
                            'Remembered your password?',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CodeScreen(),
                              maintainState: false,
                            ),
                          );
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
                              'Send Code',
                              style: TextStyle(
                                fontSize: 16,
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
                          const Text(
                            "Are you not registered yet? ",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.black,
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
                            fontSize: copyrightFontSize,
                            color: Colors.black54,
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
