import 'package:flutter/material.dart';
import 'package:taralibrary/components/bottom_navbar.dart';
import 'package:taralibrary/components/app_navbar.dart';
import 'package:taralibrary/screens/info.dart';
import 'package:taralibrary/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> sectionName = [
    'Information Technology',
    'References',
    'Filipiniana',
    'Pubication',
  ];

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String selectedSection = 'All';

    return Scaffold(
      appBar: const CustomAppBar(
        greetingMessage: 'Good Morning, Kian!',
        libraryName: 'KEPLRC Library',
        avatarImagePath: 'assets/images/avatar.jpg',
      ),
      body: CustomScrollView(
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
                  controller:
                      _controller,
                  onChanged: (value) {
                    // TODO: Implement search functionality
                    setState(
                        () {});
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
                        isSelected: selectedSection == 'Study Desk', onTap: () {
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
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Popular Sections',
                    style: TextStyle(
                      fontSize: 17, // Slightly larger for better emphasis
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle navigation or action for "See more"
                      print('See more tapped');
                    },
                    child: const Row(
                      children: [
                        Text(
                          'See more',
                          style: TextStyle(
                            fontSize: 16, // Adjusted size for consistency
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(width: 5), // Space between text and icon
                        Icon(
                          Icons.arrow_forward, // Add an arrow icon
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
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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
                  itemCount: 7,
                  itemBuilder: (BuildContext ctx, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InfoScreen(),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/${index + 1}.jfif'),
                                fit: BoxFit.cover,
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
                                  color: AppColors.imagebackgroundOverlay,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Information Technology',
                                  style: TextStyle(
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
                                  color: AppColors.imagebackgroundOverlay,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 15,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '4.5 Rating',
                                      style: TextStyle(
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Recommended Sections',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      debugPrint('See more tapped');
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
                  return Container(
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
                                      color: AppColors.imagebackgroundOverlay,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Trending Now',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        SvgPicture.asset(
                                          'assets/icons/arrow-trend-up.svg',
                                          colorFilter: const ColorFilter.mode(
                                            Colors.yellow,
                                            BlendMode.srcIn,
                                          ),
                                          width: 15,
                                          height: 15,
                                        ),
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
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.black,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Spacious and well-equipped spaces.',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10,
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
                                    const Text(
                                      '4.5',
                                      style: TextStyle(
                                        fontSize: 10,
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
      bottomNavigationBar: const BottomNavbar(),
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
