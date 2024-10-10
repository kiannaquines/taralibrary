import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taralibrary/screens/login.dart';
import 'package:taralibrary/screens/register.dart';
import 'package:taralibrary/utils/colors.dart';
import 'package:taralibrary/model/auth_models.dart';
import 'package:taralibrary/service/auth_service.dart';

class VerificationScreen extends StatefulWidget {
  final int userId;
  const VerificationScreen({super.key, required this.userId});

  @override
  // ignore: library_private_types_in_public_api
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen>
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

  void verifyAccount() async {
    AuthService authService = AuthService();

    var code = _controllers.map((controller) => controller.text).join('');

    AccountVerification verificationData = AccountVerification(
      code: code,
      userId: widget.userId,
    );

    Map<String, dynamic> result = await authService.verificationAccount(
      verificationData,
    );

    String message = result['message'];
    int statusCode = result['status_code'];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        showCloseIcon: true,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
      ),
    );

    if (statusCode == 200) {
      await Future.delayed(const Duration(seconds: 5));

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (Route<dynamic> route) => false,
      );
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
                            "Verification Code",
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
                            "Enter your verification code\nsent to email address.",
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
                              width: 45,
                              child: TextField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                obscureText: false,
                                maxLines: 1,
                                maxLength: 1,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                maxLengthEnforcement: MaxLengthEnforcement.none,
                                buildCounter: (BuildContext context,
                                    {required int currentLength,
                                    required bool isFocused,
                                    int? maxLength}) {
                                  return const SizedBox.shrink();
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (value) {
                                  if (value.length > 1) {
                                    _controllers[index].text = value[0];
                                    _controllers[index].selection =
                                        TextSelection.fromPosition(
                                      TextPosition(
                                        offset: _controllers[index].text.length,
                                      ),
                                    );
                                  }

                                  _onChanged(value, index);
                                },
                                decoration: InputDecoration(
                                  labelText: '',
                                  labelStyle: TextStyle(
                                    color: AppColors.dark.withOpacity(0.5),
                                  ),
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
                                  if (_focusNodes[index].hasFocus) {
                                    _controllers[index].clear();
                                  } else {
                                    FocusScope.of(context)
                                        .requestFocus(_focusNodes[index]);
                                  }
                                },
                                onEditingComplete: () {
                                  FocusScope.of(context).unfocus();
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
                              'Already have an account?',
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
                            verifyAccount();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            foregroundColor: AppColors.primary,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14.0,
                              horizontal: 32.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                25,
                              ),
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
                        const SizedBox(
                          height: 20,
                        ),
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
