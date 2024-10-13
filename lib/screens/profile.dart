import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:taralibrary/model/home_model.dart';
import 'package:taralibrary/model/profile_model.dart';
import 'package:taralibrary/screens/edit_profile.dart';
import 'package:taralibrary/screens/login.dart';
import 'package:taralibrary/service/home_service.dart';
import 'package:taralibrary/service/profile_service.dart';
import 'package:taralibrary/service/service_app.dart';
import 'package:taralibrary/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taralibrary/screens/home.dart';
import 'package:taralibrary/utils/constants.dart';
import 'package:taralibrary/utils/storage.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ApiSettings apiSettings = ApiSettings();
  final ProfileService _profileService = ProfileService();
  ProfileModel? _profile;
  final HomeService _homeService = HomeService();
  String get staticDir => ApiSettings.getStaticFileDir();

  List<PopularModel> _popularZones = [];
  List<RecommendedModel> _recommendedZones = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAccessToken();
  }

  MyStorage myStorage = MyStorage();

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
          setState(() => _isLoading = false);
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
          setState(() => _isLoading = false);
          break;
      }
    }

    Future<void> handleApiResponseSection<T>(
        Future<ApiResponse<List<T>>> Function(String) apiCall,
        void Function(List<T>) updateState) async {
      ApiResponse<List<T>> response = await apiCall(accessToken);
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

    await handleApiResponseSection<PopularModel>(
      _homeService.getPopularSection,
      (data) => setState(() => _popularZones = data),
    );

    await handleApiResponseSection<RecommendedModel>(
      _homeService.getRecommendedSection,
      (data) => setState(() => _recommendedZones = data),
    );

    await handleApiResponse<ProfileModel>(
      _profileService.getProfile,
      (data) => setState(() => _profile = data),
    );

    return accessToken;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            )
          : SingleChildScrollView(
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
                          top: 40,
                          left: 20,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
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
                                    AppColors.dark.withOpacity(0.5),
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
                  Text(
                    '${_profile?.firstName} ${_profile?.lastName}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '@${_profile?.username}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                            maintainState: true,
                          ),
                        );
                      },
                      label: const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 14, // Reduced font size
                        ),
                      ),
                      icon: const Icon(
                        FeatherIcons.edit,
                        size: 16, // Reduced icon size
                        color: Colors.white,
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0), // Reduced padding
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Recommended Sections',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: GridView.builder(
                            reverse: false,
                            scrollDirection: Axis.horizontal,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              childAspectRatio: 2 / 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                            ),
                            itemCount: _recommendedZones.length,
                            itemBuilder: (BuildContext ctx, index) {
                              final recommendedZone = _recommendedZones[index];
                              return GestureDetector(
                                onTap: () {
                                  // TODO: Add functionality to navigate to the selected section
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color:
                                            AppColors.primary.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              '$staticDir${recommendedZone.image}',
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          fadeInDuration:
                                              const Duration(milliseconds: 300),
                                          fadeOutDuration:
                                              const Duration(milliseconds: 300),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 10,
                                      left: 10,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          color: AppColors
                                              .imagebackgroundOverlay
                                              .withOpacity(0.6),
                                          child: Text(
                                            recommendedZone.title,
                                            style: const TextStyle(
                                              color: AppColors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Most Visited Sections',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: GridView.builder(
                            reverse: false,
                            scrollDirection: Axis.horizontal,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              childAspectRatio: 2 / 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                            ),
                            itemCount: _recommendedZones.length,
                            itemBuilder: (BuildContext ctx, index) {
                              final popularZone = _popularZones[index];
                              return GestureDetector(
                                onTap: () {
                                  // TODO: Add functionality to navigate to the selected section
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color:
                                            AppColors.primary.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              '$staticDir${popularZone.image}',
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          fadeInDuration:
                                              const Duration(milliseconds: 300),
                                          fadeOutDuration:
                                              const Duration(milliseconds: 300),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 10,
                                      left: 10,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          color: AppColors
                                              .imagebackgroundOverlay
                                              .withOpacity(0.6),
                                          child: Text(
                                            popularZone.title,
                                            style: const TextStyle(
                                              color: AppColors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
