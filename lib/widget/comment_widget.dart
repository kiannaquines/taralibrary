import 'package:flutter/material.dart';

class CommentWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(userProfile),
            radius: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      commentDate,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: List.generate(5, (index) {
                        if (index < rating && rating >= 1 && rating <= 5) {
                          return const Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 16,
                          );
                        } else {
                          return const Icon(
                            Icons.star_border,
                            color: Colors.grey,
                            size: 16,
                          );
                        }
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  commentText,
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
