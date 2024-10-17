class Categories {
  final String categoryName;

  Categories({
    required this.categoryName,
  });

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      categoryName: json['category_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_name': categoryName,
    };
  }
}

class AllSectionModel {
  final int zoneID;
  final String image;
  final String title;
  final String description;
  final double rating;
  final List<Categories> categories;

  AllSectionModel({
    required this.zoneID,
    required this.image,
    required this.title,
    required this.description,
    required this.rating,
    required this.categories,
  });

  factory AllSectionModel.fromJson(Map<String, dynamic> json) {
    return AllSectionModel(
      zoneID: json['section_id'],
      image: json['image_url'],
      title: json['section_name'],
      description: json['description'],
      rating: (json['total_rating'] as num).toDouble(),
      categories: json['categories'] != null
          ? List<Categories>.from(
              json['categories'].map(
                (item) => Categories.fromJson(item),
              ),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'section_id': zoneID,
      'image_url': image,
      'section_name': title,
      'description': description,
      'total_rating': rating,
      'categories': categories.map((category) => category.toJson()).toList(),
    };
  }
}
