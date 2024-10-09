class RealTimeChartModel {
  final int predictionID;
  final int predictionCount;
  final String predictionTime;

  RealTimeChartModel({
    required this.predictionID,
    required this.predictionCount,
    required this.predictionTime,
  });

  factory RealTimeChartModel.fromJson(Map<String, dynamic> json) {
    return RealTimeChartModel(
      predictionID: json['predictionID'],
      predictionCount: json['predictionCount'],
      predictionTime: json['predictionTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'predictionID': predictionID,
      'predictionCount': predictionCount,
      'predictionTime': predictionTime,
    };
  }
}

class ZoneImagesModel {
  final int imageZoneID;
  final int zoneID;
  final String imageName;

  ZoneImagesModel({
    required this.imageZoneID,
    required this.zoneID,
    required this.imageName,
  });

  factory ZoneImagesModel.fromJson(Map<String, dynamic> json) {
    return ZoneImagesModel(
      imageZoneID: json['imageZoneID'],
      zoneID: json['zoneID'],
      imageName: json['imageName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageZoneID': imageZoneID,
      'zoneID': zoneID,
      'imageName': imageName,
    };
  }
}

class CommentModel {
  final int zoneID;
  final int commentID;
  final String commentName;
  final String commentDescription;
  final int rating;

  CommentModel({
    required this.zoneID,
    required this.commentID,
    required this.commentName,
    required this.commentDescription,
    required this.rating,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      zoneID: json['zoneID'],
      commentID: json['commentID'],
      commentName: json['commentName'],
      commentDescription: json['commentDescription'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commentID': commentID,
      'commentName': commentName,
      'commentDescription': commentDescription,
      'rating': rating,
    };
  }
}

class ZoneInfoModel {
  final int id;
  final String name;
  final int rating;
  final String description;
  final List<CommentModel> comments;
  final List<ZoneImagesModel> images;
  final List<RealTimeChartModel> chartData;

  ZoneInfoModel({
    required this.id,
    required this.name,
    required this.rating,
    required this.description,
    required this.comments,
    required this.images,
    required this.chartData,
  });

  factory ZoneInfoModel.fromJson(Map<String, dynamic> json) {
    var commentsArr = json['comments'] as List;
    List<CommentModel> commentsList = commentsArr
        .map(
          (item) => CommentModel.fromJson(
            item,
          ),
        )
        .toList();

    var imageArr = json['images'] as List;
    List<ZoneImagesModel> imageList = imageArr
        .map(
          (item) => ZoneImagesModel.fromJson(
            item,
          ),
        )
        .toList();

    var chartDataArr = json['chartData'] as List;
    List<RealTimeChartModel> chartDataList = chartDataArr
        .map(
          (item) => RealTimeChartModel.fromJson(
            item,
          ),
        )
        .toList();

    return ZoneInfoModel(
      id: json['id'],
      name: json['name'],
      rating: json['rating'],
      description: json['description'],
      comments: commentsList,
      images: imageList,
      chartData: chartDataList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rating': rating,
      'description': description,
      'comments': comments,
      'images': images,
      'chartData': chartData,
    };
  }
}
