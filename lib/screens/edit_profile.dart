import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:taralibrary/model/profile_model.dart';
import 'package:taralibrary/screens/change_password_account.dart';
import 'package:taralibrary/screens/login.dart';
import 'package:taralibrary/screens/profile.dart';
import 'package:taralibrary/service/profile_service.dart';
import 'package:taralibrary/service/service_app.dart';
import 'package:taralibrary/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taralibrary/utils/constants.dart';
import 'package:taralibrary/utils/storage.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:image_picker/image_picker.dart';

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
  String get staticDir => ApiSettings.getStaticFileDir();
  MyStorage myStorage = MyStorage();
  XFile? _image;

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
          content: Text(response.errorMessage ?? 'An error occurred'),
          showCloseIcon: true,
          duration: const Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
        ),
      );
      if (response.result == ApiResult.loginRequired) {
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

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future<void> updateProfileData() async {
    Map<String, dynamic> tokenData = await myStorage.fetchAccessToken();
    String accessToken = tokenData['accessToken'];

    int userId = _profile!.id;
    try {
      final updateProfileModel = UpdateProfileModel(
        id: _profile!.id,
        email: _email.text,
        firstName: _firstName.text,
        lastName: _lastName.text,
      );

      final response = await _profileService.updateProfileWithImage(
        userId,
        accessToken,
        updateProfileModel,
        _image,
      );

      if (response.result == ApiResult.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            showCloseIcon: true,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: ${response.errorMessage}'),
            showCloseIcon: true,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: ${e.toString()}'),
          showCloseIcon: true,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
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
                            child: _image != null
                                ? CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.transparent,
                                    child: ClipOval(
                                      child: Image.file(
                                        File(_image!.path),
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : _profile != null &&
                                        _profile!.profile != null &&
                                        _profile!.profile!.isNotEmpty
                                    ? CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Colors.transparent,
                                        child: ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                '$staticDir${_profile!.profile!}',
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(),
                                            errorWidget: (context, url,
                                                    error) =>
                                                Image.asset(
                                                    'assets/images/user.png'),
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : CircleAvatar(
                                        radius:
                                            50,
                                        backgroundColor: AppColors.primary,
                                        child: SvgPicture.asset(
                                          'assets/images/user.png',
                                          width: 30,
                                          height: 30,
                                        ),
                                      ),
                          ),
                        ),
                        Positioned(
                          bottom: -5,
                          right: 150,
                          child: GestureDetector(
                            onTap: _pickImage,
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
                        const SizedBox(height: 20),
                        TextField(
                          readOnly: true,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.dark.withOpacity(0.9),
                            fontSize: 16,
                          ),
                          controller: _username,
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: AppColors.dark.withOpacity(0.9),
                              fontSize: 16,
                            ),
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
                            fontSize: 16,
                          ),
                          controller: _firstName,
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: 'First Name',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: AppColors.dark.withOpacity(0.9),
                              fontSize: 16,
                            ),
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
                            fontSize: 16,
                          ),
                          controller: _lastName,
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: 'Last Name',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: AppColors.dark.withOpacity(0.9),
                              fontSize: 16,
                            ),
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
                          readOnly: true,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.dark.withOpacity(0.9),
                            fontSize: 16,
                          ),
                          controller: _email,
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: AppColors.dark.withOpacity(0.9),
                              fontSize: 16,
                            ),
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
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              updateProfileData();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Update Profile',
                              style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                  ChangePasswordAccount(
                                    userId: _profile!.id,
                                  ),
                              ),
                            );
                          },
                          child: const Text(
                            'Change Password',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
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
