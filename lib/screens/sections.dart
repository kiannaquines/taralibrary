import 'package:flutter/material.dart';
import 'package:taralibrary/screens/home.dart';
import 'package:taralibrary/screens/profile.dart';
import 'package:taralibrary/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taralibrary/screens/info.dart';

class SectionScreen extends StatefulWidget {
  const SectionScreen({super.key});

  @override
  State<SectionScreen> createState() => _SectionScreenState();
}

class _SectionScreenState extends State<SectionScreen> {
  final List<String> sectionName = [
    'Information Technology',
    'References',
    'Filipiniana',
    'Pubication',
    'Serials',
    'Medical',
  ];

  final TextEditingController _controller = TextEditingController();

  int selectedIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String selectedSection = 'All';

    return Scaffold(
      appBar: AppBar(
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
            icon: const Icon(Icons.sort),
            onPressed: () {
              // Sorting logic goes here
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {
              // More options logic goes here
            },
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(
                top: 10.0,
                left: 20.0,
                right: 20.0,
              ),
              sliver: SliverToBoxAdapter(
                child: Container(
                  constraints: const BoxConstraints(
                    maxHeight: 60,
                  ),
                  child: TextField(
                    controller: _controller,
                    onChanged: (value) {
                      setState(() {});
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
            SliverPadding(
              padding: const EdgeInsets.only(
                top: 10.0,
                left: 20.0,
                right: 20.0,
              ),
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
                          debugPrint(selectedSection);
                        });
                      }),
                      const SizedBox(width: 15.0),
                      _buildSectionButton('Study',
                          isSelected: selectedSection == 'Study', onTap: () {
                        setState(() {
                          selectedSection = 'Study';

                          debugPrint(selectedSection);
                        });
                      }),
                      const SizedBox(width: 15.0),
                      _buildSectionButton('Relax',
                          isSelected: selectedSection == 'Relax', onTap: () {
                        setState(() {
                          selectedSection = 'Relax';
                          debugPrint(selectedSection);
                        });
                      }),
                      const SizedBox(width: 15.0),
                      _buildSectionButton('Reading',
                          isSelected: selectedSection == 'Reading', onTap: () {
                        setState(() {
                          selectedSection = 'Reading';
                          debugPrint(selectedSection);
                        });
                      }),
                      const SizedBox(width: 15.0),
                      _buildSectionButton('Computer Lab',
                          isSelected: selectedSection == 'Computer Lab',
                          onTap: () {
                        setState(() {
                          selectedSection = 'Computer Lab';
                          debugPrint(selectedSection);
                        });
                      }),
                      const SizedBox(width: 15.0),
                      _buildSectionButton('Study Desk',
                          isSelected: selectedSection == 'Study Desk',
                          onTap: () {
                        setState(() {
                          selectedSection = 'Study Desk';
                          debugPrint(selectedSection);
                        });
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
                  'Sections',
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

                    return GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InfoScreen(),
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
                                    child: Image.asset(
                                      'assets/images/${index + 2}.jfif',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
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
                                          color:
                                              AppColors.imagebackgroundOverlay,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Trending Now',
                                              style: TextStyle(
                                                fontSize: baseFontSize,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.white,
                                              ),
                                            ),
                                            SvgPicture.asset(
                                                'assets/icons/arrow-trend-up.svg',
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                  Colors.yellow,
                                                  BlendMode.srcIn,
                                                ),
                                                width: 10,
                                                height: 10),
                                          ],
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        sectionName[index],
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
                                      'Spacious and well-equipped spaces.',
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
                                          '4.5',
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
                  childCount: sectionName.length,
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
              'assets/icons/building-solid.svg',
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
