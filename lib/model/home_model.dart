class CategoryModel {
  final int id;
  final String name;

  CategoryModel({
    required this.id,
    required this.name,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class PopularModel {
  final String image;
  final String title;
  final int rating;

  PopularModel({
    required this.image,
    required this.title,
    required this.rating,
  });

  factory PopularModel.fromJson(Map<String, dynamic> json) {
    return PopularModel(
      image: json['image'],
      title: json['title'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'title': title,
      'rating': rating,
    };
  }
}

class RecommendedModel {
  final String image;
  final String title;
  final String description;

  RecommendedModel({
    required this.image,
    required this.title,
    required this.description,
  });

  factory RecommendedModel.fromJson(Map<String, dynamic> json) {
    return RecommendedModel(
      image: json['image'],
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'title': title,
      'description': description,
    };
  }
}
