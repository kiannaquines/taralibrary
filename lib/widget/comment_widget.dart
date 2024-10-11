import 'package:flutter/material.dart';

class CommentWidget extends StatelessWidget {
  final String userName;
  final String userProfile;
  final String commentDate;
  final String commentText;
  final int rating;

  const CommentWidget({
    Key? key,
    required this.userName,
    required this.userProfile,
    required this.commentDate,
    required this.commentText,
    required this.rating,
  }) : super(key: key);

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
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
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
                      children: List.generate(
                        rating.clamp(0, 5),
                        (index) => const Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 16,
                        ),
                      ),
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
