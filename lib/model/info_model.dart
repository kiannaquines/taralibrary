class RealTimeChartModel {
  final int count;
  final String time;

  RealTimeChartModel({
    required this.count,
    required this.time,
  });

  factory RealTimeChartModel.fromJson(Map<String, dynamic> json) {
    return RealTimeChartModel(
      count: json['count'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'time': time,
    };
  }
}

class ZoneImagesModel {
  final int imageZoneID;
  final String imageName;

  ZoneImagesModel({
    required this.imageZoneID,
    required this.imageName,
  });

  factory ZoneImagesModel.fromJson(Map<String, dynamic> json) {
    return ZoneImagesModel(
      imageZoneID: json['id'],
      imageName: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': imageZoneID,
      'image_url': imageName,
    };
  }
}

class CommentModel {
  final int commentID;
  final int zoneID;
  final String firstName;
  final String lastName;
  final int rating;
  final String comment;
  final String dateAdded;
  final String updateDate;
  final String profileImg;

  CommentModel({
    required this.commentID,
    required this.zoneID,
    required this.firstName,
    required this.lastName,
    required this.rating,
    required this.comment,
    required this.dateAdded,
    required this.updateDate,
    required this.profileImg,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commentID: json['id'],
      zoneID: json['zone_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      rating: json['rating'],
      comment: json['comment'],
      profileImg: json['profile_img'],
      dateAdded: json['date_added'],
      updateDate: json['update_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': commentID,
      'zone_id': zoneID,
      'first_name': firstName,
      'last_name': lastName,
      'rating': rating,
      'comment': comment,
      'profile_img': profileImg,
      'date_added': dateAdded,
      'update_date': updateDate,
    };
  }
}

class ZoneInfoModel {
  final int id;
  final String name;
  final double rating;
  final int review;
  final String description;
  final List<CommentModel> comments;
  final List<ZoneImagesModel> images;
  final List<RealTimeChartModel> chartData;

  ZoneInfoModel({
    required this.id,
    required this.name,
    required this.rating,
    required this.review,
    required this.description,
    required this.comments,
    required this.images,
    required this.chartData,
  });

  factory ZoneInfoModel.fromJson(Map<String, dynamic> json) {
    return ZoneInfoModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      rating: json['total_rating']?.toDouble() ?? 0.0,
      review: json['total_reviews'] ?? 0,
      description: json['description'] ?? '',
      comments: json['comments'] != null
          ? List<CommentModel>.from(
              json['comments'].map(
                (item) => CommentModel.fromJson(item),
              ),
            )
          : [],
      images: json['images'] != null
          ? List<ZoneImagesModel>.from(
              json['images'].map(
                (item) => ZoneImagesModel.fromJson(item),
              ),
            )
          : [],
      chartData: json['predictions'] != null
          ? List<RealTimeChartModel>.from(
              json['predictions'].map(
                (item) => RealTimeChartModel.fromJson(item),
              ),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'comments': comments.map((c) => c.toJson()).toList(),
      'images': images.map((img) => img.toJson()).toList(),
      'predictions': chartData.map((chart) => chart.toJson()).toList(),
      'total_rating': rating,
      'total_reviews': review,
    };
  }
}
