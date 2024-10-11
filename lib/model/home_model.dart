class CategoryModel {
  final int id;
  final String name;

  CategoryModel({
    required this.id,
    required this.name,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['category_id'],
      name: json['category_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': id,
      'category_name': name,
    };
  }
}

class PopularModel {
  final int zoneID;
  final String image;
  final String title;
  final double rating;

  PopularModel({
    required this.zoneID,
    required this.image,
    required this.title,
    required this.rating,
  });

  factory PopularModel.fromJson(Map<String, dynamic> json) {
    return PopularModel(
      zoneID: json['section_id'],
      image: json['image_url'],
      title: json['section_name'],
      rating: (json['total_rating']).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'section_id': zoneID,
      'image_url': image,
      'section_name': title,
      'total_rating': rating,
    };
  }
}

class RecommendedModel {
  final int zoneID;
  final String image;
  final String title;
  final String description;
  final double rating;
  final String status;

  RecommendedModel({
    required this.zoneID,
    required this.image,
    required this.title,
    required this.description,
    required this.rating,
    required this.status,
  });

  factory RecommendedModel.fromJson(Map<String, dynamic> json) {
    return RecommendedModel(
      zoneID: json['section_id'],
      image: json['image_url'],
      title: json['section_name'],
      description: json['description'],
      rating: (json['total_rating']).toDouble(),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'section_id': zoneID,
      'image_url': image,
      'section_name': title,
      'description': description,
      'total_rating': rating,
      'status': status,
    };
  }
}
