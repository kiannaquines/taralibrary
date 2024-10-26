import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:taralibrary/model/profile_model.dart';
import 'package:taralibrary/screens/login.dart';
import 'package:taralibrary/service/profile_service.dart';
import 'package:taralibrary/service/service_app.dart';
import 'package:taralibrary/utils/colors.dart';
import 'package:taralibrary/utils/constants.dart';
import 'package:taralibrary/utils/storage.dart';
import 'package:shimmer/shimmer.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String greetingMessage;
  final String libraryName;
  final String avatarImagePath;

  const CustomAppBar({
    super.key,
    this.greetingMessage = 'Good Morning, Kian!',
    this.libraryName = 'TaraLibrary',
    this.avatarImagePath = 'assets/images/avatar-1.jpg',
  });

  @override
  Size get preferredSize => const Size.fromHeight(80.0);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  Storage storage = Storage();
  MyStorage myStorage = MyStorage();
  ApiSettings apiSettings = ApiSettings();
  final ProfileService _profileService = ProfileService();
  ProfileModel? _profile;
  String get staticDir => ApiSettings.getStaticFileDir();

  Future<String?> _loadAccessToken() async {
    Map<String, dynamic> tokenData = await myStorage.fetchAccessToken();
    String accessToken = tokenData['accessToken'];

    Future<void> handleApiResponse<T>(
        Future<ApiResponse<T>> Function(String) apiCall,
        void Function(T) updateState) async {
      ApiResponse<T> response = await apiCall(accessToken);

      switch (response.result) {
        case ApiResult.success:
          updateState(response.data!);
          break;
        case ApiResult.loginRequired:
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
          break;
        case ApiResult.error:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.errorMessage ?? 'An error occurred'),
              showCloseIcon: true,
              duration: const Duration(seconds: 5),
              behavior: SnackBarBehavior.floating,
            ),
          );
          break;
      }
    }

    await handleApiResponse<ProfileModel>(
      _profileService.getProfile,
      (data) => setState(() => _profile = data),
    );

    return accessToken;
  }

  @override
  void initState() {
    super.initState();
    _loadAccessToken();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      automaticallyImplyLeading: false,
      elevation: 4,
      flexibleSpace: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.greetingMessage,
                          style: const TextStyle(
                            fontSize: 13.0,
                            color: AppColors.dark,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          widget.libraryName,
                          style: const TextStyle(
                            fontSize: 23.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _openLoggedoutDialog(context);
                    },
                    child: Container(
                      width: 55,
                      height: 55,
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                      ),
                      child: _profile != null &&
                              _profile!.profile != null &&
                              _profile!.profile!.isNotEmpty
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: '$staticDir${_profile!.profile!}',
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  'assets/images/user.png',
                                ),
                                height: 55,
                                width: 55,
                                fit: BoxFit.cover,
                              ),
                            ) : const SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openLoggedoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Logout?',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'You are about to leave this page.',
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await storage.deleteData('accessToken');
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          shadowColor: Colors.transparent,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Sign out',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
