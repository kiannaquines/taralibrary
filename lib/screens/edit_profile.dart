import 'package:flutter/material.dart';
import 'package:taralibrary/model/profile_model.dart';
import 'package:taralibrary/screens/change_password_account.dart';
import 'package:taralibrary/screens/login.dart';
import 'package:taralibrary/screens/profile.dart';
import 'package:taralibrary/service/profile_service.dart';
import 'package:taralibrary/service/service_app.dart';
import 'package:taralibrary/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taralibrary/utils/storage.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ProfileService _profileService = ProfileService();
  ProfileModel? _profile;

  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();

  MyStorage myStorage = MyStorage();

  Future<ProfileModel?> _loadAccessToken() async {
    Map<String, dynamic> tokenData = await myStorage.fetchAccessToken();
    String accessToken = tokenData['accessToken'];

    ApiResponse<ProfileModel> response =
        await _profileService.getProfile(accessToken);
    if (response.result == ApiResult.success) {
      return response.data;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response.errorMessage ?? 'An error occurred',
          ),
          showCloseIcon: true,
          duration: const Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
        ),
      );
      if (response.result == ApiResult.loginRequired) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.errorMessage ?? 'An error occurred'),
            showCloseIcon: true,
            duration: const Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
      return null;
    }
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
      body: FutureBuilder<ProfileModel?>(
        future: _loadAccessToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No profile data available.'));
          } else {
            _profile = snapshot.data;
            _username.text = _profile!.username;
            _email.text = _profile!.email;
            _firstName.text = _profile!.firstName;
            _lastName.text = _profile!.lastName;

            return SingleChildScrollView(
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
                              size: 20,
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
                                image: AssetImage(
                                    'assets/icons/small-ellipse.png'),
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
                        Text(
                          'Edit your information',
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
                          controller: _username,
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: 'User Name',
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppColors.dark.withOpacity(0.9),
                                fontSize: 16),
                            prefixIcon: const Icon(
                              FeatherIcons.user,
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
                          controller: _firstName,
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: 'First Name',
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppColors.dark.withOpacity(0.9),
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
                          controller: _lastName,
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: 'Last Name',
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppColors.dark.withOpacity(0.9),
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
                          controller: _email,
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
                        const SizedBox(height: 25),
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
                                Icons.save,
                                color: AppColors.white,
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
                                      const ChangePasswordAccount(),
                                ),
                              );
                            },
                            child: const Text(
                              'Change Password',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
