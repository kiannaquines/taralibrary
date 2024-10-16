class AddCommentModel {
  final int zoneId;
  final int userId;
  final double rating;
  final String comment;

  AddCommentModel({
    required this.zoneId,
    required this.userId,
    required this.rating,
    required this.comment,
  });

  factory AddCommentModel.fromJson(Map<String, dynamic> json) {
    return AddCommentModel(
      zoneId: json['zoneId'] as int,
      userId: json['userId'] as int,
      rating: json['rating'] as double,
      comment: json['comment'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'zoneId': zoneId,
      'userId': userId,
      'rating': rating,
      'comment': comment,
    };
  }
}
