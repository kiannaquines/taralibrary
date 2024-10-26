import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:taralibrary/utils/constants.dart';
import 'package:shimmer/shimmer.dart';

class CommentWidget extends StatefulWidget {
  final String userName;
  final String userProfile;
  final String commentDate;
  final String commentText;
  final int rating;

  const CommentWidget({
    super.key,
    required this.userName,
    required this.userProfile,
    required this.commentDate,
    required this.commentText,
    required this.rating,
  });

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  String get staticDir => ApiSettings.getStaticFileDir();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: '$staticDir${widget.userProfile}',
              width: 40,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => const Center(
                child: Icon(Icons.error),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.userName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) {
                          return Icon(
                            index < widget.rating &&
                                    widget.rating >= 1 &&
                                    widget.rating <= 5
                                ? Icons.star
                                : Icons.star_border,
                            color: index < widget.rating &&
                                    widget.rating >= 1 &&
                                    widget.rating <= 5
                                ? Colors.yellow
                                : Colors.grey,
                            size: 16,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      widget.commentDate,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  widget.commentText,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
