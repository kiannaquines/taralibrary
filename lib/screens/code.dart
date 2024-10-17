import 'package:flutter/material.dart';
import 'package:taralibrary/screens/change_password.dart';
import 'package:taralibrary/screens/login.dart';
import 'package:taralibrary/screens/register.dart';
import 'package:taralibrary/utils/colors.dart';

class CodeScreen extends StatefulWidget {
  const CodeScreen({super.key});

  @override
  _CodeScreenState createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < _focusNodes.length - 1) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        FocusScope.of(context).unfocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    double copyrightFontSize = screenWidth < 400 ? 12 : 14;

    return Scaffold(
      body: SingleChildScrollView(
        child: AnimatedPadding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
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
                            "Confirmation Code",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 150,
                          left: 25,
                          child: Text(
                            "Enter your confirmation code\nsent to email address.",
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(6, (index) {
                            return SizedBox(
                              width: 40,
                              child: TextField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                obscureText: false,
                                maxLines: 1,
                                keyboardType: TextInputType.phone,
                                textAlign: TextAlign.center,
                                onChanged: (value) => _onChanged(value, index),
                                decoration: InputDecoration(
                                  labelText: '',
                                  labelStyle: TextStyle(
                                      color: AppColors.black.withOpacity(0.5)),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  fillColor: AppColors.primary.withOpacity(0.1),
                                  filled: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                    horizontal: 0,
                                  ),
                                ),
                                onTap: () {
                                  FocusScope.of(context).requestFocus(_focusNodes[index]);
                                },
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
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
                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         ChangePasswordScreen(
                            //           userId: widget.user,
                            //         ),
                            //     maintainState: false,
                            //   ),
                            // );
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
                                Icons.login,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Submit Code',
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
      ),
    );
  }
}
