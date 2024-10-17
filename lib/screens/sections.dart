import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:taralibrary/model/home_model.dart';
import 'package:taralibrary/model/section_models.dart';
import 'package:taralibrary/screens/home.dart';
import 'package:taralibrary/screens/login.dart';
import 'package:taralibrary/screens/profile.dart';
import 'package:taralibrary/service/home_service.dart';
import 'package:taralibrary/service/notification_service.dart';
import 'package:taralibrary/service/section_service.dart';
import 'package:taralibrary/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taralibrary/screens/info.dart';
import 'package:taralibrary/utils/constants.dart';
import 'package:taralibrary/utils/storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:taralibrary/service/service_app.dart';

class SectionScreen extends StatefulWidget {
  const SectionScreen({super.key});

  @override
  State<SectionScreen> createState() => _SectionScreenState();
}

class _SectionScreenState extends State<SectionScreen> {
  ApiSettings apiSettings = ApiSettings();
  final SectionService _sectionService = SectionService();
  final HomeService _homeService = HomeService();

  String get staticDir => ApiSettings.getStaticFileDir();
  List<AllSectionModel> _allSection = [];
  List<CategoryModel> _categories = [];
  MyStorage myStorage = MyStorage();

  String selectedSection = 'All';
  final TextEditingController _controller = TextEditingController();

  List<AllSectionModel> _filteredSections = [];

  @override
  void initState() {
    super.initState();
    _loadAccessToken();
    _filteredSections = _allSection;
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
          if (response.data != null) {
            updateState(response.data!);
          }
          break;
        case ApiResult.loginRequired:
          WidgetsBinding.instance.addPostFrameCallback((_) {
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
          });
          return;
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

    await handleApiResponse<AllSectionModel>(_sectionService.getAllSections,
        (data) {
      setState(() {
        _allSection = data;
        _filteredSections = data;
      });
    });

    await handleApiResponse<CategoryModel>(
      _homeService.getCategories,
      (data) => setState(() => _categories = data),
    );

    return accessToken;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _filterSections(String query) {
    setState(() {
      _filteredSections = _allSection.where((section) {
        bool matchesQuery =
            section.title.toLowerCase().contains(query.toLowerCase()) ||
                section.description.toLowerCase().contains(query.toLowerCase());
        bool matchesCategory = selectedSection == 'All' ||
            section.categories
                .any((category) => category.categoryName == selectedSection);

        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  Future<void> _refreshData() async {
    String? accessToken = await _loadAccessToken();
    if (accessToken != null) {
      selectedSection = 'All';
      await _loadAccessToken();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: Scaffold(
        appBar: AppBar(
          leading: const Icon(
            FeatherIcons.menu,
            color: AppColors.primary,
          ),
          title: const Text(
            'Library Facilities',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                FeatherIcons.bell,
                color: AppColors.primary,
              ),
              onPressed: () {
                NotificationService().showNotification(
                  id: 1,
                  title: 'Crowd Density Alert',
                  body: 'The Reference Section has 34 visitors as of 9:43 AM.',
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 60),
                    child: TextField(
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.dark.withOpacity(0.9),
                          fontSize: 16),
                      controller: _controller,
                      onChanged: (value) {
                        _filterSections(value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search library section',
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.dark.withOpacity(0.9),
                            fontSize: 16),
                        fillColor: AppColors.searchBarColor.withOpacity(0.1),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        prefixIcon: Icon(
                          FeatherIcons.search,
                          color: AppColors.dark.withOpacity(0.5),
                          size: 25.0,
                        ),
                        suffixIcon: _controller.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _controller.clear();
                                  _filterSections('');
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
              SliverPadding(
                padding: const EdgeInsets.only(
                    top: 10.0, left: 20.0, right: 20.0, bottom: 20.0),
                sliver: SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildSectionButton('All',
                            isSelected: selectedSection == 'All', onTap: () {
                          setState(() {
                            selectedSection = 'All';
                            _filterSections('');
                          });
                        }),
                        const SizedBox(width: 15.0),
                        ..._categories.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: _buildSectionButton(
                              item.name,
                              isSelected: selectedSection == item.name,
                              onTap: () {
                                setState(() {
                                  selectedSection = item.name;
                                  _filterSections('');
                                });
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: const Text(
                    'Library Sections',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding:
                    const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                sliver: _filteredSections.isEmpty
                    ? const SliverToBoxAdapter(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2 / 3,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            double screenWidth =
                                MediaQuery.of(context).size.width;
                            double baseFontSize = screenWidth * 0.03;

                            AllSectionModel section = _filteredSections[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => InfoScreen(
                                      zoneID: section.zoneID,
                                    ),
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
                                      spreadRadius: 0,
                                      offset: const Offset(0, 4),
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
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  '$staticDir${section.image}',
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                      child:
                                                          CircularProgressIndicator()),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 5,
                                            left: 5,
                                            child: ConstrainedBox(
                                              constraints: const BoxConstraints(
                                                maxWidth: 115,
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: AppColors
                                                      .imagebackgroundOverlay
                                                      .withOpacity(0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                child: Text(
                                                  section.categories.isNotEmpty
                                                      ? section.categories.first
                                                          .categoryName
                                                      : 'No Category',
                                                  style: TextStyle(
                                                    fontSize: baseFontSize,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.white,
                                                  ),
                                                ),
                                              ),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: double.infinity,
                                              child: Text(
                                                section.title,
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
                                              section.description,
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
                                                  section.rating.toString(),
                                                  style: TextStyle(
                                                    fontSize:
                                                        baseFontSize * 0.9,
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
                          childCount: _filteredSections.length,
                        ),
                      ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 15),
              ),
            ],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: 1,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          onDestinationSelected: (int index) {
            setState(() {
              if (index == 0) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                    maintainState: false,
                  ),
                );
              }

              if (index == 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SectionScreen(),
                    maintainState: false,
                  ),
                );
              }

              if (index == 2) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                    maintainState: false,
                  ),
                );
              }
            });
          },
          indicatorColor: AppColors.primary.withOpacity(0.1),
          backgroundColor: AppColors.white,
          shadowColor: AppColors.primary.withOpacity(0.5),
          elevation: 20,
          destinations: [
            NavigationDestination(
              icon: SvgPicture.asset(
                'assets/icons/home.svg',
                colorFilter:
                    const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                width: 20,
                height: 20,
              ),
              label: 'Home',
            ),
            NavigationDestination(
              icon: SvgPicture.asset(
                'assets/icons/building.svg',
                colorFilter:
                    const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                width: 20,
                height: 20,
              ),
              label: 'Facilities',
            ),
            NavigationDestination(
              icon: SvgPicture.asset(
                'assets/icons/user.svg',
                colorFilter:
                    const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                width: 20,
                height: 20,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildSectionButton(
  String name, {
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.primary),
      ),
      curve: Curves.easeInOut,
      child: Text(
        name,
        style: TextStyle(
          color: isSelected ? Colors.white : AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
