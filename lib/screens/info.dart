import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:taralibrary/screens/home.dart';
import 'package:taralibrary/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:taralibrary/widget/comment_widget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen>
    with SingleTickerProviderStateMixin {
  bool isReadMore = false;
  bool isSeeMore = false;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final List<String> imageUrls = [
    'assets/images/4.jfif',
    'assets/images/5.jfif',
    'assets/images/6.jfif',
    'assets/images/2.jfif',
    'assets/images/1.jfif',
  ];

  @override
  Widget build(BuildContext context) {
    List<double> barValues = [5, 10, 8, 15, 20, 22, 30, 27, 23, 25, 29, 25, 29];
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
                    FlutterCarousel(
                      options: FlutterCarouselOptions(
                        height: MediaQuery.of(context).size.height * 0.4,
                        autoPlay: true,
                        autoPlayInterval: const Duration(milliseconds: 5000),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 1000),
                        enlargeCenterPage: false,
                        enableInfiniteScroll: true,
                        viewportFraction: 1,
                      ),
                      items: imageUrls.map((imageUrl) {
                        return Builder(
                          builder: (BuildContext context) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.asset(
                                imageUrl,
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                    Positioned(
                      top: 14,
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
              const SizedBox(height: 15.0),
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
                          fontSize: 16,
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
                          const SizedBox(width: 5),
                          const Text('4 Stars (365 Reviews)'),
                        ],
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isReadMore = !isReadMore;
                      });
                    },
                    child: Text(
                      isReadMore == false ? 'Read More' : 'Read Less',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
                child: isReadMore == false
                    ? const Text(
                        'The Information Technology section at the Kundo E. Pham Library and Research Centre (KEPLRC) serves as a vital hub for digital literacy and access to technological resources. This section is dedicated to fostering an environment where patrons can explore various aspects of information technology.',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      )
                    : const Text(
                        'The Information Technology section at the Kundo E. Pham Library and Research Centre (KEPLRC) serves as a vital hub for digital literacy and access to technological resources. This section is dedicated to fostering an environment where patrons can explore various aspects of information technology.',
                        overflow: TextOverflow.visible,
                        maxLines: null,
                      ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Facilities',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Offered Services',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isSeeMore = !isSeeMore;
                      });
                    },
                    child: Text(
                      isSeeMore == false ? 'See More' : 'See Less',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
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
              const SizedBox(height: 20),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
                child: Column(
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
                    if (isSeeMore) ...[
                      _buildTimelineTile(
                        'Free Access of Books',
                        'Equipped with latest collections of books.',
                      ),
                      _buildTimelineTile(
                        'Air Conditioned',
                        'Air conditioned rooms.',
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Real-Time Data Chart',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Text(
                'Information Technology visitors',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.dark.withOpacity(0.1),
                      blurRadius: 12,
                      spreadRadius: 3,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    height: 220,
                    width: 1000,
                    child: BarChart(
                      BarChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 5,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: AppColors.dark.withOpacity(0.1),
                              strokeWidth: 1,
                              dashArray: [5, 5],
                            );
                          },
                        ),
                        barTouchData: BarTouchData(
                          enabled: false,
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Container(
                                  padding: const EdgeInsets.only(
                                      left: 12.0, right: 8.0),
                                  child: Text(
                                    value.toInt().toString(),
                                    style: const TextStyle(
                                      color: Colors.black, // Make text visible
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            ),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 25,
                              getTitlesWidget: (value, meta) {
                                int index = value.toInt(); // Get the index
                                if (index >= 0 && index < barValues.length) {
                                  double actualValue =
                                      barValues[index]; // Get the actual value
                                  return Container(
                                    padding: const EdgeInsets.only(
                                      bottom: 8.0,
                                    ),
                                    child: Text(
                                      actualValue
                                          .toString(), // Display actual value
                                      style: const TextStyle(
                                        color:
                                            Colors.black, // Make text visible
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  );
                                }
                                return Container(); // Return empty container if out of bounds
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              getTitlesWidget: (value, meta) {
                                List<String> labels = [
                                  '7:00 am',
                                  '7:10 am',
                                  '7:20 am',
                                  '7:30 am',
                                  '7:40 am',
                                  '7:50 am',
                                  '8:00 am',
                                  '8:10 am',
                                  '8:20 am',
                                  '8:30 am',
                                  '8:40 am',
                                  '8:50 am',
                                  '9:00 am',
                                ];
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    labels[value.toInt()],
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        barGroups: List.generate(
                          barValues.length,
                          (index) => BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: barValues[index],
                                color: AppColors.primary,
                                width: 22,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              const SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _showCommentForm(context);
                    },
                    child: const Text(
                      'Leave a Comment',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              const Column(
                children: [
                  CommentWidget(
                    userName: 'Arden James D. Petras',
                    userProfile: 'assets/images/avatar-1.jpg',
                    commentDate: '2024-10-01',
                    commentText: 'Great resources available in this section!',
                    rating: 4,
                  ),
                  CommentWidget(
                    userName: 'Kian G. Naquines',
                    userProfile: 'assets/images/avatar-2.jpg',
                    commentDate: '2024-10-02',
                    commentText: 'Very helpful staff and facilities.',
                    rating: 5,
                  ),
                  CommentWidget(
                    userName: 'Catherine R. Maglinte',
                    userProfile: 'assets/images/avatar-3.jpg',
                    commentDate: '2024-10-03',
                    commentText: 'A wonderful place to learn and grow!',
                    rating: 5,
                  ),
                  CommentWidget(
                    userName: 'Irish M. Bianson',
                    userProfile: 'assets/images/avatar-3.jpg',
                    commentDate: '2024-10-03',
                    commentText: 'A wonderful place to learn and grow!',
                    rating: 5,
                  ),
                  CommentWidget(
                    userName: 'Jennifer M. Escote',
                    userProfile: 'assets/images/avatar-3.jpg',
                    commentDate: '2024-10-03',
                    commentText: 'A wonderful place to learn and grow!',
                    rating: 5,
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

  Widget _buildTimelineTile(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          const Icon(
            Icons.check,
            color: AppColors.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  description,
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCommentForm(BuildContext context) {
    double finalRating = 3;
    final TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          alignment: Alignment.center,
          icon: const Icon(Icons.face, color: AppColors.primary),
          backgroundColor: AppColors.white,
          title: const Text(
            'Leave a Comment',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemSize: 25.0,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    finalRating = rating;
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: commentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Write your comment',
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fillColor: AppColors.primary.withOpacity(0.1),
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    hintStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    String comment = commentController.text;
                    if (comment.isNotEmpty && finalRating > 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Comment submitted: "$comment" with $finalRating star${finalRating > 1 ? 's' : ''}'),
                        ),
                      );
                      commentController.clear();
                      finalRating = 0;
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Please enter a comment and select a rating!'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    foregroundColor: AppColors.primary,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text('Submit Comment'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
