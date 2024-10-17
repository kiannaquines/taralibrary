import 'package:flutter/material.dart';
import 'package:taralibrary/model/auth_models.dart';
import 'package:taralibrary/screens/change_password.dart';
import 'package:taralibrary/screens/login.dart';
import 'package:taralibrary/screens/register.dart';
import 'package:taralibrary/service/auth_service.dart';
import 'package:taralibrary/utils/colors.dart';

class VerifyResetPassword extends StatefulWidget {
  final int userId;
  const VerifyResetPassword({
    super.key,
    required this.userId,
  });

  @override
  _VerifyResetPasswordState createState() => _VerifyResetPasswordState();
}

class _VerifyResetPasswordState extends State<VerifyResetPassword>
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

  void verifyCode() async {
    AuthService authService = AuthService();
    var code = _controllers.map((controller) => controller.text).join('');
    AccountVerification verificationData = AccountVerification(
      code: code,
      userId: widget.userId,
    );

    final response = await authService.verificationAccount(verificationData);
    try {
      if (response['status_code'] == 200) {
        _showSnackBar(response['message']);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const ChangePasswordScreen(),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        _showSnackBar(response['message']);
      }
    } catch (e) {
      _showSnackBar(response['message']);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.imagebackgroundOverlay,
        showCloseIcon: true,
        behavior: SnackBarBehavior.floating,
      ),
    );
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
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.dark.withOpacity(0.9),
                                  fontSize: 16,
                                ),
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
                                  FocusScope.of(context)
                                      .requestFocus(_focusNodes[index]);
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
                                  builder: (context) => const LoginScreen(),
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
                            verifyCode();
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
                                    builder: (context) =>
                                        const RegisterScreen(),
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
