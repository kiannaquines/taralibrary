import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:taralibrary/model/info_model.dart';
import 'package:taralibrary/model/profile_model.dart';
import 'package:taralibrary/screens/home.dart';
import 'package:taralibrary/screens/login.dart';
import 'package:taralibrary/service/comment_service.dart';
import 'package:taralibrary/service/info_service.dart';
import 'package:taralibrary/service/profile_service.dart';
import 'package:taralibrary/service/service_app.dart';
import 'package:taralibrary/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:taralibrary/utils/constants.dart';
import 'package:taralibrary/utils/storage.dart';
import 'package:taralibrary/widget/comment_widget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math' as math;

class InfoScreen extends StatefulWidget {
  final int zoneID;
  const InfoScreen({
    super.key,
    required this.zoneID,
  });

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen>
    with SingleTickerProviderStateMixin {
  bool isReadMore = false;
  bool isSeeMore = false;
  ZoneInfoModel? zoneInfo;
  late final AnimationController _controller;
  ApiSettings apiSettings = ApiSettings();
  CommentService commentService = CommentService();
  String get staticDir => ApiSettings.getStaticFileDir();

  @override
  void initState() {
    super.initState();
    _loadAccessToken();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  MyStorage myStorage = MyStorage();
  InfoService infoService = InfoService();
  ProfileService profileService = ProfileService();

  Future<String?> _loadAccessToken() async {
    Map<String, dynamic> tokenData = await myStorage.fetchAccessToken();
    await _loadInfo(tokenData['accessToken']);
    return tokenData['accessToken'];
  }

  Future<ProfileModel?> getCurrentUser() async {
    try {
      String? accessToken = await _loadAccessToken();
      ApiResponse<ProfileModel> response =
          await profileService.getProfile(accessToken!);
      if (response.result == ApiResult.success) {
        var jsonData = response.data;
        return jsonData;
      } else if (response.result == ApiResult.loginRequired) {
        debugPrint('Login required: ${response.errorMessage}');
      } else {
        debugPrint('Error fetching profile: ${response.errorMessage}');
      }
    } catch (e) {
      debugPrint('An error occurred: $e');
    }

    return null;
  }

  Future<void> _loadInfo(String accessToken) async {
    ApiResponse<ZoneInfoModel> response =
        await infoService.getZoneInformation(accessToken, widget.zoneID);

    switch (response.result) {
      case ApiResult.success:
        setState(() {
          zoneInfo = response.data!;
        });
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (zoneInfo == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
                      items: (zoneInfo?.images.isNotEmpty ?? false)
                          ? zoneInfo!.images.map((image) {
                              final imageUrl = '$staticDir${image.imageName}';
                              return Builder(
                                builder: (BuildContext context) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: CachedNetworkImage(
                                      imageUrl: imageUrl,
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width,
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Center(
                                        child: Icon(Icons.error),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList()
                          : [
                              const Center(
                                child: Text(
                                  'No images available',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
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
                      Text(
                        zoneInfo!.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 18,
                            color: Colors.yellow,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${zoneInfo!.rating} Stars (${zoneInfo!.review} Reviews)',
                          ),
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
                child: Text(
                  zoneInfo!.description,
                  overflow:
                      isReadMore ? TextOverflow.visible : TextOverflow.ellipsis,
                  maxLines: isReadMore ? null : 3,
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
                'Todays Visitor',
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
                    width: math.max(
                      MediaQuery.of(context).size.width,
                      zoneInfo!.chartData.length * 70.0,
                    ),
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
                                      color: Colors.black,
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
                                int index = value.toInt();
                                if (index >= 0 &&
                                    index < zoneInfo!.chartData.length) {
                                  double actualValue = zoneInfo!
                                      .chartData[index].count
                                      .toDouble();
                                  return Container(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      actualValue.toString(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  );
                                }
                                return Container();
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              getTitlesWidget: (value, meta) {
                                List<String> labels = zoneInfo!.chartData
                                    .map((chart) => chart.time)
                                    .toList();
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
                          zoneInfo!.chartData.length,
                          (index) => BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY:
                                    zoneInfo!.chartData[index].count.toDouble(),
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
                      'Positive Feedback?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Column(
                children: [
                  if (zoneInfo!.comments.isNotEmpty)
                    ...zoneInfo!.comments.map((comment) {
                      return CommentWidget(
                        userName: '${comment.firstName} ${comment.lastName}',
                        userProfile: 'assets/images/avatar-1.jpg',
                        commentDate: comment.dateAdded.toString(),
                        commentText: comment.comment,
                        rating: 4,
                      );
                    })
                  else
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: AppColors.dark.withOpacity(0.1),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(10.0),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.face_3,
                            size: 20,
                            color: AppColors.primary,
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: Text(
                              'Share your positive thought about this section!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20.0),
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

  void _showCommentForm(BuildContext context) async {
    ProfileModel? currentUser = await getCurrentUser();
    double finalRating = 3;
    final TextEditingController commentController = TextEditingController();
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need to log in to leave a comment.')),
      );
      return;
    }

    int userId = currentUser.id;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: AppColors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Leave a Comment',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10.5),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.primary,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
          content: SizedBox(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.dark.withOpacity(0.9),
                      fontSize: 16),
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
                    hintStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.dark.withOpacity(0.9),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
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
                ElevatedButton(
                  onPressed: () async {
                    int zoneId = widget.zoneID;
                    final String? accessToken = await _loadAccessToken();

                    String comment = commentController.text;
                    if (comment.isNotEmpty && finalRating > 0) {
                      if (accessToken != null) {
                        var response = await CommentService().postComment(
                          accessToken,
                          comment,
                          finalRating,
                          userId,
                          zoneId,
                        );

                        if (response.result == ApiResult.success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Comment submitted successfully!'),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Error submitting comment: ${response.errorMessage}',
                              ),
                            ),
                          );
                        }

                        commentController.clear();
                        finalRating = 0;
                        Navigator.of(context).pop();
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please enter a comment and select a rating!',
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
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
