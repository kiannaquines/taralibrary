import 'package:flutter/material.dart';
import 'package:taralibrary/model/home_model.dart';
import 'package:taralibrary/screens/login.dart';
import 'package:taralibrary/service/home_service.dart';
import 'package:taralibrary/utils/colors.dart';
import 'package:taralibrary/screens/info.dart';
import 'package:taralibrary/screens/sections.dart';
import 'package:taralibrary/utils/storage.dart';
import 'package:taralibrary/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:taralibrary/service/service_app.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiSettings apiSettings = ApiSettings();

  String get staticDir => ApiSettings.getStaticFileDir();
  MyStorage myStorage = MyStorage();
  final HomeService _homeService = HomeService();
  List<PopularModel> _popularZones = [];
  List<RecommendedModel> _recommendedZones = [];

  String selectedSection = 'All';

  final TextEditingController _controller = TextEditingController();
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadAccessToken();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String?> _loadAccessToken() async {
    Map<String, dynamic> tokenData = await myStorage.fetchAccessToken();
    String accessToken = tokenData['accessToken'];

    Future<void> handleApiResponse<T>(
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

    await handleApiResponse<PopularModel>(
      _homeService.getPopularSection,
      (data) => setState(() => _popularZones = data),
    );

    await handleApiResponse<RecommendedModel>(
      _homeService.getRecommendedSection,
      (data) => setState(() => _recommendedZones = data),
    );

    return accessToken;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            bottom: 10.0,
          ),
          sliver: SliverToBoxAdapter(
            child: Container(
              constraints: const BoxConstraints(
                maxHeight: 60,
              ),
              child: TextField(
                controller: _controller,
                onChanged: (value) {
                  setState(() {
                    // Implement search functionality here
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search your favorite...',
                  hintStyle: TextStyle(
                    color: AppColors.dark.withOpacity(0.5),
                  ),
                  fillColor: AppColors.searchBarColor.withOpacity(0.1),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 20.0,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.dark.withOpacity(0.5),
                    size: 25.0,
                  ),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _controller.clear();
                            setState(() {});
                          },
                          color: AppColors.dark.withOpacity(0.5),
                        )
                      : null,
                ),
                keyboardType: TextInputType.text,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Popular Sections',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SectionScreen(),
                      ),
                    );
                  },
                  child: const Row(
                    children: [
                      Text(
                        'See more',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward,
                        color: AppColors.primary,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 20.0,
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 2 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: _popularZones.length,
                itemBuilder: (BuildContext ctx, index) {
                  final zone = _popularZones[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InfoScreen(
                            zoneID: zone.zoneID,
                          ),
                          maintainState: false,
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: '$staticDir${zone.image}',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 35,
                          left: 5,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.imagebackgroundOverlay
                                    .withOpacity(0.7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                zone.title,
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          left: 5,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.imagebackgroundOverlay
                                    .withOpacity(0.7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: 15,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    '${zone.rating} Rating',
                                    style: const TextStyle(
                                      color: AppColors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
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
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: const Text(
              'Most Visited Sections',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                double screenWidth = MediaQuery.of(context).size.width;
                double baseFontSize = screenWidth * 0.03;
                RecommendedModel recommenedZone = _recommendedZones[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InfoScreen(zoneID: 1),
                        maintainState: false,
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.1),
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: '$staticDir${recommenedZone.image}',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                left: 5,
                                child: Builder(
                                  builder: (context) {
                                    final text = recommenedZone.status;
                                    final textStyle = TextStyle(
                                      fontSize: baseFontSize,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.white,
                                    );

                                    final textPainter = TextPainter(
                                      text: TextSpan(
                                          text: text, style: textStyle),
                                      textDirection: TextDirection.ltr,
                                      maxLines: 1,
                                    )..layout();

                                    double textWidth = textPainter.size.width;

                                    double iconWidth = 10;
                                    double iconPadding = 5;

                                    double maxWidth =
                                        textWidth + iconWidth + iconPadding <
                                                130
                                            ? textWidth +
                                                iconWidth +
                                                iconPadding +
                                                20
                                            : 130;

                                    return ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: maxWidth,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors
                                              .imagebackgroundOverlay
                                              .withOpacity(0.7),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        child: Center(
                                          child: Text(
                                            text,
                                            style: textStyle,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    recommenedZone.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: baseFontSize,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.black,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  recommenedZone.description,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: baseFontSize * 0.9,
                                    color: AppColors.dark,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 15,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      recommenedZone.rating.toString(),
                                      style: TextStyle(
                                        fontSize: baseFontSize * 0.9,
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: _recommendedZones.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 15),
        ),
      ],
    );
  }
}

Widget _buildSectionButton(String title,
    {bool isSelected = false, VoidCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color:
            isSelected ? AppColors.primary.withOpacity(0.2) : AppColors.white,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: null,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.dark,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    ),
  );
}
