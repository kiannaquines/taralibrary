import 'package:flutter/material.dart';
import 'package:taralibrary/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taralibrary/screens/home.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                              builder: (context) => const HomeScreen(), maintainState: true,
                            ),
                          );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.rectangle,
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
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage('assets/images/avatar.jpg'),
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
                          image: AssetImage('assets/icons/small-ellipse.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Kian G. Naquines',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'BS Information Systems',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () {
                // Add edit profile functionality
              },
              label: const Text('Edit Profile'),
              icon: const Icon(
                Icons.edit,
                size: 15,
              ),
            ),
            const SizedBox(height: 20),
            TabBar(
              overlayColor: WidgetStateColor.transparent,
              controller: _tabController,
              tabs: const [
                Tab(text: 'Likes'),
                Tab(text: 'Reviews'),
                Tab(text: 'Logs'),
              ],
            ),
            SizedBox(
              height: 300,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPostsTab(),
                  _buildFollowersTab(),
                  _buildFollowingTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostsTab() {
    return const Center(
      child: Text(
        'Posts: 255',
      ),
    );
  }

  Widget _buildFollowersTab() {
    return const Center(
      child: Text(
        'Followers: 12k',
      ),
    );
  }

  Widget _buildFollowingTab() {
    return const Center(
      child: Text(
        'Following: 321',
      ),
    );
  }
}
