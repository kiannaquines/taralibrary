import 'package:flutter/material.dart';
import 'package:taralibrary/screens/home.dart';
import 'package:taralibrary/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(
            top: 10.0,
            left: 20.0,
            right: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                child: Stack(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.asset(
                          'assets/images/4.jfif',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
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
                  ],
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Information Technology',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/star.svg',
                            colorFilter: const ColorFilter.mode(
                              Colors.yellow,
                              BlendMode.srcIn,
                            ),
                            width: 15,
                            height: 15,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text('4 Start (365 Reviews)'),
                        ],
                      )
                    ],
                  ),
                  const Text(
                    'Show Map',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'The Information Technology section at the Kundo E. Pham Library and Research Centre (KEPLRC) serves as a vital hub for digital literacy and access to technological resources.  This section is dedicated to fostering an environment where patrons can explore various aspects of information technology and',
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
              ),
              TextButton.icon(
                onPressed: () {},
                label: const Text('Read More'),
                icon: const Icon(Icons.arrow_drop_down_outlined),
                iconAlignment: IconAlignment.end,
              ),
              const Text(
                'Facilities',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFacilityIcon('assets/icons/computer-classic.svg'),
                  _buildFacilityIcon('assets/icons/desk.svg'),
                  _buildFacilityIcon('assets/icons/router-wifi.svg'),
                  _buildFacilityIcon('assets/icons/books.svg'),
                  _buildFacilityIcon('assets/icons/air-freshener.svg'),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  _buildTimelineTile(
                    'Computer Facilities',
                    'Equipped with high performance computers.',
                  ),
                  _buildTimelineTile(
                    'Study Desk',
                    'Provided with study desks.',
                  ),
                  _buildTimelineTile(
                    'Free Internet Access',
                    'Free internet access.',
                  ),
                  _buildTimelineTile(
                    'Free Access of Books',
                    'Equipped with latest collections of books.',
                  ),
                  _buildTimelineTile(
                    'Air Conditioned',
                    'Air conditioned rooms.',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFacilityIcon(String assetName) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        color: AppColors.primary.withOpacity(0.2),
        child: SvgPicture.asset(
          assetName,
          colorFilter: const ColorFilter.mode(
            AppColors.primary,
            BlendMode.srcIn,
          ),
          width: 30,
          height: 30,
        ),
      ),
    );
  }

  Widget _buildTimelineTile(String title, String status) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
            ),
            Container(
              width: 2,
              height: 50,
              color: AppColors.primary.withOpacity(0.2),
            ),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                status,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
